local core = {}

core.run_current_line = function()
	local line = require("nvim-ollama-pilot.buffer").get_current_line()
	-- TODO: Replace nil with the guidance we want for current line as prompt
	local guidance =
		"You are being used for code completion. Only respond with the continuation of the given line of code."
	-- require("nvim-ollama-pilot.request").request(line, nil)
	require("nvim-ollama-pilot.request").request(line, guidance)
end

core.run_current_buffer = function()
	local buffer = require("nvim-ollama-pilot.buffer").get_current_buffer()
	local payload = ""
	for _, line in ipairs(buffer) do
		payload = payload .. line
	end
	-- local callback = function(response, error)
	-- 	if error then
	-- 		print(error)
	-- 	else
	-- 		local json = require("nvim-ollama-pilot.json")
	-- 		local decoded_response = json.decode(response)
	-- 		print("Analysis complete: ", decoded_response.response)
	-- 	end
	-- end
	local action = function(response)
		require("nvim-ollama-pilot.ghost_text").wrapped_insert_ghost_text(response)
	end
	local response = require("nvim-ollama-pilot.request").request(payload, nil, action)
end

core.run_current_selection = function()
	local selection = require("nvim-ollama-pilot.buffer").get_current_selection()
	require("nvim-ollama-pilot.request").request(selection, nil)
end

return core
