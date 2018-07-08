
-- Menu Class for Pong -- 

--[[
	Player can choose one of three modes available:
	0 - Singleplayer with AI
	1 - Multiplayer with another player
	2 - Watch how bots are playing
]]

Menu = Class{}

function Menu:init()
	self.mode = 0
end


function Menu:render()
	
	-- Game name printf --
	love.graphics.setFont(nameFont)
	love.graphics.setColor(1,1,1)
	love.graphics.printf("Hero Pong", 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

	-- Menu printf with highlight --
	love.graphics.setFont(smallFont)
	if self.mode == 0 then
		love.graphics.setColor(1,1,1)
 	else
		love.graphics.setColor(70/255,75/255,82/255,255/255)
	end
	love.graphics.printf("Singleplayer", VIRTUAL_WIDTH*2/5 - VIRTUAL_WIDTH/6, VIRTUAL_HEIGHT/2 + 10, VIRTUAL_WIDTH)
	
	if self.mode == 1 then
		love.graphics.setColor(1,1,1)
 	else
		love.graphics.setColor(70/255,75/255,82/255,255/255)
	end
	love.graphics.printf("Multiplayer", VIRTUAL_WIDTH*3/5 - VIRTUAL_WIDTH/6, VIRTUAL_HEIGHT/2 + 10, VIRTUAL_WIDTH)
	
	if self.mode == 2 then
		love.graphics.setColor(1,1,1)
 	else
		love.graphics.setColor(70/255,75/255,82/255,255/255)
	end
	love.graphics.printf("Roboplayer", VIRTUAL_WIDTH*4/5 - VIRTUAL_WIDTH/6, VIRTUAL_HEIGHT/2 + 10, VIRTUAL_WIDTH)

	-- Help tip -
	love.graphics.setColor(70/255,75/255,82/255,255/255)
	love.graphics.printf("Choose MODE with arrows and press SPACE to start...", 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
	love.graphics.printf("> Press ESC to quit...", 10, 10, VIRTUAL_WIDTH)
	
end


-- maintain keyboard arrow pressing in the menu

function Menu:arrowLeft()
	if self.mode == 0 then 
		self.mode = 2
	else 
		self.mode = self.mode - 1
	end
end

function Menu:arrowRight()
	if self.mode == 2 then 
		self.mode = 0
	else 
		self.mode = self.mode + 1
	end
end
