local vec2            = require "utils.vec2"
local shapes          = require "simu.shape"
local utils           = require "utils.utils"

local default_context = {
	-- NOTE: Refer to Boid:limitSpeed for usage
	speed_limit = 5.25,

	-- NOTE: This is the distance at which boids will start to interact with each other
	visual_range = 150,
	size = 10,

	-- Rule 1: Boids try to fly towards the center of mass of neighboring boids
	-- NOTE:: The center is just the average position of all the boids

	-- NOTE: This controls how much/fast to move towards the center
	-- NOTE: An easing function can be used here
	centering_factor = 0.0010,

	-- Rule 2: Boids try to keep a small distance away from other objects (including other boids)
	-- NOTE: This is done by moving a boid away from other boids if they are too close only by
	-- a percentage of the final accmulated distance
	min_distance = 25,

	-- Rule 3: Boids try to match velocity with near boids
	-- NOTE: The controls the percentage of the final velocity
	matching_factor = 2 / 100,

	-- NOTE: This controls the percentage of the final distance to move away from the other boids
	avoid_factor = 10 / 100,
}

local Boid            = {
	from_context = function(key)
		return default_context[key]
	end
}

Boid.__index          = Boid

local function new(pos, vel, shape)
	local b = {
		position = pos or vec2.randomUnit(),
		velocity = vel or vec2.randomUnit(),
		shape = shape or shapes.random()
	}
	return setmetatable(b, Boid)
end

function Boid:boundPosition(bounds, context)
	context = context or default_context

	local turn_factor = 1

	if self.position.x < context.size then
		self.velocity.x = self.velocity.x + turn_factor
	end
	if self.position.x > bounds.width - context.size then
		self.velocity.x = self.velocity.x - turn_factor
	end
	if self.position.y < context.size then
		self.velocity.y = self.velocity.y + turn_factor
	end
	if self.position.y > bounds.height - context.size then
		self.velocity.y = self.velocity.y - turn_factor
	end
end

function Boid:limitSpeed(context)
	context = context or default_context

	local speed_limit = default_context.speed_limit

	local speed = self.velocity:length()

	if speed > speed_limit then
		self.velocity.x = (self.velocity.x / speed) * speed_limit
		self.velocity.y = (self.velocity.y / speed) * speed_limit
	end
end

function Boid:flyTowardsCenter(boids, context)
	context                = context or default_context

	-- Rule 1: Boids try to fly towards the center of mass of neighboring boids
	-- NOTE:: The center is just the average position of all the boids

	-- NOTE: This controls how much/fast to move towards the center
	-- NOTE: An easing function can be used here
	local centering_factor = 0.0010

	local center           = vec2()
	local neighbor_count   = 0

	for i = 1, #boids do
		local other = boids[i].data
		if self.position:distance(other.position) < context.visual_range then
			center = center + other.position
			neighbor_count = neighbor_count + 1
		end
	end

	if neighbor_count ~= 0 then
		center = center / neighbor_count
		self.velocity = self.velocity + (center - self.position):scaled(centering_factor)
	end
end

function Boid:avoidOthers(boids)
	-- Rule 2: Boids try to keep a small distance away from other objects (including other boids)
	-- NOTE: This is done by moving a boid away from other boids if they are too close only by
	-- a percentage of the final accmulated distance
	local min_distance = 25

	-- NOTE: This controls the percentage of the final distance to move away from the other boids
	local avoid_factor = 10 / 100

	local movement = vec2()

	for i = 1, #boids do
		local b_n = boids[i].data
		if b_n ~= self and self.position:distance(b_n.position) < min_distance then
			movement = movement + (self.position - b_n.position)
		end
	end

	self.velocity = self.velocity + movement:scaled(avoid_factor)
end

function Boid:matchVelocity(boids, context)
	context = context or default_context

	-- Rule 3: Boids try to match velocity with near boids
	-- NOTE: The controls the percentage of the final velocity
	local matching_factor = 2 / 100

	local average_velocity = vec2()
	local num_neighbors = 0

	for i = 1, #boids do
		local other = boids[i].data
		if self.position:distance(other.position) < default_context.visual_range then
			average_velocity = average_velocity + other.velocity
			num_neighbors = num_neighbors + 1
		end
	end

	if num_neighbors ~= 0 then
		average_velocity = average_velocity / num_neighbors
		self.velocity = self.velocity + (average_velocity - self.velocity):scaled(matching_factor)
	end
end

return setmetatable(Boid, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable,
})
