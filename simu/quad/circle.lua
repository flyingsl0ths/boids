local utils = require "simu.utils"
local vec2 = require "simu.vec2"

local Circle = {}

Circle.__index = Circle

local function new(x, y, r)
	local instance = {
		position = vec2(x, y),
		r = r,
		r_squared = r * r,
	}
	return setmetatable(instance, Circle)
end

function Circle:contains(point)
	local d = (point - self.position):length()
	return d <= self.r_squared
end

function Circle:intersects(other)
	local x_dist = math.abs(other.x - self.position.x)
	local y_dist = math.abs(other.y - self.position.y)

	local r = self.r

	local w = other.width / 2
	local h = other.height / 2

	local edges = math.pow(x_dist - w, 2) + math.pow(y_dist - h, 2)

	if x_dist > (r + w) or y_dist > (r + h) then
		return false
	end

	if x_dist <= w or y_dist <= h then
		return true
	end

	return edges <= self.r_squared
end

return setmetatable(Circle, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
