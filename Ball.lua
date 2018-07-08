
-- Class Ball for Pong --

Ball = Class{}

function Ball:init(x, y, width, height)
	self.x = x 
	self.y = y 
	self.width = width 
	self.height = height 
	self.ddy = 0

	self.dx = math.random(2) == 1 and 100 or -100
	self.dy = math.random(-60,60)
end

--[[
	Resets ball's characteristics to the start state
]]
function Ball:reset(serve)
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	self.dy = math.random(-60,60)

	--[[
		Ball direction: 0 - default (random),
	 	1 - after 2 player win,
	 	2 - after 1 player win
	]] 
	if serve == 1 then 
		self.dx = -100
	elseif serve == 2 then 
		self.dx = 100
	else
		self.dx = math.random(2) == 1 and 100 or -100
	end

end

--[[
	Updates ball's position according to the time dt
]]
function Ball:update(dt)
	self.x = self.x + self.dx * dt 
	self.y = self.y + self.dy * dt
end

--[[
	Render the ball
]]
function Ball:render()
	love.graphics.rectangle('fill', self.x, self.y,
	self.width, self.height)
end

--[[
	Ball collision
]]
function Ball:collides(paddle)
	
	coef = 1.03
	saveDistance = 2

	-- For x axis collisions -- 

	if self.x > paddle.x + paddle.width or paddle.x  > self.x + self.width then 
		return false
	end

	if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then 
		return false 
	end

	return true
end
