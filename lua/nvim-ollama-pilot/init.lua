local ollama_pilot = {}

ollama_pilot.setup = function()
	print("Setup was called")
	print(config)
end

ollama_pilot.request = function()
	local request = require("nvim-ollama-pilot.request")
	request.send_post_request("How is it going?", function(response, error)
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
