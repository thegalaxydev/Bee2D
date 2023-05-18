local SpriteSheetComponent = {}
local SpriteComponent = require(script.Parent.Parent.Components.SpriteComponent)
local Renderer = require(script.Parent.Parent.Parent.Renderer)
SpriteSheetComponent.__index = SpriteSheetComponent

export type SpriteSheetComponent = typeof(SpriteSheetComponent) & typeof(SpriteComponent)

setmetatable(SpriteSheetComponent, SpriteComponent)
function SpriteSheetComponent.new(name: string, image: string, sheetSize: Vector2, pixelized: boolean?)
	local self = setmetatable(SpriteComponent.new(name, image, Color3.new(1,1,1), pixelized), SpriteSheetComponent)

	self.SheetSize = sheetSize
	self.SheetPosition = Vector2.new(0,0)
	self.CacheIndex = nil

	return self
end

function SpriteSheetComponent:MoveTo(x: number, y: number)
	self.SheetPosition = Vector2.new(-x,-y)
end

function SpriteSheetComponent:Draw()
	local transform = self.Owner.Transform

	self.Width = math.round(transform:GetGlobalScale().X);
	self.Height = math.round(transform:GetGlobalScale().Y);

	local position = Vector2.new(transform:GetGlobalPosition().X, transform:GetGlobalPosition().Y)
	local forward = Vector2.new(transform:GetForward().X, transform:GetForward().Y)
	local up = Vector2.new(transform:GetUp().X, transform:GetUp().Y)

	position -= forward * (self.Width / 2);
	position -= up * (self.Height / 2);

	local rotation = transform:GetGlobalRotationAngle();

	return Renderer.DrawSpriteSheet(self.Image, position + Renderer.Camera.Position, (rotation * 180 / math.pi), 
		Vector2.new(self.Width, self.Height), self.SheetSize, self.SheetPosition, self.Pixelated, self.CacheIndex)	
end

return SpriteSheetComponent


