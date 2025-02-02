local base    = require "ui.base"
local utils   = require "utils.utils"
local vec2    = require "utils.vec2"
local maths   = require "utils.maths"

local Label   = {}

Label.__index = Label

local function new(text)
  local self = {
    base = base(100, 20),
    text = text,
    hint_text = text,
    on_hover = nil,
    mouse_hovering = false
  }

  return setmetatable(self, Label)
end

function Label:update(ui_context)
  local p = self.base.position

  self.mouse_hovering =
      ui_context.mouse_state.primary_btn_down
      and
      maths.point_in_rectangle(ui_context.mouse_pos, p.x, p.y,
        self.base.width, self.base.height)
end

function Label:draw(ui_context)
  ui_context.brush.setColor(self.base.default_color)

  ui_context.brus.print(self.text, self.base.position:spread())
end
