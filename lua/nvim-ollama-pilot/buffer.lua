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

buffer.replace_current_line_and_insert_chunk = function(response)
	vim.schedule_wrap(function()
		local line_index = buffer.get_cursor_line()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_lines(buf, line_index, line_index + 1, false, response)
	end)()
end

buffer.get_current_selection = function()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getpos(".")

	local start_row = start_pos[2]
	local start_col = start_pos[3]
	local end_row = end_pos[2]
	local end_col = end_pos[3]

	-- This is needed because start and end are switched depending on how user selects.
	-- This ensures that start row is on top. Also col needs to switch to stay consistent.
	if start_row > end_row then
		start_row, end_row = end_row, start_row
		start_col, end_col = end_col, start_col
	end

	-- print("Start_row: ", start_row, " End_row ", end_row)
	-- print("Start_col: ", start_col, " End_col ", end_col)

	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, start_row - 1, end_row, false)

	local current_mode = vim.fn.mode()
	if current_mode == "v" then
		-- Visual mode. Handle cursor column position
		lines[1] = string.sub(lines[1], start_col)
		lines[#lines] = string.sub(lines[#lines], 0, end_col)
		return table.concat(lines, "\n")
	elseif current_mode == "V" then
		-- Visual Line mode.
		return table.concat(lines, "\\n")
	else
		print("ERROR: Not in Visual or Visual Line mode")
		return nil
	end
end

return buffer
