local Maths = {
  clamp = function(value, min, max)
    if value < min then
      return min
    elseif value > max then
      return max
    else
      return value
    end
  end
}

Maths.__index = Maths

function Maths.immutableTable()
  error("Attempt to modify an immutable table")
end

Maths.__metatable = false
Maths.__newindex = Maths.immutableTable

return Maths
