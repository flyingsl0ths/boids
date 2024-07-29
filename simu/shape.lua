local utils = require "simu.utils"

local Shapes = {
	triangle = 1,
	square = 2,
	circle = 3
}

Shapes.__index = Shapes
Shapes.__newindex = utils.immutableTable()
Shapes.__metatable = false

--- Computes a random Shape
-- @number The Shape
function Shapes.random()
	return math.random(Shapes.triangle, Shapes.circle)
end

--- Retreives the draw function of a given shape
-- @number shape The Shapes enum variant
-- @treturn function
-- @tparam table ctx The love2d graphics context
-- @number x The x coordinate
-- @number y The y coordinate
-- @treturn function
function Shapes.drawFuncOf(shape)
	if shape == Shapes.triangle then
		return function(ctx, x, y)
			ctx.polygon("fill", x, y, x + 10, y + 10, x - 10, y + 10)
		end
	elseif shape == Shapes.circle then
		return function(ctx, x, y)
			ctx.circle("fill", x, y, 10)
		end
	elseif shape == Shapes.square then
		return function(ctx, x, y)
			ctx.rectangle("fill", x, y, 20, 20)
		end
	else
		return function(ctx, x, y)
			ctx.line(x, y, x + 10, y + 10)
		end
	end
end

return Shapes
