return {
  -- Theme
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      -- Settings available at https://github.com/sainnhe/gruvbox-material
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      -- https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt
      -- 'vim.g' is preferred when setting globals (i.e 'let g:gruvbox__ = value')
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_better_performance = 1

      vim.g.gruvbox_material_colors_override = {
        bg0 = { '#0c0c0c', '234' },
      }

      vim.cmd.colorscheme('gruvbox-material')
    end
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'gruvbox-material',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        --lualine_a = {},
        lualine_a = {
          { 'branch',      color = { fg = 'red', bg = 'black', gui = 'italic,bold' } },
          { 'diff',        color = { bg = 'grey', gui = 'italic,bold' } },
          { 'diagnostics', color = { bg = 'black', gui = 'italic,bold' } },
        },
        lualine_b = {
          {
            'filename',
            path = 0,
          },
        },
      },

      tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = "ibl",
    opts = {
      indent = { char = '┊' },
      -- Underlining of scope
      scope = {
        enabled = false,
      },
    },
  },
}
