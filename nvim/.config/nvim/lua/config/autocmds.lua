-- Highlight on yank `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	pattern = '*',
})

