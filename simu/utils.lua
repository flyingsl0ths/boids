local Utils = {}

Utils.__index = Utils
Utils.__newindex = Utils.immutableTable
Utils.__metatable = false

function Utils.immutableTable()
	error("Attempt to modify an immutable table")
end

return Utils
