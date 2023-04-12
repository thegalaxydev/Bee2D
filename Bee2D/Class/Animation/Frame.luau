local Frame = {}
Frame.__index = Frame;

export type Frame = {
	Image: string,
}

function Frame.new(image: string)
	local self = setmetatable({}, Frame)

	self.Image = image

	return self
end

return Frame