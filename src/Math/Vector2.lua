local Vector2 = {}
Vector2.__index = Vector2
Vector2.__class = "Vector2"


function Vector2.new(x: number, y: number): Vector2
    local self = setmetatable({}, Vector2)
    self.X = x
    self.Y = y

    self.Magnitude = math.sqrt(self.X * self.X + self.Y * self.Y)
    self.Normalized = self.Magnitude > 0 and Vector2.new(self.X / self.Magnitude, self.Y / self.Magnitude) or Vector2.Zero;

    return self
end

function Vector2:Scale(n: number)
    return Vector2.new(self.X * n, self.Y * n)
end

Vector2.Zero = Vector2.new(0, 0)
Vector2.One = Vector2.new(1, 1)

Vector2.UnitX = Vector2.new(1, 0)
Vector2.UnitY = Vector2.new(0, 1)


function Vector2.Normalize(vector: Vector2): Vector2
    return vector.Magnitude > 0 and Vector2.new(vector.X / vector.Magnitude, vector.Y / vector.Magnitude) or Vector2.Zero;
end

function Vector2.Distance(a: Vector2, b: Vector2): number
    return (a - b).Magnitude
end

function Vector2.Dot(a: Vector2, b: Vector2): number
    return a.X * b.X + a.Y * b.Y
end

function Vector2.__add(a: Vector2, b: Vector2): Vector2
    return Vector2.new(a.X + b.X, a.Y + b.Y)
end

function Vector2.__sub(a: Vector2, b: Vector2): Vector2
    return Vector2.new(a.X - b.X, a.Y - b.Y)
end

function Vector2.__mul(a: Vector2, b: Vector2): Vector2
    a = a.Normalized
    b = b.Normalized
    return Vector2.new(a.X * b.X + a.Y * b.Y, a.X * b.X + a.Y * b.Y)
end


return Vector2