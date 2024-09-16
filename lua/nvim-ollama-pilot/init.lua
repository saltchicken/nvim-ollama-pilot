local ollama_pilot = {}

ollama_pilot.setup = function()
	print("Setup was called")
end

ollama_pilot.request = function()
	local request = require("nvim-ollama-pilot.request")
	print("Hello World")
end

return ollama_pilot
