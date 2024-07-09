local utils = require "simu.utils"

local QuadTree = {}
QuadTree.__index = QuadTree

local function new()
	local t = {
	}
	return setmetatable(t, QuadTree)
end

return setmetatable(QuadTree, {
	__call = function(_, ...)
		return new(...)
	end,

	__newindex = function(_, _, _)
		utils.immutableTable()
	end
})
