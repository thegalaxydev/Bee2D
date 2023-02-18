local Cache = {}
Cache.__index = Cache

local Event = require(script.Parent.Parent.Util.Event)


NULL = {}

export type Cache = {
	_objects: {GuiObject},
	_available: {number},
	OnCompress: (object: GuiObject, index: number) -> (),
} & typeof(Cache)

function Cache.new()
	local self = setmetatable({}, Cache)
	self._objects = {}
	self._available = {}

	self.OnCompress = function(object: GuiObject, index: number)
    end
	
	return self
end

function Cache:PushObject(object: GuiObject)
	local cacheIndex = table.remove(self._available) or #self._objects+1
	self._objects[cacheIndex] = object
	
	return cacheIndex
end

function Cache:PopObject(index: number)
	local object = self._objects[index]
	self._objects[index] = NULL
	object:Destroy()
	self._available[#self._available+1] = index
end

function Cache:GetObject(index: number) : GuiObject
	return self._objects[index]
end

function Cache:Clear()
	self._objects = {}
	self._available = {}
end

function Cache:ForEach(callback: (GuiObject)->())
	for _, v in ipairs(self._objects) do
		if v ~= NULL then
			callback(v)
		end
	end
end

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
