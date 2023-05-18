local SpriteComponent = {}
SpriteComponent.__index = SpriteComponent
SpriteComponent.__class = "PhysicsComponent"

local Bee2D = require(script.Parent.Parent.Parent.Renderer)

local TypeDef = require(script.Parent.Parent.TypeDef)

local Component = require(script.Parent.Component)

type Actor = TypeDef.Actor
type Component = Component.Component

export type SpriteComponent = {
	Owner: Actor,
	Name: string,
	Update: (deltaTime: number) -> nil,
	OnCollision: () -> nil,
} & typeof(SpriteComponent) & typeof(Component)

setmetatable(SpriteComponent, Component)

function SpriteComponent.new(name: string, image: string, color: Color3, Pixelated: boolean?) : SpriteComponent
	local self = setmetatable(Component.new(name), SpriteComponent) 
	
	self.Width = 0;
	self.Height = 0;
	self.Color = color
	self.CacheIndex = nil
	self.Image = image

	self.Pixelated = Pixelated or false

	return self
end

function SpriteComponent:Draw()
	local transform = self.Owner.Transform

	self.Width = math.round(transform:GetGlobalScale().X);
	self.Height = math.round(transform:GetGlobalScale().Y);

	local position = Vector2.new(transform:GetGlobalPosition().X, transform:GetGlobalPosition().Y)
	local forward = Vector2.new(transform:GetForward().X, transform:GetForward().Y)
	local up = Vector2.new(transform:GetUp().X, transform:GetUp().Y)

	position -= forward * (self.Width / 2);
	position -= up * (self.Height / 2);

	local rotation = transform:GetGlobalRotationAngle();

	return Bee2D.DrawImage(self.Image, position + Bee2D.Camera.Position, (rotation * 180 / math.pi), 
		Vector2.new(self.Width, self.Height), self.Color, self.Pixelated, self.CacheIndex)	
end


return SpriteComponent