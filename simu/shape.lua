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

function Shape.draw_function_of(ctx, boid_shape)
	if boid_shape == Shapes.triangle then
		return function(x, y)
			ctx.polygon("fill", x, y, x + 10, y + 10, x - 10, y + 10)
		end
	elseif boid_shape == Shapes.circle then
		return function(x, y)
			ctx.circle("fill", x, y, 10)
		end
	elseif boid_shape == Shapes.square then
		return function(x, y)
			ctx.rectangle("fill", x, y, 20, 20)
		end
	else
		return function(x, y)
			ctx.line(x, y, x + 10, y + 10)
		end
	end
end

return setmetatable({}, {
	__index = Shapes,
	__newindex = function(_, _, _)
		utils.immutableTable()
	end
})
