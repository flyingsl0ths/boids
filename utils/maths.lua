local Maths = {
  clamp = function(value, min, max)
    if value < min then
      return min
    elseif value > max then
      return max
    else
      return value
    end
  end,

  point_in_circle = function(p1, p2, radius)
    local d = (p1 - p2):length()
    return d <= (radius * radius)
  end,

  point_in_rectangle = function(p, rx, ry, rw, rh)
    -- px, py: Point coordinates
    -- rx, ry: Top-left corner of the rectangle
    -- rw, rh: Width and height of the rectangle
    return p.x >= rx and p.x <= rx + rw and p.y >= ry and p.y <= ry + rh
  end
}

Maths.__index = Maths

function Maths.immutableTable()
  error("Attempt to modify an immutable table")
end

Maths.__metatable = false
Maths.__newindex = Maths.immutableTable

return Maths
