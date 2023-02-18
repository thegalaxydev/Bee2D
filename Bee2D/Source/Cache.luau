-- Bee2D by Galaxy#1337

--- @class Cache
local Cache = {}
Cache.__index = Cache

NULL = {}

export type Cache = {
	_objects: {GuiObject},
	_available: {number},
	OnCompress: (object: GuiObject, index: number) -> (),
} & typeof(Cache)

--[=[
	Constructor for Cache. This is used to store objects that can be reused later on.

	@return Cache -- A new cache object
]=]
function Cache.new() :Cache
	local self = setmetatable({}, Cache)
	self._objects = {}
	self._available = {}

	self.OnCompress = function(object: GuiObject, index: number)
    end
	
	return self
end

--[=[
	Pushes an object into the cache. If there are no available indices, the object will be appended to the end of the cache.

	@param object GuiObject -- The object to push into the cache

	@return number: The index of the object in the cache
]=]
function Cache:PushObject(object: GuiObject)
	local cacheIndex = table.remove(self._available) or #self._objects+1
	self._objects[cacheIndex] = object
	
	return cacheIndex
end

--[=[
	Pops an object from the cache. This will remove the object from the cache and destroy it.

	@param index number -- The index of the object to pop from the cache
]=]
function Cache:PopObject(index: number)
	local object = self._objects[index]
	self._objects[index] = NULL
	object:Destroy()
	self._available[#self._available+1] = index
end

--[=[
	Gets an object from the cache.

	@param index number -- The index of the object to get from the cache

	@return GuiObject -- The object at the given index
]=]
function Cache:GetObject(index: number) : GuiObject
	return self._objects[index]
end

--[=[
	Clears the cache.
]=]
function Cache:Clear()
	self._objects = {}
	self._available = {}
end

--[=[
	Iterates through the cache and calls the given callback for each object.

	@param callback (GuiObject)->() -- The callback to call for each object
]=]
function Cache:ForEach(callback: (GuiObject)->())
	for _, v in ipairs(self._objects) do
		if v ~= NULL then
			callback(v)
		end
	end
end

--[=[
	Compresses the cache. This will remove all NULL objects from the cache and re-index the objects.
]=]
function Cache:Compress()
	local newObjects = {}
	local indexOffset = 0
	
	for i, v in ipairs(self._objects) do
		if v ~= NULL then
			local index = #newObjects+1-indexOffset
			newObjects[index] = v
			self.OnCompress(v, index)
		else
			indexOffset += 1
		end
	end

	

	self._objects = newObjects
end

return Cache
