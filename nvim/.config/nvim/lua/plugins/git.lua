---@diagnostic disable: missing-fields
return {
  -- {
  --   'sindrets/diffview.nvim',
  --   enabled = false,
  --   config = function()
  --     -- todo
  --   end,
  -- },
  -- {
  --   'tpope/vim-fugitive',
  --   enabled = false,
  --   config = function()
  --     -- todo
  --   end,
  -- },
  -- {
  --   'tpope/vim-rhubarb',
  --   enabled = false,
  --   config = function()
  --     -- todo
  --   end,
  -- },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    enabled = true,
    config = function()
      require('gitsigns').setup({
        -- See `:help gitsigns.txt`
        current_line_blame = true,
        current_line_blame_formatter = " <author>, <author_time:%R> (<author_time:%Y-%m-%d>) - <summary> ",
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 0,             -- instant
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
              { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
            vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
              { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
            vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
              { buffer = bufnr, desc = '[P]review [H]unk' })
            print("hello attach")
          end,
        },
      })

      vim.api.nvim_create_user_command('GitBlame', function()
          require("gitsigns").toggle_current_line_blame()
        end,
        { desc = 'Toggle git blame on line' })
    end,
  }
}
