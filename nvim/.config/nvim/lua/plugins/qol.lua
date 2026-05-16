-- Quality of life
return {
	-- Detect tabstop and shiftwidth automatically on a file basis
	-- { 'tpope/vim-sleuth' },

	-- Compile, change make programs, flush to quickfixlist, spawns tmux to build
	{
		'tpope/vim-dispatch',
		enabled = true,
	},

	-- Useful plugin to show you pending keybinds.
	{
		'folke/which-key.nvim', opts = {}
	},

	-- Autopair
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	-- Auto generate doxygen template
	{
		'danymat/neogen',
		enabled = true,
		config = function()
			require('neogen').setup({})
			vim.keymap.set("n", "<Leader>gnd", function() vim.cmd("Neogen") end,
				{ desc = "[G]enerate [N]ew [D]ocumentation", noremap = true, silent = true })
		end,
	},

	-- Zen mode
	{
		'folke/zen-mode.nvim',
		cmd = 'ZenMode',
		keys = {
			{ '<leader>z', '<cmd>ZenMode<cr>', desc = '[Z]en Mode' },
		},
		opts = {},
	},

	-- Markdown previewer
	{
		enabled = false,
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},

	-- Inline markdown renderer
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
