-- Disable space in normal/visual mode (it's used as leader)
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { noremap = true, silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Split nvim window
vim.keymap.set('n', '<C-w>|', ":vsplit<cr>")
vim.keymap.set('n', '<C-w>-', ":split<cr>")
vim.keymap.set('i', 'jf', '<Esc>')

-- Move blocks of code in visual mode 
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")

-- Keep search centered
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzzv")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")

-- Yank to system clipboards
vim.keymap.set('x', "<Leader>p", "\"_dP")

-- Delete into void
vim.keymap.set({'n', 'v'}, "<Leader>d", "\"_d")

-- Delete current highlight into void instead of yank buffer and paste yank. 
vim.keymap.set({'x', 'v'}, "<Leader>y", "\"+y")
vim.keymap.set('n', "<Leader>Y", "\"+y")

-- Shorthand for replacing word under cursor
vim.keymap.set('n', '<Leader>s', [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { noremap = true, desc = "Replace word under cursor in buffer" })

-- Reload (reset highlight, diffs, and redraws) - was default CTRL+L but we use this for tmux zoom now
vim.keymap.set('n', '<Leader>r', function()
  vim.cmd('nohlsearch')
  vim.cmd('diffupdate')
  vim.cmd('redraw!')
end, { noremap = true, silent = true })

-- Quickfix list management
vim.keymap.set('n', '<C-h>', "<cmd>cnext<CR>zz")
vim.keymap.set('n', '<C-;>', "<cmd>cprev<CR>zz")
vim.keymap.set('n', '<Leader>h', "<cmd>lnext<CR>zz")
vim.keymap.set('n', '<Leader>;', "<cmd>lprev<CR>zz")
vim.keymap.set('n', '<Leader>qd', function()
	vim.cmd("cexpr []")
	vim.cmd("cclose")
end, { silent = true, })
vim.keymap.set('n', '<Leader>ql', function()
	if not is_open then
		vim.cmd("copen")
		is_open = true
	else
		vim.cmd("cclose")
		is_open = false
	end
end, { silent = true, })

-- Open links under cursor (good when checking documentation for function signature
-- then needing to go to a link to find nested definitions for arguments)
-- override gx if we see 'file' to do vsplit, otherwise just do default vim.ui.open()
vim.keymap.set('n', 'gx', function()
  -- Get the text under the cursor
  local url = vim.fn.expand('<cfile>')

  -- Check if it starts with "file://"
  if url:match("^file://") then
    -- Remove "file://" prefix and split on "#L" for line number
    local filepath, line = url:match("^file://([^#]+)#?L?(%d*)")
    if filepath then
      -- Open the file in a split
      vim.cmd("split " .. vim.fn.fnameescape(filepath))
      -- Jump to the specified line, if any
      if line ~= "" then
        vim.cmd(line)
      end
      return
    end
  end

  -- Fallback to the default `gx` behavior (open the URL)
  vim.ui.open(url); -- :h gx
  --vim.fn["netrw#BrowseX"](url, 0)
end)

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Game changer (toggle parameter names beside arguments!)
-- vim.keymap.set("n", '<leader>i',
-- function()
-- 	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
-- end)

