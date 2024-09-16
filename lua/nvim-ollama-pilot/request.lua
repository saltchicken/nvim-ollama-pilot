local request = {}

request.send_post_request = function(text, callback)
	local Job = require("plenary.job")
	print("Iam the text: ", text)
	local guidance_string = ""
	-- local guidance_string =
	--      "You area a code completer. Only respond with appended code that is recommended. In the following example how would you complete the line of code? "
	local escaped_text = text:gsub('"', '\\"')
	local prompt_string =
		string.format('{"model": "llama3.1", "prompt": "%s%s", "stream": false}', guidance_string, escaped_text)
	print("Prompt STring", prompt_string)
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
