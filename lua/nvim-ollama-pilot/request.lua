local request = {}
request.opts = {}

request.setup = function(opts)
	request.opts = opts
end

local function send_post_request(prompt, guidance, callback, opts)
	local Job = require("plenary.job")
	if guidance then
		guidance = guidance .. "\\n\\n"
	else
		guidance = ""
	end
	local prompt_string = string.format(
		'{"model": "llama3.1", "prompt": "%s%s", "stream": false}',
		guidance,
		prompt:gsub('"', '\\"'):gsub("\t", "\\t")
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

request.request = function(prompt, guidance, callback)
	if callback then
		send_post_request(prompt, guidance, function(response, error)
			if error then
				print(error)
			else
				local json = require("nvim-ollama-pilot.json")
				local decoded_response = json.decode(response)
				callback(decoded_response.response)
			end
		end, request.opts)
	else
		send_post_request(prompt, guidance, function(response, error)
			if error then
				print(error)
			else
				local json = require("nvim-ollama-pilot.json")
				local decoded_response = json.decode(response)
				print("DEFAULT CALLBACK RESPONSE: ", decoded_response.response)
			end
		end, request.opts)
	end
end

return request
