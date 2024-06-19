local Utils = {}

Utils.__index = Utils
Utils.__newindex = function(_, _, _)
	Utils.immutableTable()
end


function Utils.immutableTable()
	error("Attempt to modify an immutable table")
end

return Utils
