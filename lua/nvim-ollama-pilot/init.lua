local ollama_pilot = {}

ollama_pilot.setup = function(opts)
	require("nvim-ollama-pilot.request").setup(opts)
	require("nvim-ollama-pilot.keymaps").set_keymaps()
	require("nvim-ollama-pilot.commands").set_commands()
	-- require("nvim-ollama-pilot.events").setup()
	-- TODO: Add this to enter buffer event
	vim.api.nvim_set_hl(0, "GhostTextOllama", { fg = "#576d74", bold = false, italic = false })
end

ollama_pilot.cleanup = function()
	require("nvim-ollama-pilot.buffer").cleanup()
end

return ollama_pilot
