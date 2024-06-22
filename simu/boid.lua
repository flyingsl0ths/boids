local vec3   = require "simu.vec3"
local shapes = require "simu.shape"
local utils  = require "simu.utils"

local Boid   = {}

Boid.__index = Boid

local function new(pos, vel, shape)
	local b = {
		position = pos or vec3.randomUnit(),
		velocity = vel or vec3.randomUnit(),
		shape = shape or shapes.random()
	}
	return setmetatable(b, Boid)
end

return setmetatable(Boid, {
	__call = function(_, ...)
		return new(...)
	end,

	__newindex = function(_, _, _)
		utils.immutableTable()
	end
})
