local utils = require "simu.utils"
local vec2 = require "simu.vec2"
local quadrants = require "simu.quad.quadrants"

local Box = {}

Box.__index = Box

local function new(x, y, width, height)
	local instance = {
		x = x,
		y = y,
		width = width or 0,
		height = height or 0,
		left = x - width / 2,
		right = x + width / 2,
		top = y - height / 2,
		bottom = y + height / 2
	}
	return setmetatable(instance, Box)
end

function Box:contains(point)
	return self.left <= point.x and point.x <= self.right and self.top <= point.y and point.y <= self.bottom
end

function Box:intersects(other)
	return not (self.right < other.left or other.right < self.left or self.bottom < other.top or other.bottom < self.top)
end

function Box:subdivide(quadrant)
	local half_width = self.width / 2
	local half_height = self.height / 2

	local west_x = self.x - self.width / 4
	local east_x = self.x + self.width / 4
	local north_y = self.y - self.height / 4
	local south_y = self.y + self.height / 4

	if quadrant == quadrants.NW then
		return new(west_x, north_y, half_width, half_height)
	elseif quadrant == quadrants.NE then
		return new(east_x, north_y, half_width, half_height)
	elseif quadrant == quadrants.SW then
		return new(west_x, south_y, half_width, half_height)
	elseif quadrant == quadrants.SE then
		return new(east_x, south_y, half_width, half_height)
	end
end

Box.__newindex = utils.immutableTable

return setmetatable(Box, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
