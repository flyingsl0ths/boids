local boid = require "simu.boid"
local vec2 = require "simu.vec2"
local shapes = require "simu.shape"


local boids = {}
local windowSize = { width = 800, height = 600 }
local number_of_boids = 130
local boid_size = 200

-- NOTE: This is the distance at which boids will start to interact with each other
local visual_range = 75

local function positionBoids()
  for i = 1, number_of_boids do
    local position = vec2(math.random(windowSize.width), math.random(windowSize.height))
    local bd = boid(position, vec2.randomUnit() - vec2(5), shapes.triangle)
    boids[i] = bd
  end
end

local function boundPosition(bd)
  local turn_factor = 1

  if bd.position.x < boid_size then
    bd.velocity.x = bd.velocity.x + turn_factor
  end
  if bd.position.x > windowSize.width - boid_size then
    bd.velocity.x = bd.velocity.x - turn_factor
  end
  if bd.position.y < boid_size then
    bd.velocity.y = bd.velocity.y + turn_factor
  end
  if bd.position.y > windowSize.height - boid_size then
    bd.velocity.y = bd.velocity.y - turn_factor
  end
end

local function limitSpeed(bd)
  local speed_limit = 15

  local speed = bd.velocity:length()

  if speed > speed_limit then
    bd.velocity.x = (bd.velocity.x / speed) * speed_limit
    bd.velocity.y = (bd.velocity.y / speed) * speed_limit
  end
end

local function drawBoids()
  local ctx = love.graphics
  for i = 1, #boids do
    local bd = boids[i]
    local draw_shape = shapes.drawFuncOf(bd.shape)
    draw_shape(ctx, bd.position.x, bd.position.y)
  end
end

local function flyTowardsCenter(b_j, bds)
  -- Rule 1: Boids try to fly towards the center of mass of neighboring boids
  -- NOTE:: The center is just the average position of all the boids

  -- NOTE: This controls how much/fast to move towards the center
  -- NOTE: An easing function can be used here
  local centering_factor = 0.005

  local center           = vec2()
  local neighbor_count   = 0

  for i = 1, #bds do
    local b_n = bds[i]
    if b_j.position:distance(b_n.position) < visual_range then
      center = center + b_n.position
      neighbor_count = neighbor_count + 1
    end
  end

  if neighbor_count ~= 0 then
    center = center / neighbor_count
    b_j.velocity = b_j.velocity + (center - b_j.position):scaled(centering_factor)
  end
end

local function avoidOthers(bd_j, bds)
  -- Rule 2: Boids try to keep a small distance away from other objects (including other boids)
  -- NOTE: This is done by moving a boid away from other boids if they are too close only by
  -- a percentage of the final accmulated distance
  local min_distance = 35

  -- NOTE: This controls the percentage of the final distance to move away from the other boids
  local avoid_factor = 0.05

  local movement = vec2()

  for i = 1, #bds do
    local b_n = bds[i]
    if b_n ~= bd_j and bd_j.position:distance(b_n.position) < min_distance then
      movement = movement + (bd_j.position - b_n.position)
    end
  end

  bd_j.velocity = bd_j.velocity + movement:scaled(avoid_factor)
end

local function matchVelocity(b_j, bds)
  -- Rule 3: Boids try to match velocity with near boids
  -- NOTE: The controls the percentage of the final velocity
  local matching_factor = 0.05

  local average_velocity = vec2()
  local num_neighbors = 0

  for i = 1, #bds do
    local b_n = bds[i]
    if b_j.position:distance(b_n.position) < visual_range then
      average_velocity = average_velocity + b_n.velocity
      num_neighbors = num_neighbors + 1
    end
  end

  if num_neighbors ~= 0 then
    average_velocity = average_velocity / num_neighbors
    b_j.velocity = b_j.velocity + (average_velocity - b_j.velocity):scaled(matching_factor)
  end
end

local function moveToNewPositions()
  for i = 1, #boids do
    local bd = boids[i]

    flyTowardsCenter(bd, boids)
    avoidOthers(bd, boids)
    matchVelocity(bd, boids)
    limitSpeed(bd)
    boundPosition(bd)

    bd.position = bd.position + bd.velocity
  end
end

function love.load()
  love.window.setTitle("Flocking Boids")
  love.window.setMode(windowSize.width, windowSize.height, {})
  positionBoids()
end

function love.update()
  moveToNewPositions()
end

function love.draw()
  drawBoids()
end
