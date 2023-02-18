local Cache = {}
Cache.__index = Cache


function Cache.new()
	local self = setmetatable({}, Cache)
	self.Objects = {}
	
	table.freeze(self.Objects)

	return self
end

function Cache:PushObject(object: GuiObject)
	local tempTable = table.create(#self.Objects + 1)

	for _,v in ipairs(self.Objects) do
		table.insert(tempTable, v)
	end

	table.insert(tempTable, object)

	self.Objects = tempTable
end

function Cache:PopObject(index: number)
	local tempTable = table.create(#self.Objects - 1)

	for i,v in ipairs(self.Objects) do
		if i ~= index then
			table.insert(tempTable, v)
		end
	end

	self.Objects = tempTable
end

return Cache
