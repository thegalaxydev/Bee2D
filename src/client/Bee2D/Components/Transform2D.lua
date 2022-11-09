local Transform2D = {}
local Matrix3 = require(script.Parent.Parent.Math.Matrix3)
Transform2D.__index = Transform2D

export type Transform = {
	Position: Matrix3.Matrix3,
	Rotation: Matrix3.Matrix3,
	LocalScale: Matrix3.Matrix3,
	Owner:  {},
	Local: Matrix3.Matrix3,
	RotationAngle: number,
}

function Transform2D.new(owner): Transform
	assert(owner.__class == "Actor", "Transform2D must be initialized with an Actor")
	local self = setmetatable({}, Transform2D)
	self.Local = Matrix3.Identity()
	self.Owner = owner
	self.Rotation = Matrix3.Identity()
	self.LocalScale = Matrix3.Identity()
	self.Translation = Matrix3.Identity()


	self.RotationAngle = 0;

	return self
end

function Transform2D:GetForward()
	return Vector2.new(self.Rotation.M00, self.Rotation.M01)
end

function Transform2D:GetUp()
	return Vector2.new(self.Rotation.M10, self.Rotation.M01)
end

function Transform2D:GetRotation(): number
	return self.RotationAngle
end

function Transform2D:SetRotation(m: Matrix3.Matrix3)
	assert(m.__class == "Matrix3", "Expected Matrix3, got "..typeof(m))
	self.Rotation = m
	self.RotationAngle = math.atan2(self.Local.M10, self.Local.M00);
end

function Transform2D:GetPosition(): Vector2
	return Vector2.new(self.Translation.M20, self.Translation.M21)
end

function Transform2D:SetPosition(v: Vector2)
	v = v :: Vector2
	self.Translation.M20 = v.X
	self.Translation.M21 = v.Y
end

function Transform2D:GetScale(): Vector2
	return Vector2.new(self.LocalScale.M00, self.LocalScale.M11)
end

function Transform2D:SetScale(v: Vector2)
	v = v :: Vector2
	self.LocalScale.M00 = v.X
	self.LocalScale.M11 = v.Y
end


return Transform2D