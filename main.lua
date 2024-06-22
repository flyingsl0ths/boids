local boid = require "simu.boid"
local vec3 = require "simu.vec3"
local shapes = require "simu.shape"


local boids = {}
local windowSize = { width = 800, height = 600 }

local function equalf(a, b, tolerance)
  tolerance = tolerance or 1e-9 -- Set a default tolerance if none is provided
  return math.abs(a - b) <= tolerance
end

local function position_boids()
  -- Divides the window into 4 quadrants and places boids in each quadrant

  local twoPi = math.pi * 2
  local i = 1
  local perSegment = 20
  local deg = 0

  for theta = 0, twoPi, 0.5 do
    if deg == 0 then
      local initial = theta - (theta % 90)
      for _ = 1, perSegment do
        local x = math.random(0, 10)
        local y = math.random(0, 10)
        local t = math.random(initial, theta)
        boids[i] = boid(vec3(math.cos(t) * x, math.sin(t) * y, 0), vec3.randomUnit(), shapes.triangle)
        i = i + 1
      end
    end

    deg = (deg + 1) % 90
  end
end

local function draw_boids()
  local ctx = love.graphics
  for i = 1, #boids do
    local bd = boids[i]
    local draw_shape = shapes.draw_function_of(bd.shape)
    draw_shape(ctx, bd.position.x, bd.position.y)
    ctx.rotate(bd.velocity:angle())
  end
end

local function rule_one(b_j, bds)
  -- Rule 1: Boids try to fly towards the (perceived) center of mass of neighboring boids
  local pc_j = vec3.zero()

  for i = 1, #bds do
    if bds[i] ~= b_j then
      pc_j = pc_j + bds[i].position
    end
  end

  pc_j = pc_j / (#bds - 1)

  return (pc_j - b_j.position) / 100
end

local function rule_two(b_j, bds)
  -- Rule 2: Boids try to keep a small distance away from other objects (including other boids)
  local c = vec3.zero()

  for i = 1, #bds do
    local b = bds[i]
    if b ~= b_j then
      if b.position:distance(b_j.position) < 100 then
        c = c - (b.position - b_j.position)
      end
    end
  end

  return c
end

local function rule_three(b_j, bds)
  -- Rule 3: Boids try to match velocity with near boids

  local pv_j = vec3.zero()

  for i = 1, #bds do
    local b = bds[i]

    if b ~= b_j then
      pv_j = pv_j + b.velocity
    end
  end

  pv_j = pv_j / (#bds - 1)

  return (pv_j - b_j.velocity) / 8
end

local function move_to_new_positions(delta)
  for i = 1, #boids do
    local bd = boids[i]

    local v1 = rule_one(bd, boids)
    local v2 = rule_two(bd, boids)
    local v3 = rule_three(bd, boids)

    bd.velocity = bd.velocity + v1 + v2 + v3
    bd.position = bd.position + bd.velocity:scaled(delta)
  end
end

function love.load()
  love.window.setTitle("Flocking Boids")
  love.window.setMode(windowSize.width, windowSize.height, {})
  position_boids()
end

function love.update(delta)
  move_to_new_positions(delta)
end

function love.draw()
  draw_boids()
end
