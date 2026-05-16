-- Colors by highlight group
vim.api.nvim_set_hl(0, 'LineNr', { fg = "#a6d5e3" })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "#f277c7" })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = "#ab2ff7", fg = "#a7f235", bold = true })
vim.api.nvim_set_hl(0, 'Visual', { bg = "#08592b" })
vim.api.nvim_set_hl(0, "Search", { bg = "#590852" })
vim.api.nvim_set_hl(0, 'CursorBG', { bg = "white" })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = "red" })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = "orange" })
-- CursorBG is a custom highlight group
vim.opt.guicursor = "n-v-c-sm:block-CursorBG,i-ci-ve:ver25,r-cr-o:hor20"
