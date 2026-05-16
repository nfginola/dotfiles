vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Global options
vim.opt.hlsearch = false -- Highlight matches
vim.opt.incsearch = true -- Incremental search
-- vim.opt.clipboard = 'unnamedplus'      -- Sync with system clipboard
vim.opt.completeopt = "menuone,noselect" -- Better completion
vim.opt.termguicolors = true -- True color support
vim.opt.scrolloff = 8 -- Pre/post lines around cursor
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Unless uppercase in search
vim.opt.updatetime = 250 -- Faster swap / CursorHold
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Buffer-local options
vim.opt.indentkeys = "" -- Disable automatic indent keys
vim.opt.undofile = true -- Persistent undo
vim.opt.expandtab = false -- Keep real tabs, don’t convert to spaces
vim.opt.tabstop = 4 -- Display a tab character as 4 spaces
vim.opt.softtabstop = 0  -- Tab key inserts a real tab
vim.opt.shiftwidth = 4 -- Indent width for >>, <<, autoindent

-- Window-local options
vim.opt.breakindent = true   -- Wrapped lines keep indent
vim.opt.foldenable = false  -- Disable code folding
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.number = true   -- Current line absolute
vim.opt.signcolumn = 'yes'   -- Always show sign column
vim.opt.wrap = true   -- Wrap long lines
vim.opt.cursorline = true -- Highlight current line
vim.opt.cursorcolumn = false  -- Don't highlight column

-- Use ripgrep for :vimgrep and :grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- can be "■", "▎", "●", or anything you like
		spacing = 2, -- distance from the code
		source = "if_many", -- show the source if there are multiple
	},
	signs = true,
	underline = true,
	update_in_insert = true, -- update diagnostics while typing
	severity_sort = true,
})
