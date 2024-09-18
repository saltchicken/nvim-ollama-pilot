local buffer = {}

buffer.get_current_buffer = function()
	local buf = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

buffer.get_cursor_line = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_index = cursor_pos[1] - 1
	return line_index
end

buffer.get_current_line = function()
	local buf = vim.api.nvim_get_current_buf()
	local line_index = buffer.get_cursor_line()
	local lines = vim.api.nvim_buf_get_lines(buf, line_index, line_index + 1, false)
	return lines[1]
end

buffer.get_current_selection = function()
	print("Running get_current_selection")
	-- local buf = vim.api.nvim_get_current_buf()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getpos(".")

	local start_row = start_pos[2]
	local start_col = start_pos[3]
	local end_row = end_pos[2]
	local end_col = end_pos[3]

	local lines = vim.fn.getline(start_row, end_row)

	for i, lines in ipairs(lines) do
		print(i, ":", lines)
	end
	-- if #lines == 1 then
	-- 	lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
	-- else
	-- 	lines[1] = string.sub(lines[1], start_pos[3])
	-- 	lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	-- end

	-- local payload = ""
	-- for _, line in ipairs(lines) do
	-- 	payload = payload .. line
	-- end
	-- return payload
	-- return table.concat(lines, "\n")
end

return buffer
