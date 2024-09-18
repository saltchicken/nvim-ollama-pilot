local core = {}

core.run_current_line = function()
	local line = require("nvim-ollama-pilot.buffer").get_current_line()
	-- TODO: Replace nil with the guidance we want for current line as prompt
	require("nvim-ollama-pilot.request").request(line, nil)
end

core.run_current_buffer = function()
	local buffer = require("nvim-ollama-pilot.buffer").get_current_buffer()
	require("nvim-ollama-pilot.request").request(buffer, nil)
end

return core
