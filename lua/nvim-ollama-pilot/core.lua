local core = {}

core.run_current_line = function()
	local line = require("nvim-ollama-pilot.buffer").get_current_line()
	local guidance =
		"You are being used for code completion. Only respond with the continuation of the given line of code."
	local callback = function(response)
		require("nvim-ollama-pilot.ghost_text").wrapped_insert_ghost_text(response)
	end
	require("nvim-ollama-pilot.request").request(line, guidance, callback)
end

core.create_modal = function(response)
	local buf = vim.api.nvim_create_buf(false, true) -- false: listed, true: scratch buffer

	-- Set some lines in the buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, response)

	-- Define window options
	local opts = {
		relative = "editor",
		width = 100,
		height = 80,
		row = 30,
		col = 50,
		style = "minimal",
		border = "single",
	}

	-- Open the window
	vim.api.nvim_open_win(buf, true, opts)
end
core.wrapped_create_modal = function(response)
	vim.schedule_wrap(function()
		core.create_modal(response)
	end)()
end

core.run_current_buffer = function()
	local buffer = require("nvim-ollama-pilot.buffer").get_current_buffer()
	local payload = ""
	for _, line in ipairs(buffer) do
		payload = payload .. line
	end
	local callback = function(response)
		local new_response = require("nvim-ollama-pilot.utils").tableFromString(response)
		-- local new_response = string.match(response, "^[^\r\n]*")

		response = new_response
		core.wrapped_create_modal(response)
	end
	require("nvim-ollama-pilot.request").request(payload, nil, callback)
end

core.run_current_selection = function()
	local selection = require("nvim-ollama-pilot.buffer").get_current_selection()
	local callback = function(response)
		response = require("nvim-ollama-pilot.utils").tableFromString(response)
		response = require("nvim-ollama-pilot.utils").remove_code_prefix_and_suffix(response)
		require("nvim-ollama-pilot.buffer").replace_current_line_and_insert_chunk(response)
	end
	local guidance =
		"You are being given a request to write some code. Consider the following request only return the relevant code without any explanation."
	require("nvim-ollama-pilot.request").request(selection, guidance, callback)
end

return core
