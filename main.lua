local vec2            = require "utils.vec2"
local shapes          = require "simu.shape"
local box             = require "simu.quad.box"
local circle          = require "simu.quad.circle"
local qt              = require "simu.quad.quad_tree"
local boid            = require "simu.boid"
local ui              = require "ui"

local boids           = {}
local tree

local WINDOW_SIZE     = { width = 1000, height = 600 }
local DRAWING_AREA    = { width = WINDOW_SIZE.width, height = WINDOW_SIZE.height - 100 }

local STARTING_AMOUNT = 300

local sliders         = {}
local ui_context

local function position_boids()
	for i = 1, STARTING_AMOUNT do
		local position = vec2(math.random(WINDOW_SIZE.width), math.random(WINDOW_SIZE.height))
		local bd = boid(position, vec2.randomUnit() - vec2(6), shapes.CIRCLE)
		boids[i] = bd
	end
end

local function draw_ui(ui_ctx)
	size_slider:draw(ui_ctx)
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

local function get_label(parameter)
	if i == 1 then
		label = "Speed:" 
	elseif i == 2 then
		label = "VisualRange:" 
	elseif i == 3 then
		label = "CenteringFactor:" 
	elseif i == 4 then
		label = "MinDistance:" 
	elseif i == 5 then
		label = "MatchingFactor" 
	elseif i == 6 then
		label = "AvoidFactor:" 
	end
end

function love.load()
	love.window.setTitle("Flocking Boids")
	love.window.setMode(WINDOW_SIZE.width, WINDOW_SIZE.height, {})
	local center = { x = WINDOW_SIZE.width / 2, y = WINDOW_SIZE.height / 2 }

	tree = qt(box(center.x, center.y, center.x, center.y), 6)
	position_boids()

	ui_context = ui.context(love.graphics)

	for i = 1, 6, 1 do
		local label = get_label(i)
		local slider = ui.slider(0, 0.05, 0, 10)

		slider:move(50 + i * 0.25, DRAWING_AREA.height + 50)

		sliders[i] = slider
	end
end

local function update_ui_context(context, dt)
	context.mouse_pos.x                    = love.mouse:getX()
	context.mouse_pos.y                    = love.mouse:getY()
	context.mouse_state.primary_btn_down   = love.mouse.isDown(1)
	context.mouse_state.secondary_btn_down = love.mouse.isDown(2)
	context.mouse_state.middle_btn_down    = love.mouse.isDown(3)
	context.dt                             = dt
end

function love.update(dt)
	update_ui_context(ui_context, dt)

	tree:clear()

	for i = 1, #boids do
		local bd = boids[i]
		tree:insert(bd.position, bd)
	end

	move_to_new_positions(tree)

	size_slider:update(ui_context)
end

function love.draw()
	draw_boids()
	draw_ui(ui_context)
end
