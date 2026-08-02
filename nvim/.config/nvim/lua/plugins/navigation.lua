---@diagnostic disable: missing-fields
return
{
	-- Symbol outline / table of contents sidebar
	{
		'stevearc/aerial.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			require('aerial').setup({
				backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc' },
				layout = { min_width = 30, default_direction = 'left' },
				attach_mode = 'cursor',
			})

			require('telescope').load_extension('aerial')

			vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle<cr>', { desc = '[A]erial [T]oggle' })
			vim.keymap.set('n', '<leader>as', '<cmd>Telescope aerial<cr>', { desc = '[A]erial [S]ymbols' })
		end,
	},

	-- File editor
	{
		'stevearc/oil.nvim',
		enabled = true,
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
		config = function()
			require("oil").setup(
				{
					skip_confirm_for_simple_edits = true,
					view_options = {
						show_hidden = true,
					},
					keymaps = {
						["q"] = { "actions.close", mode = "n" },
						["<CR>"] = {
							callback = function()
								local oil = require("oil")
								local entry = oil.get_cursor_entry()
								if entry and entry.name == ".." then
									require("oil.actions").parent.callback()
								else
									oil.select()
								end
							end,
							mode = "n",
						},
					},
				})

				vim.keymap.set('n', '<Leader>fe', function() require('oil').open_float('.') end)
				vim.keymap.set('n', '<Leader>fo', function() require('oil').open_float() end)
		end,
	},

	-- Cursorline - Highlights same words nearby
	{
		'RRethy/vim-illuminate',
		enabled = true,
		config = function()
			require('illuminate').configure({
				min_count_to_highlight = 2,
			})

			vim.keymap.set('n', '<C-n>', require('illuminate').goto_next_reference, { desc = "Move to next reference" })
			vim.keymap.set('n', '<C-p>', require('illuminate').goto_prev_reference, { desc = "Move to previous reference" })

			local color = "#9c053f"
			local fg = "#20d6a6"
			local highlights = {
				IlluminatedWord = { bg = color, fg = fg },
				IlluminatedCurWord = { bg = color, fg = fg },
				IlluminatedWordText = { bg = color, fg = fg },
				IlluminatedWordRead = { bg = color, fg = fg },
				IlluminatedWordWrite = { bg = color, fg = fg },
			}
			for group, value in pairs(highlights) do
				vim.api.nvim_set_hl(0, group, value)
			end
		end,
	},

	-- Telescope (fuzzy finder, files, lsp, etc.)
	{
		-- See `:help telescope` and `:help telescope.setup()`
		'nvim-telescope/telescope.nvim',

		tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				-- Add live grep (ripgrep)
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
			{
				-- FZF algorithm as sorter (faster)
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make'
			},
		},
		config = function()
			require('telescope').setup({})
			require("telescope").load_extension("live_grep_args")
			require("telescope").load_extension("fzf")

			-- Add line number to previewlua
			-- https://github.com/nvim-telescope/telescope.nvim/issues/1186
			vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal number]]

			vim.keymap.set('n', '<leader>/', function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })


			vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
			vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
			vim.keymap.set('n', '<leader>dsa', require('telescope.builtin').lsp_document_symbols, { desc = '[D]ocument [S]ymbols [A]ll' })
			vim.keymap.set('n', '<Leader>dsf', function() require("telescope.builtin").lsp_document_symbols({ symbols = { "method", "function" } }) end, { desc = '[D]ocument [S]ymbols for [F]unctions' })
			vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set("n", "<leader>sg", require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [g]rep with args' })
			vim.keymap.set('n', '<leader>ep', function() require('telescope.builtin').find_files({cwd = vim.fn.stdpath("data") .. "/lazy"}) end, { desc = 'Search files within installed plugins' })
			vim.keymap.set('n', '<leader>en', function()require('telescope.builtin').find_files({cwd = vim.fn.stdpath("config")}) end, { desc = 'Search files within personal plugins' })

			--vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
			--vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
			--vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
			--vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
		end
	},
}
