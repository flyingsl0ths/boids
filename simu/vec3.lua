local utils = require "utils"
local Vec3 = {}

Vec3.__index = Vec3

local function new(x, y, z)
	local v = {
		x = x,
		y = y,
		z = z
	}
	return setmetatable(v, Vec3)
end

function Vec3.zero()
	return new(0, 0, 0)
end

Vec3.__add = function(v1, v2)
	return new(
		v1.x + v2.x,
		v1.y + v2.y,
		v1.z + v2.z
	)
end

Vec3.__sub = function(v1, v2)
	return new(
		v1.x - v2.x,
		v1.y - v2.y,
		v1.z - v2.z
	)
end

Vec3.__mul = function(v1, v2)
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

Vec3.__div = function(v, f)
	return new(
		v.x / f,
		v.y / f,
		v.z / f
	)
end

Vec3.__unm = function(v)
	return new(-v.x, -v.y, -v.z)
end

Vec3.__eq = function(v1, v2)
	return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
end

Vec3.__lt = function(v1, v2)
	return v1:length() < v2:length()
end

Vec3.__le = function(v1, v2)
	return v1:length() <= v2:length()
end

Vec3.__gt = function(v1, v2)
	return v1:length() > v2:length()
end

Vec3.__ge = function(v1, v2)
	return v1:length() >= v2:length()
end

Vec3.__tostring = function(v)
	return string.format("Vec3[x = %s, y = %s, z = %s]", v.x, v.y, v.z)
end

--- Computes the cross product of the two vectors
-- @tparam Vec3 v2 The other vector
-- @treturn Vec3
function Vec3:cross(v2)
	local x1, y1, z1 = self:spread()
	local x2, y2, z2 = v2:spread()
	return new(y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2)
end

--- Scales the vector by a factor of 's'
-- @number s The scalar
function Vec3:scale(s)
	self.x = self.x * s
	self.y = self.y * s
	self.z = self.z * s
end

--- Computes a new vector scaled by a factor of 's'
-- @number s The scalar
-- @treturn Vec3
function Vec3:scaled(s)
	return new(
		self.x * s,
		self.y * s,
		self.z * s
	)
end

--- Helper function used to get the components
-- of the vector as individual values
-- @treturn number number number
function Vec3:spread()
	return self.x, self.y, self.z
end

--- Computes the direction (vector) of the vector
-- @treturn Vec3
function Vec3:normalize()
	local len = self:length()
	return new(self.x / len, self.y / len, self.z / len)
end

--- Computes the distance between the two vectors
-- @tparam Vec3 v2 The other vector
-- @treturn number
function Vec3:distance(v2)
	local d = self - v2
	return d:length()
end

--- Computes the (euclidean) length of the vector
-- @treturn number
function Vec3:length()
	return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

--- Constructs a Vec3 with it's z component equal to 1
-- @treturn Vec3
function Vec3:truncate()
	return new(self.x, self.y, 1)
end

--- Computes the angle (in radians) between the two vectors
-- Note: This only takes into account the x & y components
-- @tparam Vec3 v2 The other vector
-- @treturn number
function Vec3:angle_to(v2)
	return math.atan(self.y - v2.y, self.x - v2.x)
end

--- Computes the angle (in radians) between the two vectors
-- Note: This does take into account all components
-- @tparam Vec3 v2 The other vector
-- @treturn number
function Vec3:angle_between(v2)
	local v1 = self:normalize()
	v2 = v2:normalize()
	return math.acos(v1 * v2)
end

--- Constructs a Vec3 with it's z component equal to 1
-- from an angle (in radians) and a length
-- @number theta The angle
-- @number radius The length of the vector
-- @treturn Vec3
function Vec3.fromPolar(theta, radius)
	local x = math.cos(theta) * radius
	local y = math.cos(theta) * radius
	return new(x, y, 1)
end

--- Computes a random unit vector
-- @treturn Vec3
function Vec3.randomUnit()
	local x = math.random(-10, 10)
	local y = math.random(-10, 10)
	local z = math.random(-10, 10)
	return new(x, y, z):normalize()
end

return setmetatable(Vec3, {
	__call = function(_, x, y, z)
		return new(x, y, z)
	end,

	__newindex = function(_, _, _)
		utils.immutableTable()
	end
})
