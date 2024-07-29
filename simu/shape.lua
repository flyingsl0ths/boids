local utils = require "simu.utils"

local Shapes = {
	TRIANGLE = 1,
	SQUARE = 2,
	CIRCLE = 3
}

Shapes.__index = Shapes

--- Computes a random Shape
-- @number The Shape
function Shapes.random()
	return math.random(Shapes.TRIANGLE, Shapes.CIRCLE)
end

--- Retreives the draw function of a given shape
-- @number shape The Shapes enum variant
-- @treturn function
-- @tparam table ctx The love2d graphics context
-- @number x The x coordinate
-- @number y The y coordinate
-- @treturn function
function Shapes.drawFuncOf(shape)
	if shape == Shapes.TRIANGLE then
		return function(ctx, x, y)
			ctx.polygon("fill", x, y, x + 10, y + 10, x - 10, y + 10)
		end
	elseif shape == Shapes.CIRCLE then
		return function(ctx, x, y)
			ctx.circle("fill", x, y, 10)
		end
	elseif shape == Shapes.SQUARE then
		return function(ctx, x, y)
			ctx.rectangle("fill", x, y, 20, 20)
		end
	else
		return function(ctx, x, y)
			ctx.line(x, y, x + 10, y + 10)
		end
	end
end

Shapes.__metatable = false
Shapes.__newindex = utils.immutableTable

return Shapes
