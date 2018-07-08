
-- Ai for Pong -- 

AI = Class{}

function AI:init(name, paddle, ball)
	self.name = name
	self.paddle = paddle
	self.score = 0
	self.target = ball
end

function AI:update(dt)
	if self.paddle.y + self.paddle.height < self.target.y then
		self.paddle.dy = PADDLE_SPEED  
	elseif self.paddle.y > self.target.y then 
		self.paddle.dy = -PADDLE_SPEED
	else
		self.paddle.dy = 0
	end
	self.paddle:update(dt)
end

function AI:addScore()
	self.score = self.score + 1
end


