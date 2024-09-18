local ollama_pilot = {}
ollama_pilot.opts = {}

ollama_pilot.run_current_line = function()
	local line = require("nvim-ollama-pilot.buffer").get_current_line()
	-- TODO: Replace nil with the guidance we want for current line as prompt
	ollama_pilot.request(line, nil)
end

ollama_pilot.setup = function(params)
	ollama_pilot.opts.guidance = params.guidance
	ollama_pilot.opts.debug = params.debug

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

ollama_pilot.request = function(prompt, guidance)
	local request = require("nvim-ollama-pilot.request")
	request.send_post_request(prompt, guidance, function(response, error)
		if error then
			print(error)
		else
			local json = require("nvim-ollama-pilot.json")
			local decoded_response = json.decode(response)
			print("Response: ", decoded_response.response)
		end
	end, ollama_pilot.opts)
end

return ollama_pilot
