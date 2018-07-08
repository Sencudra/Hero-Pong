
-- Class Player for Pong -- 

Player = Class{}

function Player:init(name, paddle)
	self.name = name
	self.paddle = paddle
	self.score = 0	
end

function Player:update(dt)
	self.paddle:update(dt)
end

function Player:addScore()
	self.score = self.score + 1
end
