-- Renderer by Galaxy#1337
local Matrix3 = require(script.Parent.Parent.Math.Matrix3)
local Renderer = require(script.Parent.Parent.Renderer)
local TypeDef = require(script.Parent.TypeDef)

--- @class Transform2D
local Transform2D = {}
Transform2D.__index = Transform2D

type Matrix3 = Matrix3.Matrix3
type Actor = TypeDef.Actor

export type Transform = {
	Parent: Transform?,
	Children: {Transform},
	Owner: Actor,
	Local: Matrix3,
	Global: Matrix3,
	LocalRotation: Matrix3,
	LocalTranslation: Matrix3,
	LocalScale: Matrix3,
	LocalRotationAngle: number,
} & typeof(Transform2D)

--[=[
	Constructor for Transform2D

	@param owner Actor -- Owner of the transform

	@return Transform -- A new transform object
]=]
function Transform2D.new(owner: Actor): Transform
	local self = setmetatable({}, Transform2D)

	self.Local = Matrix3.Identity()
	self.Global = Matrix3.Identity()

	self.LocalRotation = Matrix3.Identity()
	self.LocalTranslation = Matrix3.Identity()
	self.LocalScale = Matrix3.Identity()

	self.Parent = nil
	self.Children = {}

	self.LocalRotationAngle = newproxy();

	self.Owner = owner

	return self
end

--[=[
	Returns all children of the Transform

	@return {Transform} -- All children of the Transform
]=]
function Transform2D:GetChildren() : {Transform}
	return self.Children
end

--[=[
	Returns the local rotation of the Transform

	@return Matrix3 -- Local rotation of the Transform
]=]
function Transform2D:GetLocalRotation()	: Matrix3
	return self.LocalRotation
end

--[=[
	Sets the local rotation of the Transform

	@param m Matrix3 -- Matrix to set the Transform to
]=]
function Transform2D:SetLocalRotation(m: Matrix3)
	self.LocalRotation = m;
	self.LocalRotationAngle = math.atan2(self.LocalRotation.M01, self.LocalRotation.M00)
end

--[=[
	Returns the local position of the Transform

	@return Vector2 -- Local position of the Transform
]=]
function Transform2D:GetLocalPosition() : Vector2
	return (Vector2.new(self.LocalTranslation.M02, self.LocalTranslation.M12) - Renderer.Camera.Position)
end

--[=[
	Sets the local position of the Transform

	@param v Vector2 -- Position to set the Transform to
]=]
function Transform2D:SetLocalPosition(v: Vector2)
	self.LocalTranslation.M02 = v.X
	self.LocalTranslation.M12 = v.Y
end

--[=[
	Returns the global position of the Transform

	@return Vector2 -- Global position of the Transform
]=]
function Transform2D:GetGlobalPosition() : Vector2
	return (Vector2.new(self.Global.M02, self.Global.M12) - Renderer.Camera.Position)
end

--[=[
	Sets the global position of the Transform
]=]
function Transform2D:GetLocalScale(): Vector2
	return Vector2.new(self.LocalScale.M00, self.LocalScale.M11) * Renderer.Camera.Zoom
end

--[=[
	Sets the local scale of the Transform

	@param v Vector2 -- Scale to set the Transform to
]=]
function Transform2D:SetLocalScale(v: Vector2)
	v = v :: Vector2
	self.LocalScale.M00 = v.X
	self.LocalScale.M11 = v.Y
end

--[=[
	Returns the global scale of the Transform

	@return Vector2 -- Global scale of the Transform
]=]
function Transform2D:GetGlobalScale(): Vector2
	local xAxis = Vector2.new(self.Global.M00, self.Global.M10);
	local yAxis = Vector2.new(self.Global.M01, self.Global.M11);

	return Vector2.new(xAxis.Magnitude, yAxis.Magnitude) * Renderer.Camera.Zoom;
end

--[=[
	Gets the forward facing vector of the Transform

	@return Vector2 -- Forward facing vector of the Transform
]=]
function Transform2D:GetForward(): Vector2
	return Vector2.new(self.Global.M00, self.Global.M10).Unit
end

--[=[
	Gets the up facing vector of the Transform

	@return Vector2 -- Up facing vector of the Transform
]=]
function Transform2D:GetUp()
	return Vector2.new(self.Global.M01, self.Global.M11).Unit
end

--[=[
	Gets the local rotation angle of the Transform

	@return number -- Local rotation angle of the Transform
]=]
function Transform2D:GetLocalRotationAngle(): number
	return self.LocalRotationAngle
end

--[=[
	Gets the global rotation angle of the Transform

	@return number -- Global rotation angle of the Transform
]=]
function Transform2D:GetGlobalRotationAngle(): number
	return math.atan2(self.Global.M01, self.Global.M00)
end

--[=[
	Translates the transform by a given `x` and `y` position.

	@param x number -- X position to translate by
	@param y number -- Y position to translate by
]=]
function Transform2D:Translate(x: number, y: number)
	self:SetLocalPosition(self:GetLocalPosition() + Vector2.new(x, y))
end

--[=[
	Translates the transform by a given `direction` vector.

	@param direction Vector2 -- Vector to translate by
]=]
function Transform2D:TranslateVector(direction: Vector2)
	self:SetLocalPosition(self:GetLocalPosition() + direction)
end

--[=[
	Adds a child to the Transform

	@param child Transform -- Child to add to the Transform
]=]
function Transform2D:AddChild(child: Transform)
	table.insert(self.Children, child)
	child.Parent = self
end

--[=[
	Removes a child from the Transform

	@param t Transform -- Child to remove from the Transform
]=]
function Transform2D:RemoveChild(t: Transform)
	for i, v in ipairs(self.Children) do
		if (v == t) then
			table.remove(self.Children, i)
			t.Parent = nil
			break
		end
	end
end

--[=[
	Updates the transform matrix.
]=]
function Transform2D:UpdateTransform()
	self.Local = self.LocalTranslation * self.LocalRotation * self.LocalScale

	if (self.Parent ~= nil) then
		self.Global = self.Parent.Global * self.Local
	else
		self.Global = self.Local
	end
end

return Transform2D