local utils = require "utils.utils"
local vec2 = require "utils.vec2"

local Base = {
	position = nil,
	width = nil,
	height = nil,
	default_color = { 0.5, 0.5, 1, 1 }
}

Base.__index = Base

local new = function(width, height, position)
	return setmetatable({
		width = width,
		height = height,
		position = position or vec2()
	}, Base)
end

function Base:move(offset_x, offset_y)
	self.position.x = self.position.x + offset_x
	self.position.y = self.position.y + offset_y
end

Base.__newindex = utils.immutableTable

return setmetatable(Base, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
