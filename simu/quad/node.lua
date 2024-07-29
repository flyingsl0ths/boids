local utils = require "simu.utils"
local quadrants = require "simu.quad.quadrants"

local Node = {}

Node.__index = Node

local function new(boundary, capacity, max_depth)
	local instance = {
		boundary = boundary,
		north_west = nil,
		north_east = nil,
		south_west = nil,
		south_east = nil,
		capacity = capacity,
		max_depth = max_depth,
		points = {},
		divided = false
	}
	return setmetatable(instance, Node)
end

local function subdivide(node)
	local max_depth = self.max_depth + 1
	node.north_west = new(node.boundary:subdivide(quadrants.NORTH_WEST), node.capacity, max_depth)
	node.north_east = new(node.boundary:subdivide(quadrants.NORTH_EAST), node.capacity, max_depth)
	node.south_west = new(node.boundary:subdivide(quadrants.SOUTH_WEST), node.capacity, max_depth)
	node.south_east = new(node.boundary:subdivide(quadrants.SOUTH_EAST), node.capacity, max_depth)

	node.divided = true

	for _, value in ipairs(node.points) do
		local inserted = node.north_west:insert(value) or
		    node.north_east:insert(value) or
		    node.south_west:insert(value) or
		    node.south_east:insert(value)

		if not inserted then
			error("Capacity must be greater than zero")
		end
	end

	node.points = nil
end

local function isShallow(node)
	return #self.points < self.capacity or self.depth == self.max_depth
end

function Node:insert(point)
	if not self.boundary:contains(point) then
		return false
	end

	if not self.divided then
		if isShallow(self) then
			table.insert(self.points, point)
			return true
		end

		subdivide(self)
	end

	return self.north_west:insert(point) or
	    self.north_east:insert(point) or
	    self.south_west:insert(point) or
	    self.south_east:insert(point)
end

function Node:query(range, found)
	if not range:interset(self.boundary) then
		return found
	end

	if self.divided then
		self.north_west:query(range, found)
		self.north_east:query(range, found)
		self.south_west:query(range, found)
		self.south_east:query(range, found)
		return found
	end

	for _, point in ipairs(self.points) do
		if range:contains(point) then
			table.insert(found, point)
		end
	end
end

Node.__newindex = utils.immutableTable

return setmetatable(Node, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
