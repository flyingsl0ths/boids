local vec2 = require "utils.vec2"
local shapes = require "simu.shape"
local box = require "simu.quad.box"
local circle = require "simu.quad.circle"
local qt = require "simu.quad.quad_tree"
local boid = require "simu.boid"
local ui = require "ui"

local boids = {}
local tree

local WINDOW_SIZE = { width = 1000, height = 600 }
local DRAWING_AREA = { width = WINDOW_SIZE.width, height = WINDOW_SIZE.height - 100 }

local STARTING_AMOUNT = 800

local size_slider

local function position_boids(qtree)
	for i = 1, STARTING_AMOUNT do
		local position = vec2(math.random(WINDOW_SIZE.width), math.random(WINDOW_SIZE.height))
		local bd = boid(position, vec2.randomUnit() - vec2(6), shapes.CIRCLE)
		qtree:insert(position, bd)

		boids[i] = bd
	end
end

local function draw_ui()
	size_slider:draw()
end

local function draw_boids()
	local ctx = love.graphics
	for i = 1, #boids do
		local bd         = boids[i]
		local draw_shape = shapes.drawFuncOf(bd.shape, boid.from_context("size"))
		local velocity   = bd.velocity:length()
		local color      = love.math.noise(velocity)
		ctx.setColor(color, color, color)
		draw_shape(ctx, bd.position.x, bd.position.y)
	end
end

local function move_to_new_positions(qtree)
	for i = 1, #boids do
		local bd = boids[i]

		local range = circle(bd.position.x, bd.position.y, boid.from_context("visual_range"))

		local neighbors = qtree:query(range)

		bd:flyTowardsCenter(neighbors)
		bd:avoidOthers(neighbors)
		bd:matchVelocity(neighbors)
		bd:boundPosition(DRAWING_AREA)
		bd:limitSpeed()

		bd.position = bd.position + bd.velocity
	end
end

function love.load()
	love.window.setTitle("Flocking Boids")
	love.window.setMode(WINDOW_SIZE.width, WINDOW_SIZE.height, {})
	local center = { x = WINDOW_SIZE.width / 2, y = WINDOW_SIZE.height / 2 }

	tree = qt(box(center.x, center.y, center.x, center.y), 6)
	position_boids(tree)

	size_slider = ui.slider()
	size_slider:move(10, DRAWING_AREA.height + 50)
end

function love.update()
	for i = 1, #boids do
		local bd = boids[i]
		tree:insert(bd.position, bd)
	end

	move_to_new_positions(tree)

	tree:clear()
end

function love.draw()
	draw_boids()
	draw_ui()
end
