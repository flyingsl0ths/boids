local utils = require "utils.utils"
local vec2 = require "utils.vec2"

local Context = {}

Context.__index = Context

local function new(graphics_context)
  return setmetatable({
    mouse_pos = vec2(),
    dt = 0,
    mouse_state = {
      primary_btn_down = false,
      secondary_btn_down = false,
      middle_btn_down = false,
    },
    brush = graphics_context
  }, Context)
end

function Context:get_mouse_xy()
  return self.mouse_pos.x, self.mouse_pos.y
end

Context.__metatable = false
Context.__newindex = utils.immutableTable

return setmetatable(Context, {
  __call = function(_, ...)
    return new(...)
  end,

  __metatable = false,

  __newindex = utils.immutableTable,
})
