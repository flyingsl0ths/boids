local base     = require "ui.base"
local utils    = require "utils.utils"
local vec2     = require "utils.vec2"

local Slider   = {}

Slider.__index = Slider

local function new(min, max, step, initial_value)
	local slider = {
		base = base(100, 20),
		min = min or 0,
		max = max or 1,
		value = initial_value or min,
		step = step or 0.01,
		handle_position = vec2(),
		__newindex = utils.immutableTable
	}

	return setmetatable(slider, Slider)
end

function Slider:move(offset_x, offset_y)
	self.base:move(offset_x, offset_y)
	self.handle_position.x = self.base.position.x
	self.handle_position.y = self.base.position.y + (self.base.height / 2)
end

function Slider:draw()
	love.graphics.setColor(self.base.default_color)

	local radius = self.base.height / 2

	love.graphics.line(self.base.position.x, self.base.position.y, self.base.position.x + self.base.width,
		self.base.position.y)

	love.graphics.circle("fill", self.handle_position.x + radius, self.handle_position.y - radius, radius)
end

Slider.__newindex = utils.immutableTable

return setmetatable(Slider, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
