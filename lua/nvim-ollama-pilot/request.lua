local request = {}

request.send_post_request = function(prompt, opts, callback)
	local Job = require("plenary.job")
	-- TODO: Dynamically changed delimiter \\n\\n if there isn't a guidance string
	local prompt_string = string.format(
		'{"model": "llama3.1", "prompt": "%s\\n\\n%s", "stream": false}',
		opts.guidance,
		prompt:gsub('"', '\\"')
	)
	if opts.debug then
		print("Prompt String: ", prompt_string)
	end
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
