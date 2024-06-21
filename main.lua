local boid = require("boid")
local vec3 = require("vec3")
local shapes = require("shape")


local boids = {}
local windowSize = { width = 1920, height = 1080 }

local function equalf(a, b, tolerance)
	tolerance = tolerance or 1e-9 -- Set a default tolerance if none is provided
	return math.abs(a - b) <= tolerance
end

local function position_boids()
	-- Divides the window into 4 quadrants and places boids in each quadrant

	local twoPi = math.pi * 2
	local i = 1
	local perSegment = 20

	for theta = 0, twoPi, 0.5 do
		local initial = theta % 90
		if equalf(initial, 0.0) then
			initial = theta - initial
			for _ = 1, perSegment do
				local x = math.random(0, windowSize.width)
				local y = math.random(0, windowSize.height)
				local t = math.random(initial, theta)
				boids[i] = boid(vec3(math.cos(t) * x, math.sin(t) * y, 0))
			end
		end

		i = i + 1
	end
end

local function draw_boids()
	for i = 1, #boids do
		local draw_shape = shapes.draw_function_of(boids[i].shape)
		draw_shape(love.graphics, boids[i].position.x, boids[i].position.y)
	end
end

local function move_to_new_positions()
	for i = 1, #boids do
		local bd = boids[i]

		local v1 = rule_one(bd, boids)
		local v2 = rule_two(bd, boids)
		local v3 = rule_three(bd, boids)

		bd.velocity = bd.velocity + v1 + v2 + v3
		bd.position = bd.position + bd.velocity
	end
end

local function rule_one(b_j, boids)
	-- Rule 1: Boids try to fly towards the (perceived) center of mass of neighboring boids
	local pc_j = vec3.zero()

	for i = 1, #boids do
		if boids[i] ~= b_j then
			pc_j = pc_j + boids[i].position
		end
	end

	pc_j = pc_j / (#boids - 1)

	return (pc_j - b_j.position) / 100
end

local function rule_two(b_j, boids)
	-- Rule 2: Boids try to keep a small distance away from other objects (including other boids)
	local c = vec3.zero()

	for i = 1, #boids do
		local b = boids[i]
		if b ~= b_j then
			if b.position:distance(b_j.position) < 100 then
				c = c - (b.position - b_j.position)
			end
		end
	end

	return c
end

function love.load()
	love.window.setTitle("Flocking Boids")
	love.window.setMode(windowSize.width, windowSize.height, {})
	position_boids()
end

function love.draw()
	draw_boids()
	move_to_new_positions()
end
