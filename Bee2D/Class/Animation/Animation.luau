local Animation = {}
Animation.__index = Animation
local TypeDef = require(script.Parent.Parent.TypeDef)
local Frame = require(script.Parent.Frame)

type Frame = Frame.Frame;
type Actor = TypeDef.Actor;

export type Animation = {
	Frames: {Frame},
	FrameRate: number,
	Loop: boolean,
	Owner: Actor,
}

function Animation.new(frames: {Frame}, frameRate: number, loop: boolean) : Animation
	local self = setmetatable({}, Animation)

	self.Owner = nil;

	self.Frames = frames
	self.FrameRate = frameRate
	self.Loop = loop

	self._currentFrame = 1;
	self._timeElapsed = 0;
	self._playing = false;

	return self
end

function Animation:Stop()
	self._playing = false
end

function Animation:Play()
	local spriteComponent = self.Owner:GetComponent("SpriteComponent")
	
	self._playing = true
	self._timeElapsed = 0
	self._currentFrame = 1

	spriteComponent.Texture = self.Frames[1].Image

end

function Animation:Update(deltaTime: number)
	if not self._playing then return end

	local spriteComponent = self.Owner:GetComponent("SpriteComponent")
	

	self._timeElapsed = self._timeElapsed + deltaTime
	local timePerFrame = 1 / self.FrameRate

	if self._timeElapsed < timePerFrame then return end
	
	if self._currentFrame <= #self.Frames then
		spriteComponent.Texture = self.Frames[self._currentFrame].Image
		self._currentFrame += 1
	elseif (self.Loop) then
		self._currentFrame = 1
	else
		self:Stop()
	end
end


return Animation