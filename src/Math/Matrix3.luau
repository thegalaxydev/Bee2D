-- Bee2D by Galaxy#1337

--- @class Matrix3
local Matrix3 = {}

export type Matrix3 = {
	M00: number, M01: number, M02: number,
	M10: number, M11: number, M12: number,
	M20: number, M21: number, M22: number,

	Identity: Matrix3
}

--[=[
This is the default constructor for the `Matrix3` class.

@tag Matrix3

@param m00 number
@param m01 number
@param m02 number
@param m10 number
@param m11 number
@param m12 number
@param m20 number
@param m21 number
@param m22 number

]=]
function Matrix3.new(m00: number, m01: number, m02: number,
					m10: number, m11: number, m12: number,
					m20: number, m21: number, m22: number)
	local self = setmetatable({
		M00 = m00, M01 = m01, M02 = m02,
		M10 = m10, M11 = m11, M12 = m12,
		M20 = m20, M21 = m21, M22 = m22
	}, {
		__index = Matrix3,
		__class = "Matrix3",

		__tostring = function(self)
			return string.format("{ %s, %s, %s }, { %s, %s, %s }, { %s, %s, %s }", 
			self.M00, self.M01, self.M02, self.M10, self.M11, self.M12, self.M20, self.M21, self.M22)
		end,

		__mul = function(lhs,rhs) : Matrix3
			return Matrix3.new(
			(lhs.M00 * rhs.M00) + (lhs.M01 * rhs.M10) + (lhs.M02 * rhs.M20),
			(lhs.M00 * rhs.M01) + (lhs.M01 * rhs.M11) + (lhs.M02 * rhs.M21),
			(lhs.M00 * rhs.M02) + (lhs.M01 * rhs.M12) + (lhs.M02 * rhs.M22),

			(lhs.M10 * rhs.M00) + (lhs.M11 * rhs.M10) + (lhs.M12 * rhs.M20),
			(lhs.M10 * rhs.M01) + (lhs.M11 * rhs.M11) + (lhs.M12 * rhs.M21),
			(lhs.M10 * rhs.M02) + (lhs.M11 * rhs.M12) + (lhs.M12 * rhs.M22),

			(lhs.M20 * rhs.M00) + (lhs.M21 * rhs.M01) + (lhs.M22 * rhs.M20),
			(lhs.M20 * rhs.M01) + (lhs.M21 * rhs.M11) + (lhs.M22 * rhs.M21),
			(lhs.M20 * rhs.M02) + (lhs.M21 * rhs.M12) + (lhs.M22 * rhs.M22));
		end,
		
		__add = function(lhs, rhs): Matrix3
			return Matrix3.new(
			 lhs.M00 + rhs.M00, lhs.M01 + rhs.M01, lhs.M02 + rhs.M02,
			lhs.M10 + rhs.M10, lhs.M11 + rhs.M11, lhs.M02 + rhs.M12,
			lhs.M20 + rhs.M20, lhs.M21 + rhs.M21, lhs.M22 + rhs.M22);
		end,
		
		__sub = function(lhs, rhs): Matrix3
			return Matrix3.new(lhs.M00 - rhs.M00, lhs.M01 - rhs.M01, lhs.M02 - rhs.M02,
			lhs.M10 - rhs.M10, lhs.M11 - rhs.M11, lhs.M02 - rhs.M12,
			lhs.M20 - rhs.M20, lhs.M21 - rhs.M21, lhs.M22 - rhs.M22);
		end
	})

	return self
end

--[=[
	Default identity return for Matrix3

	@tag Matrix3
	
	@return Matrix3 -- New Matrix3 [1, 0, 0] [0, 1, 0] [0, 0, 1]
]=]
function Matrix3.Identity()
	return Matrix3.new(1, 0, 0, 0, 1, 0, 0, 0, 1)
end

--[=[
	Returns a new Matrix3 given an array.

	@tag Matrix3

	@return Matrix3 -- New Matrix3 from the given array.
]=]
function Matrix3.FromArray(a: {number}): Matrix3
	return Matrix3.new(
		a[1], a[4], a[7],
		a[2], a[5], a[8],
		a[3], a[6], a[9])
end

--[=[
	Creates a rotation matrix given a rotation in radians.
	
	@tag Matrix3

	@param radians -- The rotation amount in radians.

	@return Matrix3 -- New Matrix3 rotation matrix.
]=]
function Matrix3.CreateRotation(radians: number): Matrix3
	local cos = math.cos(radians)
	local sin = math.sin(radians)
	return Matrix3.new(cos, sin, 0, -sin, cos, 0, 0, 0, 1);
end

--[=[
	Creates a new translation matrix given an x and y position.
	@tag Matrix3

	@param x -- The x position.
	@param y -- The y position.

	@return Matrix3 -- New Matrix3 translation matrix.
]=]
function Matrix3.CreateTranslation(x: number, y:number): Matrix3
	return Matrix3.new(1,0,0,0,1,0,x,y,1)
end

--[=[
	Creates a new scale matrix given an x and y scale.
	@tag Matrix3

	@param x -- The x scale.
	@param y -- The y scale.

	@return Matrix3 -- New Matrix3 scale matrix.
]=]
function Matrix3.CreateScale(x: number, y: number): Matrix3
	return Matrix3.new(x,0,0,0,y,0,0,0,1)
end

return Matrix3