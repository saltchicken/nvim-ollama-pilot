local keymaps = {}

keymaps.set_keymaps = function()
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
		end,
	})
end

return keymaps
