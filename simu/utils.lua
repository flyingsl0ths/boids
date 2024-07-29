local Utils = {}

Utils.__index = Utils

function Utils.immutableTable()
	error("Attempt to modify an immutable table")
end

Utils.__metatable = false
Utils.__newindex = Utils.immutableTable

return Utils
