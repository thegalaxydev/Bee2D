local Matrix3 = {}

export type Matrix3 = {
	M00: number, M01: number, M02: number,
	M10: number, M11: number, M12: number,
	M20: number, M21: number, M22: number,

	Identity: Matrix3
}

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
			return string.format("Matrix3(%s, %s, %s, %s, %s, %s, %s, %s, %s)", 
			self.M00, self.M01, self.M02, self.M10, self.M11, self.M12, self.M20, self.M21, self.M22)
		end
	})

	return self
end

function Matrix3.Identity()
	return Matrix3.new(1, 0, 0, 0, 1, 0, 0, 0, 1)
end

function Matrix3.FromArray(a): Matrix3
	return Matrix3.new(
		a[1], a[4], a[7],
		a[2], a[5], a[8],
		a[3], a[6], a[9])
end


function Matrix3.CreateRotation(radians: number): Matrix3
	local cos = math.cos(radians)
	local sin = math.sin(radians)
	return Matrix3.new(cos, sin, 0, -sin, cos, 0, 0, 0, 1);
end

function Matrix3.CreateTranslation(x: number, y:number): Matrix3
	return Matrix3.new(1,0,0,0,1,0,x,y,1)
end

function Matrix3.CreateScale(x: number, y: number): Matrix3
	return Matrix3.new(x,0,0,0,y,0,0,0,1)
end

function Matrix3.__mul(lhs, rhs): Matrix3
	local result = {}

	for i = 0, 2 do
		for j = 0, 2 do
			for k = 0, 2 do
				result[i*3+j+1] += lhs[k*3+i+1]*rhs[j*3+k+1]
			end
		end
	end
	return Matrix3.FromArray(result)
end

function Matrix3.__add(lhs, rhs): Matrix3
	return Matrix3.new(
	 lhs.M00 + rhs.M00, lhs.M01 + rhs.M01, lhs.M02 + rhs.M02,
	lhs.M10 + rhs.M10, lhs.M11 + rhs.M11, lhs.M02 + rhs.M12,
	lhs.M20 + rhs.M20, lhs.M21 + rhs.M21, lhs.M22 + rhs.M22);
end

function Matrix3.__sub(lhs, rhs): Matrix3
	return Matrix3.new(lhs.M00 - rhs.M00, lhs.M01 - rhs.M01, lhs.M02 - rhs.M02,
	lhs.M10 - rhs.M10, lhs.M11 - rhs.M11, lhs.M02 - rhs.M12,
	lhs.M20 - rhs.M20, lhs.M21 - rhs.M21, lhs.M22 - rhs.M22);
end

return Matrix3