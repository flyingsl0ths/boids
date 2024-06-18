local vec3   = require("vec3")
local shapes = require("shape")
local utils  = require("utils")

local Boid   = {}

Boid.__index = Boid

function Boid.new(pos, vel, shape)
	local b = {
		position = pos or vec3.randomUnit(),
		velocity = vel or vec3.randomUnit(),
		shape = shape or shapes.random()
	}
	return setmetatable(b, Boid)
end

return setmetatable(Boid, {
	__call = function(_, ...)
		return Boid.new(...)
	end,

	__newindex = function(_, _, _)
		utils.immutableTable()
	end
})
