local utils = {}

utils.tableFromString = function(inputString)
	local result = {}
	for line in string.gmatch(inputString, "[^\r\n]+") do
		table.insert(result, line)
	end
	return result
end

return utils
