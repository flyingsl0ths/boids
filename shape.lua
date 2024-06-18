local utils = require("utils")

local Shapes = {
	triangle = 1,
	square = 2,
	circle = 3
}

--- Computes a random Shape
-- @number The Shape
function Shapes.random()
	return math.random(Shapes.triangle, Shapes.circle)
end

return setmetatable({}, {
	__index = Shapes,
	__newindex = function(_, _, _)
		utils.immutableTable()
	end
})
