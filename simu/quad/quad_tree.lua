local node = require "simu.quad.node"
local utils = require "simu.utils"

local CAPACITY = 8
local MAX_DEPTH = 8

local QuadTree = {}

QuadTree.__index = QuadTree

local function new(boundary, root, capacity, max_depth)
	local instance = {
		boundary = boundary,
		root = root or node(boundary, capacity or CAPACITY, max_depth or MAX_DEPTH),
	}
	return setmetatable(instance, QuadTree)
end

function QuadTree:insert(point)
	return self.root:insert(point)
end

function QuadTree:query(range)
	return self.root:query(range)
end

QuadTree.__newindex = utils.immutableTable

return setmetatable(QuadTree, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable,
})
