local events = {}

events.setup = function()
	local augroup = vim.api.nvim_create_augroup("Ollama Pilot3", { clear = true })
	vim.api.nvim_create_autocmd("TextChangedI", {
		group = augroup,
		desc = "On text changed",
		once = false,
		callback = function()
			print("Text changed")
		end,
	})
end

return events
