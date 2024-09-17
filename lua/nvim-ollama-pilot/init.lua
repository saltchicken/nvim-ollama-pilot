local function get_current_buffer()
	local buf = vim.api.nvim_get_current_buf()
	return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

local function get_cursor_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_index = cursor_pos[1] - 1
	return line_index
end

local function get_current_line()
	local buf = vim.api.nvim_get_current_buf()
	local line_index = get_cursor_line()
	local line = vim.api.nvim_buf_get_lines(buf, line_index, line_index, false)
	return line
end

local ollama_pilot = {}
ollama_pilot.opts = {}

ollama_pilot.setup = function(params)
	ollama_pilot.opts.guidance = params.guidance
	ollama_pilot.opts.debug = params.debug

	local augroup = vim.api.nvim_create_augroup("Ollama Pilot", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Send request to ollama",
		once = true,
		callback = function()
			vim.api.nvim_create_user_command("OllamaPrompt", function(opts)
				-- print("Sending prompt: ", opts.args)
				ollama_pilot.request(opts.args)
			end, { nargs = 1 })
		end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Test feature. Should not be in prod",
		once = true,
		callback = function()
			vim.api.nvim_create_user_command("OllamaTest", function()
				-- local buffer = get_current_buffer()
				-- print(buffer)
				local line = get_current_line()
				print(line)
			end, {})
		end,
	})
	-- vim.api.nvim_create_autocmd("TextChangedI", {
	-- 	group = augroup,
	-- 	desc = "On text changed",
	-- 	once = false,
	-- 	callback = function()
	-- 		print("Text changed")
	-- 	end,
	-- })
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

-- local function setup()
-- 	local augroup = vim.api.nvim_create_augroup("ExamplePlugin", { clear = true })
-- 	vim.api.nvim_create_autocmd(
-- 		"VimEnter",
-- 		-- { group = augroup, desc = "An example plugin", once = true, callback = main }
-- 		{
-- 			group = augroup,
-- 			desc = "Test function",
-- 			once = true,
-- 			callback = function()
-- 				vim.api.nvim_create_user_command("TestingCommand", function(opts)
-- 					print("Working with " .. opts.args .. "!")
-- 				end, { nargs = 1 })
-- 			end,
-- 		}
-- 	)
-- end
