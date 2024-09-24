local utils = {}

utils.tableFromString = function(inputString)
	local result = {}
	for line in string.gmatch(inputString, "[^\r\n]+") do
		table.insert(result, line)
	end
	return result
end

utils.remove_code_prefix_and_suffix = function(text_table)
	-- TODO: Make sure that input is a table
	for i = #text_table, 1, -1 do
		if text_table[i] then
			if string.find(text_table[i], "```") then
				table.remove(text_table, i)
			end
		else
			print("What is wrong with :", text_table[i])
		end
	end
	return text_table
end

return utils
