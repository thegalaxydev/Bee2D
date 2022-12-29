local Sprite = {}
local Bee2D = require(script.Parent.Parent.Parent.Main)
local Transform2D = require(script.Parent.Parent.Transform2D)
Sprite.__index = Sprite
Sprite.__class = "Sprite"

export type Sprite = {
	Width: number,
	Height: number,
	Color: Color3,
	Image: string,
}

function Sprite.new(color: Color3, image: string)
	local self = setmetatable({}, Sprite)
	self.Width = newproxy()
	self.Height = newproxy()
	self.Color = color
	self.Image = image

	return self
end
function getScale()
	return Vector2.new((Bee2D.Fullscreen and Bee2D.WindowSizeAbsolute.X or Bee2D.WindowSize.X) * Bee2D.Camera.Zoom,
	(Bee2D.Fullscreen and Bee2D.WindowSizeAbsolute.Y or Bee2D.WindowSize.Y) * Bee2D.Camera.Zoom)
end

function Sprite:Draw(transform: Transform2D.Transform)
	self.Width = math.round(transform:GetGlobalScale().X);
	self.Height = math.round(transform:GetGlobalScale().Y);

	local position = Vector2.new(transform:GetGlobalPosition().X, transform:GetGlobalPosition().Y)
	local forward = Vector2.new(transform:GetForward().X, transform:GetForward().Y)
	local up = Vector2.new(transform:GetUp().X, transform:GetUp().Y)
	
	position -= forward * (self.Width / 2);
	position -= up * (self.Height / 2);
	

	local rotation = transform:GetGlobalRotationAngle();

	Bee2D.DrawSprite(self.Image, position, (rotation * 180 / math.pi), Vector2.new(self.Width, self.Height), self.Color)
end



return Sprite