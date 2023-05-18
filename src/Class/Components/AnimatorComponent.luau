local AnimatorComponent = {}
AnimatorComponent.__index = AnimatorComponent
AnimatorComponent.__class = "PhysicsComponent"

local TypeDef = require(script.Parent.Parent.TypeDef)

local Component = require(script.Parent.Component)
local Animation = require(script.Parent.Parent.Animation.Animation)
local Frame = require(script.Parent.Parent.Animation.Frame)

type Actor = TypeDef.Actor
type Component = Component.Component
type Animation = Animation.Animation

export type AnimatorComponent = {
	Animations: {Animation},
	CurrentAnimation: Animation,
	Playing: boolean,
} & typeof(AnimatorComponent) & typeof(Component)

setmetatable(AnimatorComponent, Component)

function AnimatorComponent.new(name: string, animations: {Animation}) : AnimatorComponent | Component
	local self = setmetatable(Component.new(name), AnimatorComponent)

	self.Animations = animations
	self.CurrentAnimation = self.Animations[1]
	self.Playing = false

	return self
end

function AnimatorComponent:Update(deltaTime: number)
	if not self.Playing then return end

	self.CurrentAnimation:Update(deltaTime)
end

function AnimatorComponent:Play()
	self.CurrentAnimation:Play()
	self.Playing = true
end

function AnimatorComponent:Stop()
	self.CurrentAnimation:Stop()
	self.Playing = false
end

function AnimatorComponent:SetAnimation(index: number)
	self.CurrentAnimation = self.Animations[index]
end

return AnimatorComponent