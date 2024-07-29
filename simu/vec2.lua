local utils = require "simu.utils"

local Vec2 = {}

Vec2.__index = Vec2

local function new(x, y)
	local v = {
		x = x or 0,
		y = y or 0,
	}
	return setmetatable(v, Vec2)
end

Vec2.__add = function(v1, v2)
	return new(
		v1.x + v2.x,
		v1.y + v2.y
	)
end

Vec2.__sub = function(v1, v2)
	return new(
		v1.x - v2.x,
		v1.y - v2.y
	)
end

Vec2.__mul = function(v1, v2)
	return v1.x * v2.x + v1.y * v2.y
end

Vec2.__div = function(v, f)
	return new(
		v.x / f,
		v.y / f
	)
end

Vec2.__unm = function(v)
	return new(-v.x, -v.y)
end

Vec2.__eq = function(v1, v2)
	return v1.x == v2.x and v1.y == v2.y
end

Vec2.__lt = function(v1, v2)
	return v1:length() < v2:length()
end

Vec2.__le = function(v1, v2)
	return v1:length() <= v2:length()
end

Vec2.__gt = function(v1, v2)
	return v1:length() > v2:length()
end

Vec2.__ge = function(v1, v2)
	return v1:length() >= v2:length()
end

Vec2.__tostring = function(v)
	return string.format("Vec2[x = %s, y = %s]", v.x, v.y)
end

--- Scales the vector by a factor of 's'
-- @number s The scalar
function Vec2:scale(s)
	self.x = self.x * s
	self.y = self.y * s
end

--- Computes a new vector scaled by a factor of 's'
-- @number s The scalar
-- @treturn Vec2
function Vec2:scaled(s)
	return new(
		self.x * s,
		self.y * s
	)
end

--- Helper function used to get the components
-- of the vector as individual values
-- @treturn number number number
function Vec2:spread()
	return self.x, self.y
end

--- Computes the direction (vector) of the vector
-- @treturn Vec2
function Vec2:normalize()
	local len = self:length()
	return new(self.x / len, self.y / len)
end

--- Computes the distance between the two vectors
-- @tparam Vec2 v2 The other vector
-- @treturn number
function Vec2:distance(v2)
	local d = self - v2
	return d:length()
end

--- Computes the (euclidean) length of the vector
-- @treturn number
function Vec2:length()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

--- Computes the angle (in radians) of the vector
-- @treturn number
function Vec2:angle()
	return math.atan2(self.y, self.x)
end

--- Constructs a Vec2 with it's z component equal to 1
-- from an angle (in radians) and a length
-- @number theta The angle
-- @number radius The length of the vector
-- @treturn Vec2
function Vec2.fromPolar(theta, radius)
	local x = math.cos(theta) * radius
	local y = math.cos(theta) * radius
	return new(x, y)
end

--- Computes a random unit vector
-- @treturn Vec2
function Vec2.randomUnit()
	local x = math.random(-10, 10)
	local y = math.random(-10, 10)
	return new(x, y):normalize()
end

return setmetatable(Vec2, {
	__call = function(_, x, y)
		return new(x, y)
	end,

	__newindex = utils.immutableTable(),

	__metatable = false
})
