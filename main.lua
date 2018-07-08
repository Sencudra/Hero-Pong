--[[
Copyright (c) 2018 Uladzislau Tarasevich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--


-- Asking for the libraries and custom classes -- 

push = require 'push'
Class = require 'class'

require 'Ball'
require 'Paddle'
require 'Player'
require 'Menu'
require 'AI'

-- Global variables definition -- 

-- Actual window size
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 600

-- Low definition window
VIRTUAL_WIDTH = WINDOW_WIDTH/3
VIRTUAL_HEIGHT = WINDOW_HEIGHT/3

-- Objects' parameters
PADDLE_WIDTH = 3
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200

BALL_SIZE = 3

-- Game rules
ROUNDS = 10

--[[
	> love.load()
	> loadAssets()
	> love.resize(w, h)
	> setupGame()
	> restartGame()
	> love.update(dt)
	> love.draw()
	> displayFPS()
	> love.keypressed(key)
]]--

-- Main function 
function love.load()

	-- Using filter for low graphics effect
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	loadAssets()

	love.window.setTitle("Hero Pong")

	-- random generator initialising 
	math.randomseed(os.time()) 

	-- creating screen
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
		fullscreen = true,
		resizable = true,
		vsync = true
		})

	menu = Menu()
	--setupGame()

	gameState = 'start'
end

-- Loads such game assets as sounds and fonts
function loadAssets()

	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)
	nameFont = love.graphics.newFont('font.ttf', 32)
	medFont = love.graphics.newFont('font.ttf', 16)

	sounds = {
		['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static')
	}	
end

-- Screen resize function
function love.resize(w, h)
	push:resize(w,h)
end

-- Games setup function
function setupGame()

	ball = Ball(
		VIRTUAL_WIDTH / 2 - 2,
		VIRTUAL_HEIGHT / 2 - 2,
		BALL_SIZE,
		BALL_SIZE)

	paddle1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
	paddle2 = Paddle(
			VIRTUAL_WIDTH - PADDLE_WIDTH - 10,
			VIRTUAL_HEIGHT - PADDLE_HEIGHT - 30,
			PADDLE_WIDTH,
			PADDLE_HEIGHT
			)

	if menu.mode == 1 then 

		player1 = Player('Left Player',	paddle1)
		player2 = Player('Right Player', paddle2)

	elseif menu.mode == 0 then

		player1 = Player('Left Player',	paddle1)
		player2 = AI('Right Player', paddle2, ball)

	elseif menu.mode == 2 then

		player1 = AI('Left Player', paddle1, ball)
		player2 = AI('Right Player', paddle2, ball)

	end

	gameState = 'serve'

end

-- Restarts the game after win
function restartGame()
	player1.score = 0
	player2.score = 0
end

-- Update function 
function love.update(dt)

	if gameState == 'play' or gameState == 'serve' then
		-- player 1 movement
		if love.keyboard.isDown('w') then
			player1.paddle.dy = -PADDLE_SPEED
		elseif love.keyboard.isDown('s') then
	 		player1.paddle.dy = PADDLE_SPEED
	 	else
	 		player1.paddle.dy = 0
	 	end

	 	-- player 2 movement
	 	if love.keyboard.isDown('up') then
	 		player2.paddle.dy = -PADDLE_SPEED
	 	elseif love.keyboard.isDown('down') then
	 		player2.paddle.dy = PADDLE_SPEED
	 	else
	 		player2.paddle.dy = 0
	 	end

	 	-- ball movent while game state is 'Play'
	 	if gameState == 'play' then 

	 		-- Speed increase coeficient
	 		coef = 1.03 

			saveDistance = 2

	 		ball:update(dt)

	 		-- Collision for first paddle
	 		if ball:collides(player1.paddle) then 
	 			sounds.paddle_hit:play()
	 			ball.x = ball.x + saveDistance
				ball.dx = -ball.dx * coef

				if ball.dy < 0 then 
					ball.dy = -math.random(10,150)	
				else
					ball.dy = math.random(10,150)	
				end
			end

			-- Collision for second paddle
			if ball:collides(player2.paddle) then 
				sounds.paddle_hit:play()
				ball.x = ball.x - saveDistance
				ball.dx = -ball.dx * coef

				if ball.dy < 0 then 
					ball.dy = -math.random(40,150)	
				else
					ball.dy = math.random(40,150)	
				end
			end

			-- Collision with bottom and top edges of the window  --
			if ball.y < 0 then
				sounds.wall_hit:play()
				ball.y = 0
				ball.dy = -ball.dy
			elseif ball.y + ball.height > VIRTUAL_HEIGHT then
				sounds.wall_hit:play()
				ball.y = VIRTUAL_HEIGHT - ball.height
				ball.dy = -ball.dy
			end

			-- Game score process

			if ball.x < 0 then 
				sounds.score:play()
				servePlayer = 1
				player2:addScore()
				gameState = 'serve'
				ball:reset(2)
			elseif ball.x > VIRTUAL_WIDTH then 
				sounds.score:play()
				servePlayer = 2
				player1:addScore()
				gameState = 'serve'
				ball:reset(1)
			end

			if player1.score == ROUNDS then
				gameState = 'end'
				playerWins = 1
			elseif player2.score == ROUNDS then  
				gameState = 'end'
				playerWins = 2
			end

		end

		player1:update(dt)
		player2:update(dt)
	end
