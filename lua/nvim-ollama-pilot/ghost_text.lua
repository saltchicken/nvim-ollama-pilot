local ghost_text = {}

ghost_text.state = {}

local create_ghost_text_object = function(text, highlight_namespace)
	ghost_text.state = {}
	ghost_text.state.text = text
	ghost_text.state.highlight_namespace = highlight_namespace
end

ghost_text.abort = function()
	require("nvim-ollama-pilot.keymaps").restore_keys()

	local buf = vim.api.nvim_get_current_buf()

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = require("nvim-ollama-pilot.buffer").get_current_line()
	--
	local pre_line = string.sub(current_line, 0, cursor_pos[2])
	local post_line = string.sub(current_line, cursor_pos[2] + 1 + #ghost_text.state.text)
	local restored_line = pre_line .. post_line

	local line = cursor_pos[1] - 1
	vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { restored_line })
end

ghost_text.accept = function()
	require("nvim-ollama-pilot.keymaps").restore_keys()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, ghost_text.state.highlight_namespace, 0, -1)

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]
	local col = cursor[2]

	vim.api.nvim_win_set_cursor(0, { row, col + #ghost_text.state.text })
end

ghost_text.insert_ghost_text = function(text)
	-- TODO: Enable multiline ghost text
	-- Return the first line of the output. Error if not
	local new_text = string.match(text, "^[^\r\n]*")
	text = new_text
	local buf = vim.api.nvim_get_current_buf()

	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = cursor_pos[1] - 1
	local current_line = require("nvim-ollama-pilot.buffer").get_current_line()
	-- TODO: This only works on a single line. Needs to return the whole buffer for multiline
	local pre_line = string.sub(current_line, 0, cursor_pos[2])
	local post_line = string.sub(current_line, cursor_pos[2] + 1)
	local line_with_ghost_text = pre_line .. text .. post_line
	vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { line_with_ghost_text })

	local ghost_text_ns_id = vim.api.nvim_create_namespace("ghost_text_ollama_pilot")

	create_ghost_text_object(text, ghost_text_ns_id)

	vim.api.nvim_buf_add_highlight(buf, ghost_text_ns_id, "GhostTextOllama", line, cursor_pos[2], cursor_pos[2] + #text)

	require("nvim-ollama-pilot.keymaps").set_ghost_text_keymap()
end

ghost_text.wrapped_insert_ghost_text = function(text)
	vim.schedule_wrap(function()
		ghost_text.insert_ghost_text(text)
	end)()
end

return ghost_text
