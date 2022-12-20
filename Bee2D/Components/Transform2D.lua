local Transform2D = {}
local Matrix3 = require(script.Parent.Parent.Math.Matrix3)
Transform2D.__index = Transform2D

export type Transform = {}

function Transform2D.new(owner): Transform
	assert(owner.__class == "Actor", "Transform2D must be initialized with an Actor")
	local self = setmetatable({}, Transform2D)

	self.Local = Matrix3.Identity()
	self.Global = Matrix3.Identity()

	self.LocalRotation = Matrix3.Identity()
	self.LocalTranslation = Matrix3.Identity()
	self.LocalScale = Matrix3.Identity()

	self.Parent = newproxy()
	self.Children = {}

	self.LocalRotationAngle = 0;

	self.Owner = owner

	return self
end

function Transform2D:GetChildren() : {Transform}
	return self.Children
end

function Transform2D:GetLocalRotation()	: Matrix3.Matrix3
	return self.LocalRotation
end

function Transform2D:SetLocalRotation(m: Matrix3.Matrix3)
	self.LocalRotation = m;
	self.LocalRotationAngle = math.atan2(self.LocalRotation.M01, self.LocalRotation.M00)
end

function Transform2D:GetLocalPosition() : Vector2
	return Vector2.new(self.LocalTranslation.M02, self.LocalTranslation.M12)
end

function Transform2D:SetLocalPosition(v: Vector2)
	self.LocalTranslation.M02 = v.X
	self.LocalTranslation.M12 = v.Y
end

function Transform2D:GetGlobalPosition() : Vector2
	return Vector2.new(self.Global.M02, self.Global.M12)
end


function Transform2D:GetLocalScale(): Vector2
	return Vector2.new(self.LocalScale.M00, self.LocalScale.M11)
end

function Transform2D:SetLocalScale(v: Vector2)
	v = v :: Vector2
	self.LocalScale.M00 = v.X
	self.LocalScale.M11 = v.Y
end

function Transform2D:GetGlobalScale()
	local xAxis = Vector2.new(self.Global.M00, self.Global.M10);
	local yAxis = Vector2.new(self.Global.M01, self.Global.M11);

	return Vector2.new(xAxis.Magnitude, yAxis.Magnitude);
end

function Transform2D:GetForward()
	return Vector2.new(self.Global.M00, self.Global.M10).Unit
end

function Transform2D:GetUp()
	return Vector2.new(self.Global.M01, self.Global.M11).Unit
end

function Transform2D:GetLocalRotationAngle(): number
	return self.LocalRotationAngle
end

function Transform2D:GetGlobalRotationAngle(): number
	return math.atan2(self.Global.M01, self.Global.M00)
end

function Transform2D:Translate(x: number, y: number)
	self:SetLocalPosition(self:GetLocalPosition() + Vector2.new(x, y))
end

function Transform2D:TranslateVector(direction: Vector2)
	self:SetLocalPosition(self:GetLocalPosition() + direction)
end

function Transform2D:AddChild(child: Transform)
	table.insert(self.Children, child)
	child.Parent = self
end

function Transform2D:RemoveChild(t: Transform)
	for i, v in ipairs(self.Children) do
		if (v == t) then
			table.remove(self.Children, i)
			t.Parent = nil
			break
		end
	end
end

function Transform2D:UpdateTransform()
	self.Local = self.LocalTranslation * self.LocalRotation * self.LocalScale

	if (self.Parent ~= nil) then
		self.Global = self.Parent.Global * self.Local
	else
		self.Global = self.Local
	end
end

return Transform2D