end

--[[
	Draw function
]]

function love.draw()

	push:apply('start')

	-- Background color
	love.graphics.clear(40/255,45/255,52/255,255/255)

	-- Start screen -- 
	if gameState == 'start' then 
		menu:render()
	else
		displayFPS()
		
		love.graphics.setColor(1,1,1,1)
		
		-- drawing two rectangles and a ball
		player1.paddle:render()
		player2.paddle:render()

		ball:render()

		-- End Screen -- 
		if gameState == 'end' then 
			love.graphics.setFont(medFont)
			if playerWins == 1 then 
				love.graphics.printf("Left player wins!", 0, 10, VIRTUAL_WIDTH, 'center')
			else
				love.graphics.printf("Right player wins!", 0, 10, VIRTUAL_WIDTH, 'center')
			end
			love.graphics.setFont(smallFont)
			love.graphics.printf("Press SPACE to restart!", 0, 30, VIRTUAL_WIDTH, 'center')
		end
		-- Serve screen -- 
		if gameState == 'serve' then 
			love.graphics.setFont(medFont)
			if servePlayer == 1 then 
				love.graphics.printf("Left player serve!", 0, 10, VIRTUAL_WIDTH, 'center')
			elseif servePlayer == 2 then 
				love.graphics.printf("Right player serve!", 0, 10, VIRTUAL_WIDTH, 'center')
			end
			love.graphics.setFont(smallFont)
			love.graphics.printf("Press SPACE to serve!", 0, 30, VIRTUAL_WIDTH, 'center')
		end

		if gameState == 'pause' then
			love.graphics.setFont(smallFont)
			love.graphics.printf("Press SPACE to continue the game!", 0, 30, VIRTUAL_WIDTH, 'center')
		end

		if gameState == 'play' then 
			love.graphics.printf("Press SPACE to pause the game!", 0, 30, VIRTUAL_WIDTH, 'center')
		end
			
		love.graphics.setFont(scoreFont)
		love.graphics.printf(tostring(player1.score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH)
		love.graphics.printf(tostring(player2.score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH)
		
	end
	push:apply('end')
end

-- Display Frames Per Second
function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(70/255,75/255,82/255,255/255)
	love.graphics.printf("FPS " .. tostring(love.timer.getFPS()), 0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 'center')
end

-- Keyboard input handler
function love.keypressed(key)

	-- exit from the game
	if key == 'escape' then
		if gameState ~= 'start' then 
			gameState = 'start'
		else
			love.event.quit()
		end
	end

	-- start/pause the game
	if key == 'space' then 
		if gameState == 'start' then 
			setupGame()
			gameState = 'serve'
		elseif gameState == 'serve' then 
			gameState = 'play'
		elseif gameState == 'end' then
			restartGame()
			gameState = 'serve'
		elseif gameState == 'pause' then
			gameState = 'play'
		else
			gameState = 'pause'
		end
	end

	-- add restart function
	if key == 'r' then
		restartGame()
	end

	if gameState == 'start' then 
		if key == 'left' then
			menu:arrowLeft()
		elseif key == 'right' then
		    menu:arrowRight()
		end 
	end
end





