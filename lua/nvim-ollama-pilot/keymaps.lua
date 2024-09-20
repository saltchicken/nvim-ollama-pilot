local keymaps = {}

local restore_functions = {}

keymaps.set_keymaps = function()
	-- TODO: Fix augroup naming
	local augroup = vim.api.nvim_create_augroup("Ollama Pilot2", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Set keymaps",
		once = true,
		callback = function()
			-- TODO: This needs to be refactored modified via plugin config
			-- Set Control Space to run_current_line
			vim.keymap.set(
				"i",
				"<C-l>",
				require("nvim-ollama-pilot.core").run_current_line,
				{ noremap = false, silent = true }
			)
			vim.keymap.set(
				"v",
				"<C-l>",
				require("nvim-ollama-pilot.core").run_current_selection,
				{ noremap = false, silent = true }
			)
			-- This keymap only used for testing
			-- vim.keymap.set(
			-- 	"i",
			-- 	"<C-a>",
			-- 	require("nvim-ollama-pilot.buffer").insert_ghost_text,
			-- 	{ noremap = false, silent = true }
			-- )
		end,
	})
end

keymaps.restore_keys = function()
	for _, restore in ipairs(restore_functions) do
		restore()
	end
end

keymaps.set_ghost_text_keymap = function()
	-- Reset table
	restore_functions = {}
	-- Replace Escape
	table.insert(
		restore_functions,
		require("nvim-ollama-pilot.keymaps").replace_keymap(
			"i",
			"<Esc>",
			'<C-o>:lua require("nvim-ollama-pilot.ghost_text").abort()<CR>',
			{ noremap = true }
		)
	)
	-- Replace Tab
	table.insert(
		restore_functions,
		require("nvim-ollama-pilot.keymaps").replace_keymap(
			"i",
			"<Tab>",
			'<C-o>:lua require("nvim-ollama-pilot.ghost_text").accept()<CR>',
			{ noremap = true }
		)
	)
end

keymaps.replace_keymap = function(mode, lhs, rhs, opts)
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

-- local original_keymaps = {}
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
return keymaps
