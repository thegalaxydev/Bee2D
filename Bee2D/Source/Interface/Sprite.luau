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
	CacheIndex: number?
}

type Transform = Transform2D.Transform

function Sprite.new(color: Color3, image: string)
	local self = setmetatable({}, Sprite)
	self.Width = newproxy()
	self.Height = newproxy()
	self.Color = color
	self.CacheIndex = nil
	self.Image = image

	return self
end

function Sprite:Draw(transform: Transform)
	self.Width = math.round(transform:GetGlobalScale().X);
	self.Height = math.round(transform:GetGlobalScale().Y);

	local position = Vector2.new(transform:GetGlobalPosition().X, transform:GetGlobalPosition().Y)
	local forward = Vector2.new(transform:GetForward().X, transform:GetForward().Y)
	local up = Vector2.new(transform:GetUp().X, transform:GetUp().Y)

	position -= forward * (self.Width / 2);
	position -= up * (self.Height / 2);

	local rotation = transform:GetGlobalRotationAngle();

	return Bee2D.DrawImage(self.Image, position + Bee2D.Camera.Position, (rotation * 180 / math.pi), 
		Vector2.new(self.Width, self.Height), self.Color, self.CacheIndex)
end

return Sprite