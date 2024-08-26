local vec2 = require "simu.vec2"
local shapes = require "simu.shape"
local box = require "simu.quad.box"
local circle = require "simu.quad.circle"
local qt = require "simu.quad.quad_tree"


local boids = {}
local tree
local range = circle(0, 0, 64)

local WINDOW_SIZE = { width = 800, height = 600 }

local STARTING_AMOUNT = 150


local function positionBoids(quadtree)
  for _ = 1, STARTING_AMOUNT do
    local position = vec2(math.random(WINDOW_SIZE.width), math.random(WINDOW_SIZE.height))
    quadtree:insert(position)
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
  local center = { x = WINDOW_SIZE.width / 2, y = WINDOW_SIZE.height / 2 }
  tree = qt(box(center.x, center.y, center.x, center.y))
  positionBoids(tree)
end

function love.update()
  -- moveToNewPositions()
end

function love.draw()
  -- drawBoids()
  if love.mouse.isDown(1) then -- right click
    local x, y = love.mouse.getPosition()
    range.position.x = x
    range.position.y = y
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", x, y, range.r)
    local points = tree:query(range)
    love.graphics.setColor(1, 0, 0)
    for i = 1, #points do
      love.graphics.circle("fill", points[i].x, points[i].y, 10)
    end
  end
end
