export type Component = {
	Owner: Actor,
	Name: string,
}

export type Cache = {
	_objects: {GuiObject},
	_available: {number},
	OnCompress: (object: GuiObject, index: number) -> (),
}

export type AnimatorComponent = {
	Owner: Actor,
	Name: string,
	Update: (deltaTime: number) -> nil,
	OnCollision: () -> nil,
} 

export type Sprite = {
	Width: number,
	Height: number,
	Color: Color3,
	Image: string,
	CacheIndex: number?
}

export type Tile = {
	Name: string,
	Transform: Transform,
	Draw: () -> nil,
	Update: (deltaTime: number) -> nil,
	Translate: (direction: Vector2) -> nil,
	Active: boolean,
	Graphic: Sprite,
	_lastPosition: Vector2,
	TileTexture: string,
	DefaultScale: number,
	GridScale: number,
	GridPosition: Vector2,
	AbsolutePosition: Vector2,
}

export type TileMap = {
	Tiles: {Tile},
	Update: (deltaTime: number) -> nil,
	Draw: () -> nil,
}

export type IsometricTile = {
	Name: string,
	Transform: Transform,
	Draw: () -> nil,
	Update: (deltaTime: number) -> nil,
	Translate: (direction: Vector2) -> nil,
	Active: boolean,
	Graphic: Sprite,
	_lastPosition: Vector2,
	TileTexture: string,
	DefaultScale: number,
	GridScale: number,
	GridPosition: Vector2,
	AbsolutePosition: Vector2,
}

export type Actor = {
	Name: string,
	Transform: Transform,
	Draw: () -> nil,
	Update: (deltaTime: number) -> nil,
	Translate: (direction: Vector2) -> nil,
	Active: boolean,
	Graphic: Sprite,
	_lastPosition: Vector2,
}

export type Matrix3 = {
	M00: number, M01: number, M02: number,
	M10: number, M11: number, M12: number,
	M20: number, M21: number, M22: number,

	Identity: Matrix3
}

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
}

export type Scene = {
    Actors: {Actor},
    TileMaps: {},
    Prioritize: boolean,
    Name: string
}

export type Collider = {
	Owner: Actor,
	CollisionType: string,
}

export type AABBCollider = {
	owner: Actor,
	width: number,
	height: number,
}

export type CircleCollider = {
	owner: Actor,
	collisionRadius: number,
}

export type OBBCollider = {
	owner: Instance,
	halfWidth: number,
	halfHeight: number,
	rotation: number,
}

return {}