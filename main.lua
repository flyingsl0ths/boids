local boid = require "simu.boid"
local vec2 = require "simu.vec2"
local shapes = require "simu.shape"


local boids = {}

local WINDOW_SIZE = { width = 800, height = 600 }

local STARTING_AMOUNT = 150


local function positionBoids()
  for i = 1, STARTING_AMOUNT do
    local position = vec2(math.random(WINDOW_SIZE.width), math.random(WINDOW_SIZE.height))
    local bd = boid(position, vec2.randomUnit() - vec2(6), shapes.circle)
    boids[i] = bd
  end
end

local function drawBoids()
  local ctx = love.graphics
  for i = 1, #boids do
    local bd         = boids[i]
    local draw_shape = shapes.drawFuncOf(bd.shape)
    local velocity   = bd.velocity:length()
    local color      = love.math.noise(velocity)
    ctx.setColor(color, color, color)
    draw_shape(ctx, bd.position.x, bd.position.y)
  end
end



local function moveToNewPositions()
  for i = 1, #boids do
    local bd = boids[i]

    bd:flyTowardsCenter(boids)
    bd:avoidOthers(boids)
    bd:matchVelocity(boids)
    bd:limitSpeed()
    bd:boundPosition(WINDOW_SIZE)

    bd.position = bd.position + bd.velocity
  end
end

function love.load()
  love.window.setTitle("Flocking Boids")
  love.window.setMode(WINDOW_SIZE.width, WINDOW_SIZE.height, {})
  positionBoids()
end

function love.update()
  moveToNewPositions()
end

function love.draw()
  drawBoids()
end
