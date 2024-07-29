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

function Node:insert(point)
	if not self.boundary:contains(point) then
		return false
	end

	if not self.divided then
		if self:isShallow() then
			table.insert(self.points, point)
			return true
		end

		self:subdivide()
	end

	return self.north_west:insert(point) or
	    self.north_east:insert(point) or
	    self.south_west:insert(point) or
	    self.south_east:insert(point)
end

function Node:isShallow()
	return #self.points < self.capacity or self.depth == self.max_depth
end

function Node:subdivide()
	local max_depth = self.max_depth + 1
	self.north_west = new(self.boundary:subdivide(quadrants.NORTH_WEST), self.capacity, max_depth)
	self.north_east = new(self.boundary:subdivide(quadrants.NORTH_EAST), self.capacity, max_depth)
	self.south_west = new(self.boundary:subdivide(quadrants.SOUTH_WEST), self.capacity, max_depth)
	self.south_east = new(self.boundary:subdivide(quadrants.SOUTH_EAST), self.capacity, max_depth)

	self.divided = true

	for _, value in ipairs(self.points) do
		local inserted = self.north_west:insert(value) or
		    self.north_east:insert(value) or
		    self.south_west:insert(value) or
		    self.south_east:insert(value)

		if not inserted then
			error("Capacity must be greater than zero")
		end
	end

	self.points = nil
end

local function query(node, range, found)
	if not range:interset(node.boundary) then
		return found
	end

	if node.divided then
		query(node.north_west, range, found)
		query(node.north_east, range, found)
		query(node.south_west, range, found)
		query(node.south_east, range, found)
		return found
	end

	for _, point in ipairs(node.points) do
		if range:contains(point) then
			table.insert(found, point)
		end
	end
end

function Node:query(range)
	local found = {}
	query(self, range, found)
	return found
end

Node.__newindex = utils.immutableTable

return setmetatable(Node, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
