---@diagnostic disable: missing-fields
return {
	{
		-- The servers implementing LSP solves other things:
		-- Compilation errors, warnings jump to def, symbol highlighting
		-- etc.
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				opts = {},
			},

			-- Additional lua configuration, makes nvim stuff amazing!
			-- Annotations for nvim API functions
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},

			-- Autocompletion with blink (passes on capabilities)
			{
				"saghen/blink.cmp",
				enabled = true,
				-- stable at time of grab: 0.8.2
				version = "*",
				dependencies = { "rafamadriz/friendly-snippets" },
				opts = {
					keymap = { preset = "default" },
					appearance = {
						use_nvim_cmp_as_default = true,
						nerd_font_variant = "mono",
					},
					sources = {
						-- lazydev in default added for folke/lazydev
						default = { "lsp", "path", "snippets", "buffer", "lazydev" },
						providers = {
							lazydev = {
								name = "LazyDev",
								module = "lazydev.integrations.blink",
								-- make lazydev completions top priority (see `:h blink.cmp`)
								score_offset = 100,
							},
						},
					},
					signature = { enabled = true },
				},
				opts_extend = { "sources.default" },
			},

			-- Navigation buddy
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					-- "neovim/nvim-lspconfig",
					{
						"SmiteshP/nvim-navic",
						opts = { lsp = { auto_attach = true } },
					},
					"MunifTanjim/nui.nvim",
					"nvim-lualine/lualine.nvim", -- We output the navic results in lualine
				},
				opts = { lsp = { auto_attach = true } },
				config = function()
					local navic = require("nvim-navic")
					require("lualine").setup({
						sections = {
							lualine_c = {
								{
									function()
										return navic.get_location()
									end,
									cond = function()
										return navic.is_available()
									end,
									color = { fg = "#49ba67", bg = "black" },
								},
							},
						},
					})
				end,
			},
		},

		config = function()
			-- Get default client capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Add additional completion capabilities if exists
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

			-- Setup Zig with lspconfig manually because we can't use Mason on nightly builds!
			-- We have to build ZLS from source, or get binary from master, set to PATH
			-- and let lspconfig grab it here manually instead of letting 'mason' install it for us
			-- https://zigtools.org/zls/editors/vim/nvim-lspconfig/
			-- vim.lsp.config.zls.setup({
			-- 	on_attach = on_attach,
			-- 	-- omit the following line if `zls` is in your PATH
			-- 	--cmd = { '/path/to/zls_executable' },
			-- 	-- Further information on how to configure ZLS:
			-- 	-- https://zigtools.org/zls/configure/
			-- 	settings = {
			-- 		zls = {
			-- 			-- Whether to enable build-on-save diagnostics
			-- 			--
			-- 			-- Further information about build-on save:
			-- 			-- https://zigtools.org/zls/guides/build-on-save/
			-- 			enable_build_on_save = true,
			--
			-- 			-- omit the following line if `zig` is in your PATH
			-- 			--zig_exe_path = '/path/to/zig_executable'
			-- 		},
			-- 	},
			-- })

			-- local on_attach = function(client, bufnr) end

			vim.lsp.config['lua_ls'] = {
				capabilities = capabilities,
				-- Command and arguments to start the server.
				cmd = { 'lua-language-server' },
				-- Filetypes to automatically attach to.
				filetypes = { 'lua' },
				-- Sets the "workspace" to the directory where any of these files is found.
				-- Files that share a root directory will reuse the LSP server connection.
				-- Nested lists indicate equal priority, see |vim.lsp.Config|.
				root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
				-- Specific settings to send to the server. The schema is server-defined.
				-- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
				settings = {
					Lua = {
						runtime = {
							version = 'LuaJIT',
						},
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = {
							disable = { "missing-fields", },
							globals = { "vim" }, -- Ensure that language server knows that 'vim' is provided
						},
					}
				},
				-- on_attach = on_attach,
			}

			vim.lsp.config['clangd'] = {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--header-insertion=never",
				},
				-- on_attach = on_attach,
			}

			vim.lsp.config['ols'] = {
				capabilities = capabilities,
				cmd = { 'ols' },
				filetypes = { 'odin' },
				root_markers = { 'ols.json', '.git' },
			}

			vim.lsp.enable('lua_ls')
			vim.lsp.enable('clangd')
			vim.lsp.enable('ols')

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
			vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
			vim.keymap.set("n", "<C-j>", vim.lsp.buf.hover, { desc = "Hover Documentation - Look at method" })
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation - Peek arguments" })

			-- :Format
			vim.api.nvim_buf_create_user_command(0, "Format", function()
				vim.lsp.buf.format()
				-- trigger custom events with pattern
				vim.api.nvim_exec_autocmds("User", { pattern = "FormatPost" })
			end, { desc = "Format current buffer with LSP" })
		end,
	},

	{
		-- Tresitter and LSP have overlaps, they are both syntax parsers
		-- Treesitter for highlighting code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
		},
	},

	{
		-- Highlighting for GLSL file extensions
		"tikhomirov/vim-glsl",
		enabled = true,
	},
}
