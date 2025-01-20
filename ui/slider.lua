local base     = require "ui.base"
local utils    = require "utils.utils"
local vec2     = require "utils.vec2"
local maths    = require "utils.maths"

local Slider   = {}

Slider.__index = Slider

local function new(initial_value, step, min, max, callback_fn)
	local slider = {
		base = base(100, 20),
		value = initial_value or 0,
		step = step or 0.01,
		min = min or 0,
		max = max or 1,
		handle_position = vec2(),
		callback = callback_fn or nil
	}

	return setmetatable(slider, Slider)
end

function Slider:move(offset_x, offset_y)
	self.base:move(offset_x, offset_y)
	self.handle_position.x = self.base.position.x
	self.handle_position.y = self.base.position.y + (self.base.height / 2)
end

local function get_radius(slider)
	return slider.base.height / 2
end

local function contains_point(p1, p2, radius)
	local d = (p1 - p2):length()
	return d <= (radius * radius)
end

function Slider:update(context)
	if not context.mouse_state.primary_btn_down then
		return
	end

	local mouse_pos = context.mouse_pos

	local radius = get_radius(self)

	if not contains_point(self.handle_position, mouse_pos, radius) then
		return
	end

	local mouse_x = mouse_pos.x
	if mouse_x >= self.base.position.x and mouse_x <= (self.base.position.x + self.base.width) then
		self.handle_position.x = (mouse_pos.x - radius)
		self.value = maths.clamp(self.value + self.step, self.min, self.max)
		if self.callback then
			self.callback(self.value)
		end
	end
end

function Slider:draw(context)
	context.brush.setColor(self.base.default_color)

	local radius = get_radius(self)

	context.brush.line(self.base.position.x, self.base.position.y, self.base.position.x + self.base.width,
		self.base.position.y)

	context.brush.circle("fill", self.handle_position.x + radius, self.handle_position.y - radius, radius)
end

Slider.__newindex = utils.immutableTable

return setmetatable(Slider, {
	__call = function(_, ...)
		return new(...)
	end,

	__metatable = false,

	__newindex = utils.immutableTable
})
