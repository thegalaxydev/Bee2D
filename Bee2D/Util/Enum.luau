local _enumInit = {}
for _, enum in pairs(Enum:GetEnums()) do
	_enumInit[tostring(enum)] = {}
	for _, enumItem in pairs(enum:GetEnumItems()) do
		_enumInit[tostring(enum)][enumItem.Name] = enumItem.Value
	end
end
Enum = {}
Enum.__index = Enum
Enum.__class = "Enum"
Enum.__objects = _enumInit

local EnumItem = {}
EnumItem.__index = EnumItem
EnumItem.__class = "EnumItem"


export type Enum = {
	Name: string,
	Value: {},
}

export type EnumItem = {
	Name: string,
	Value: number,
}

function EnumItem.new(name: string, value: number): EnumItem
	local self = setmetatable({}, EnumItem)
	self.Name = name
	self.Value = value

	return self
end

function Enum.new(name: string): Enum
	local self = setmetatable({}, Enum)
	self.Name = name
	self._items = {}
	Enum.__objects[name] = {}


	Enum.__objects[name].GetEnumItems = self.GetEnumItems

	for k, v in pairs(Enum.__objects) do
		Enum[k] = v
	end

	return self
end

function Enum.GetEnums()
	return Enum.__objects
end


function Enum:GetEnumItems() : {}
		return self._items
end

function Enum:AddItem(itemName: string) : EnumItem
	local enumItem = EnumItem.new(itemName, #Enum.__objects[self.Name])

	Enum.__objects[self.Name][enumItem.Name] = enumItem.Value
	Enum[self.Name][enumItem.Name] = enumItem.Value
	table.insert(self._items, enumItem)

	return enumItem
end


return Enum
