local core = {}

core.run_current_line = function()
	local line = require("nvim-ollama-pilot.buffer").get_current_line()
	local guidance =
		"You are being used for code completion. Only respond with the continuation of the given line of code."
	local callback = function(response)
		require("nvim-ollama-pilot.ghost_text").wrapped_insert_ghost_text(response)
	end
	require("nvim-ollama-pilot.request").request(line, guidance, callback)
end

core.run_current_buffer = function()
	local buffer = require("nvim-ollama-pilot.buffer").get_current_buffer()
	local payload = ""
	for _, line in ipairs(buffer) do
		payload = payload .. line
	end
	local callback = function(response)
		print(response)
	end
	require("nvim-ollama-pilot.request").request(payload, nil, callback)
end

core.run_current_selection = function()
	local selection = require("nvim-ollama-pilot.buffer").get_current_selection()
	local callback = function(response)
		print(response)
	end
	require("nvim-ollama-pilot.request").request(payload, nil, callback)
end

return core
