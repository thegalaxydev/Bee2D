-- Bee2D by Galaxy#1337
local Transform2D = require(script.Parent.Transform2D)
local Sprite = require(script.Parent.Interface.Sprite)
local Component = require(script.Parent.Components.Component)

--- @class Actor
--- The main actor class. This is the basis of all game objects for Bee2D.
local Actor = {}
Actor.__index = Actor

type Sprite = Sprite.Sprite
type Component = Component.Component
type Transform = Transform2D.Transform

export type Actor = {
	Name: string,
	Transform: Transform,
	Active: boolean,
	Graphic: Sprite,
	Components: {Component},
} & typeof(Actor)

--[=[
	Main constructor for Actor provided a name and a sprite.

	@param name string -- The name of the actor. This will be used to identify the actor and remove it from scenes.
	@param graphic Sprite -- The sprite of the actor. This will be used to draw the actor to the screen.

	@return Actor -- A new actor object
]=]
function Actor.new(name: string, graphic: Sprite) : Actor
	local self = setmetatable({}, Actor)

	self._lastPosition = Vector2.new(0, 0)
	self.Active = true
	self.Name = name
	self.Graphic = graphic
	self.Transform = Transform2D.new(self)
	self.Components = {}

	return self
end

--[=[
	Start method for Actor, which is called at the beginning of a scene before the first update call.
]=]
function Actor:Start()
end

--[=[
	Adds a component to the actor.

	@param component -- Component The component to add to the actor.
]=]
function Actor:AddComponent(component: Component)
	component.Owner = self;
	table.insert(self.Components, component)
end

--[=[
	Removes a component from the actor.

	@param component Component -- The component to remove from the actor.
]=]
function Actor:RemoveComponent(component: Component)
	for i, comp in pairs(self.comp) do
		if comp == component then
			table.remove(self.comp, i)
		end
	end
end

--[=[
	Gets a component from the actor.

	@param name string -- The name of the component to get.

	@return Component? -- The component if it exists, nil otherwise.
]=]
function Actor:GetComponent(name: string) : Component?
	for _, comp in pairs(self.Components) do
		if comp.Name == name then
			return comp
		end
	end

	return
end

--[=[
	Updates the actor and all of its components. This is called every frame.

	@param deltaTime number -- The time since the last update call.
]=]
function Actor:Update(deltaTime: number)
	self.Transform:UpdateTransform();

	for _, comp in pairs(self.Components) do
		comp:Update(deltaTime)
	end
end

--[=[
	Called when the actor collides with another actor. This is called every frame.

	@param other Actor -- The other actor that the actor collided with.
]=]
function Actor:OnCollision(other: Actor)
	for _, comp in pairs(self.Components) do
		comp:OnCollision(other)
	end
end

--[=[
	Translates the actor by a given direction.

	@param direction Vector2 -- The direction to translate the actor by.
]=]
function Actor:Translate(direction: Vector2)
	self.Transform:SetLocalPosition(self.Transform:GetLocalPosition() + direction)
end

--[=[
	Draws the actor's graphic on the screen. This is called every frame.
]=]
function Actor:Draw() : GuiObject?
	local graphic
	if self.Graphic then
		graphic = self.Graphic:Draw(self.Transform)
	end

	return graphic
end

return Actor