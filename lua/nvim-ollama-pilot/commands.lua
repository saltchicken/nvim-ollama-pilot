local commands = {}

commands.set_commands = function()
	local augroup = vim.api.nvim_create_augroup("Ollama Pilot", { clear = true })
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		desc = "Send request to ollama",
		once = true,
		callback = function()
			vim.api.nvim_create_user_command("OllamaPrompt", function(opts)
				-- print("Sending prompt: ", opts.args)
				require("nvim-ollama-pilot.request").request(opts.args, nil)
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
				local line = require("nvim-ollama-pilot.buffer").get_current_line()
				print(line)
			end, {})
		end,
	})
end

return commands
