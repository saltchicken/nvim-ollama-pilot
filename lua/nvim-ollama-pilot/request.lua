local request = {}

request.send_post_request = function(prompt, callback)
	local Job = require("plenary.job")
	local guidance_string = ""
	local prompt_string = string.format(
		'{"model": "llama3.1", "prompt": "%s%s", "stream": false}',
		guidance_string,
		prompt:gsub('"', '\\"')
	)
	-- TODO: This needs to be a debugging thing
	print("Prompt String: ", prompt_string)
	Job:new({
		command = "curl",
		args = {
			"-X",
			"POST",
			"http://localhost:11434/api/generate",
			"-d",
			prompt_string,
			"-H",
			"Content-Type: application/json",
		},
		on_exit = function(j, return_val)
			if return_val == 0 then
				local result = table.concat(j:result(), "\n")
				callback(result)
			else
				print("POST request failed!")
				callback(nil, "Error: POST failed")
			end
		end,
	}):start()
end

return request
