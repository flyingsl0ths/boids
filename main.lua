local vec2 = require "simu.vec2"
local shapes = require "simu.shape"
local box = require "simu.quad.box"
local circle = require "simu.quad.circle"
local qt = require "simu.quad.quad_tree"
local boid = require "simu.boid"

local boids = {}
local tree

local WINDOW_SIZE = { width = 800, height = 600 }

local STARTING_AMOUNT = 2000


local function positionBoids(qtree)
  for i = 1, STARTING_AMOUNT do
    local position = vec2(math.random(WINDOW_SIZE.width), math.random(WINDOW_SIZE.height))
    local bd = boid(position, vec2.randomUnit() - vec2(6), shapes.CIRCLE)
    qtree:insert(position, bd)
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



local function moveToNewPositions(qtree)
  for i = 1, #boids do
    local bd = boids[i]

    local range = circle(bd.position.x, bd.position.y, boid.VISUAL_RANGE)

    local neighbors = qtree:query(range)

    bd:flyTowardsCenter(neighbors)
    bd:avoidOthers(neighbors)
    bd:matchVelocity(neighbors)
    bd:limitSpeed()
    bd:boundPosition(WINDOW_SIZE)

    bd.position = bd.position + bd.velocity
  end
end

function love.load()
  love.window.setTitle("Flocking Boids")
  love.window.setMode(WINDOW_SIZE.width, WINDOW_SIZE.height, {})
  local center = { x = WINDOW_SIZE.width / 2, y = WINDOW_SIZE.height / 2 }
  tree = qt(box(center.x, center.y, center.x, center.y))
  positionBoids(tree)
end

function love.update()
  tree:clear()

  for i = 1, #boids do
    local bd = boids[i]
    tree:insert(bd.position, bd)
  end

  moveToNewPositions(tree)
end

function love.draw()
  drawBoids()
end
