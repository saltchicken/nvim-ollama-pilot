local ollama_pilot = {}

ollama_pilot.setup = function(opts)
	require("nvim-ollama-pilot.request").setup(opts)
	require("nvim-ollama-pilot.keymaps").set_keymaps()
	require("nvim-ollama-pilot.commands").set_commands()
	-- require("nvim-ollama-pilot.events").setup()
end

return ollama_pilot
