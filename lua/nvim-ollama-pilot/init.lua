local ollama_pilot = {}
ollama_pilot.opts = {}

ollama_pilot.setup = function(params)
	ollama_pilot.opts.guidance = params.guidance
end

ollama_pilot.request = function(prompt)
	local request = require("nvim-ollama-pilot.request")
	request.send_post_request(prompt, ollama_pilot.opts, function(response, error)
		if error then
			print(error)
		else
			local json = require("nvim-ollama-pilot.json")
			local decoded_response = json.decode(response)
			print("Response: ", decoded_response.response)
		end
	end)
end

return ollama_pilot
