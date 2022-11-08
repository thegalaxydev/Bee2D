local CircleCollider = {}
CircleCollider.__index = CircleCollider
CircleCollider.__class = "CircleCollision"

export type CircleCollider = {
    Radius: number,
    Position: Vector2,
    Owner: {},
}

function CircleCollider.new(radius: number, owner: {})
    local self = setmetatable({}, {__index = CircleCollider})
    self.Radius = radius
    self.Owner = owner

    return self
end

function CircleCollider:CheckCircleCollision(other: CircleCollider): boolean
    assert(other.__class == "CircleCollider", "[Bee2D] Circle Collision can only be checked with a Circle Collider")
    return (self.Owner.Transform.Position - other.Owner.Transform.Position).Magnitude <= self.Radius + other.Radius
end

function CircleCollider:CheckCollision(other: {}): boolean
    assert(other.__class == "Actor", "[Bee2D] Collision can only be checked with Actor")
    if other.CollisionVolume == nil then return false end

    if other.CollisionVolume.__class == "CircleCollision" then
        return self:CheckCircleCollision(other.CollisionVolume)
    end
end




return CircleCollider