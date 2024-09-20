local ghost_text = {}

ghost_text.state = {
	ghost_text_visible = 0,
}

local ghost_text_ns_id

local original_keymaps = {}

ghost_text.restore_keys = function()
	print("Restore keys hasn't been set yet")
end

function replace_keymap(mode, lhs, rhs, opts)
	-- Save the original keymap
	local original_map = vim.api.nvim_get_keymap(mode)
	local original_rhs = nil

	for _, map in pairs(original_map) do
		if map.lhs == lhs then
			original_rhs = map.rhs
			break
		end
	end

	-- Set the new keymap
	vim.api.nvim_set_keymap(mode, lhs, rhs, opts or {})

	-- Return a function to restore the original keymap
	return function()
		if original_rhs then
			vim.api.nvim_set_keymap(mode, lhs, original_rhs, opts or {})
		else
			-- If there was no original mapping, remove the keymap
			vim.api.nvim_del_keymap(mode, lhs)
		end
	end
end

ghost_text.cleanup = function()
	ghost_text.restore_keys()

	local buf = vim.api.nvim_get_current_buf()

	print("Restoring the buffer")
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = require("nvim-ollama-pilot.buffer").get_current_line()
	print("Debugging current_line ", current_line)
	-- local inserted_ghost_text = string.sub(current_line, 0, cursor_pos[2])
	local pre_line = string.sub(current_line, 0, cursor_pos[2])
	local post_line = string.sub(current_line, cursor_pos[2] + 1 + ghost_text.state.ghost_text_visible)
	-- local inserted_ghost_text = string.sub(inserted_ghost_text, buffer.state.ghost_text_visible)
	local restored_line = pre_line .. post_line
	local line = cursor_pos[1] - 1
	vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { restored_line })
end

ghost_text.clear_ghost_text_highlight = function()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, ghost_text_ns_id, 0, -1)
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
	ghost_text.state.ghost_text_visible = #text
	vim.api.nvim_buf_set_lines(buf, line, line + 1, false, { line_with_ghost_text })
	ghost_text_ns_id = vim.api.nvim_create_namespace("ghost_text_ollama_pilot")
	-- vim.api.nvim_buf_clear_namespace(Testing insert)
	vim.api.nvim_buf_add_highlight(buf, ghost_text_ns_id, "GhostTextOllama", line, cursor_pos[2], cursor_pos[2] + #text)
	-- buffer.set_temporary_keymaps()
	ghost_text.restore_keys = replace_keymap(
		"i",
		"<Esc>",
		'<C-o>:lua require("nvim-ollama-pilot.ghost_text").cleanup()<CR>',
		{ noremap = true }
	)
end

ghost_text.wrapped_insert_ghost_text = function(text)
	vim.schedule_wrap(function()
		ghost_text.insert_ghost_text(text)
	end)()
end

--
-- function buffer.set_temporary_keymaps()
-- 	print("temp keymaps set")
-- 	original_keymaps["<Esc>"] = vim.api.nvim_get_keymap("i") -- for 'Escape' in normal mode
-- 	original_keymaps["<Tab>"] = vim.api.nvim_get_keymap("i") -- for 'Tab' in normal mode
--
-- 	vim.api.nvim_set_keymap(
-- 		"i",
-- 		"<Esc>",
-- 		":lua require('nvim-ollama-pilot.buffer').on_esc_press()<CR>",
-- 		{ noremap = true, silent = true }
-- 	)
-- 	vim.api.nvim_set_keymap(
-- 		"i",
-- 		"<Tab>",
-- 		":lua require('nvim-ollama-pilot.buffer').on_tab_press()<CR>",
-- 		{ noremap = true, silent = true }
-- 	)
-- end
--
-- function buffer.on_esc_press()
-- 	print("escape pressed")
-- 	buffer.revert_keymaps()
-- end
--
-- function buffer.on_tab_press()
-- 	print("tab pressed")
-- 	buffer.revert_keymaps()
-- end
--
-- function buffer.revert_keymaps()
-- 	-- Revert 'Escape' keymap
-- 	if original_keymaps["<Esc>"] then
-- 		vim.api.nvim_del_keymap("i", "<Esc>")
-- 		for _, mapping in ipairs(original_keymaps["<Esc>"]) do
-- 			if mapping.lhs == "<Esc>" then
-- 				vim.api.nvim_set_keymap(
-- 					"i",
-- 					mapping.lhs,
-- 					mapping.rhs,
-- 					{ noremap = mapping.noremap, silent = mapping.silent }
-- 				)
-- 			end
-- 		end
-- 	end
--
-- 	-- Revert 'Tab' keymap
-- 	if original_keymaps["<Tab>"] then
-- 		vim.api.nvim_del_keymap("i", "<Tab>")
-- 		for _, mapping in ipairs(original_keymaps["<Tab>"]) do
-- 			if mapping.lhs == "<Tab>" then
-- 				vim.api.nvim_set_keymap(
-- 					"i",
-- 					mapping.lhs,
-- 					mapping.rhs,
-- 					{ noremap = mapping.noremap, silent = mapping.silent }
-- 				)
-- 			end
-- 		end
-- 	end
-- end
-- k
return ghost_text
