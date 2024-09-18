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

return buffer
