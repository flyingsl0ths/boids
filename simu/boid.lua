local vec2         = require "simu.vec2"
local shapes       = require "simu.shape"
local utils        = require "simu.utils"

local BOID_SIZE    = 120

-- NOTE: This is the distance at which boids will start to interact with each other
local VISUAL_RANGE = 75

local Boid         = {}

Boid.__index       = Boid

local function new(pos, vel, shape)
	local b = {
		position = pos or vec2.randomUnit(),
		velocity = vel or vec2.randomUnit(),
		shape = shape or shapes.random()
	}
	return setmetatable(b, Boid)
end

function Boid:boundPosition(bounds)
	local turn_factor = 1

	if self.position.x < BOID_SIZE then
		self.velocity.x = self.velocity.x + turn_factor
	end
	if self.position.x > bounds.width - BOID_SIZE then
		self.velocity.x = self.velocity.x - turn_factor
	end
	if self.position.y < BOID_SIZE then
		self.velocity.y = self.velocity.y + turn_factor
	end
	if self.position.y > bounds.height - BOID_SIZE then
		self.velocity.y = self.velocity.y - turn_factor
	end
end

function Boid:limitSpeed()
	local speed_limit = 5.25

	local speed = self.velocity:length()

	if speed > speed_limit then
		self.velocity.x = (self.velocity.x / speed) * speed_limit
		self.velocity.y = (self.velocity.y / speed) * speed_limit
	end
end

function Boid:flyTowardsCenter(boids)
	-- Rule 1: Boids try to fly towards the center of mass of neighboring boids
	-- NOTE:: The center is just the average position of all the boids

	-- NOTE: This controls how much/fast to move towards the center
	-- NOTE: An easing function can be used here
	local centering_factor = 0.0010

	local center           = vec2()
	local neighbor_count   = 0

	for i = 1, #boids do
		local other = boids[i]
		if self.position:distance(other.position) < VISUAL_RANGE then
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
		local b_n = boids[i]
		if b_n ~= self and self.position:distance(b_n.position) < min_distance then
			movement = movement + (self.position - b_n.position)
		end
	end

	self.velocity = self.velocity + movement:scaled(avoid_factor)
end

function Boid:matchVelocity(boids)
	-- Rule 3: Boids try to match velocity with near boids
	-- NOTE: The controls the percentage of the final velocity
	local matching_factor = 2 / 100

	local average_velocity = vec2()
	local num_neighbors = 0

	for i = 1, #boids do
		local other = boids[i]
		if self.position:distance(other.position) < VISUAL_RANGE then
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

	__newindex = utils.immutableTable(),

	__metatable = false
})
