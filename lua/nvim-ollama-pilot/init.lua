local ollama_pilot = {}

ollama_pilot.run_current_line = function()
	local line = require("nvim-ollama-pilot.buffer").get_current_line()
	-- TODO: Replace nil with the guidance we want for current line as prompt
	require("nvim-ollama-pilot.request").request(line, nil)
end

ollama_pilot.setup = function(opts)
	require("nvim-ollama-pilot.request").setup(opts)
	require("nvim-ollama-pilot.keymaps").set_keymaps()
	require("nvim-ollama-pilot.commands").set_commands()

	-- vim.api.nvim_create_autocmd("TextChangedI", {
	-- 	group = augroup,
	-- 	desc = "On text changed",
	-- 	once = false,
	-- 	callback = function()
	-- 		print("Text changed")
	-- 	end,
	-- })
end

return ollama_pilot
