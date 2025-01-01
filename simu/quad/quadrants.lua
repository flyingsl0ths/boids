local utils = require "simu.utils"

local Quadrants = {
	NE = 0,
	NW = 1,
	SE = 2,
	SW = 3
}

Quadrants.__index = Quadrants
Quadrants.__metatable = false
Quadrants.__newindex = utils.immutableTable

return Quadrants
