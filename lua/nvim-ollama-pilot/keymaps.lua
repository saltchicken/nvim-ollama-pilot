local keymaps = {}

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
			vim.keymap.set(
				"i",
				"<C-a>",
				require("nvim-ollama-pilot.buffer").insert_ghost_text,
				{ noremap = false, silent = true }
			)
		end,
	})
end

return keymaps
