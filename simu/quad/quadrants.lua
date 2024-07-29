local utils = require "simu.utils"

local Quadrants = {
	NW = 0,
	NE = 1,
	SW = 2,
	SE = 3
}

Quadrants.__index = Quadrants
Quadrants.__metatable = false
Quadrants.__newindex = utils.immutableTable

return Quadrants
