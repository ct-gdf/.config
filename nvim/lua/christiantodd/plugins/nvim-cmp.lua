return {
	{
		"saghen/blink.compat",
		version = "*",
		event = "VeryLazy",
		opts = { impersonate_nvim_cmp = true },
	},

	{

		-- Autocompletion
		"saghen/blink.cmp",
		event = "VeryLazy",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				config = function()
					-- Load custom snippets
					for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/christiantodd/snippets/*.lua", true)) do
						loadfile(ft_path)()
					end
				end,
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},

			snippets = { preset = "luasnip" },

			sources = {
				default = { "snippets", "lsp", "path", "lazydev", "buffer" },

				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
		opts_default = {
			"sources.default",
		},
	},
}
--
--
--
--
--
--
--
--
--
--

-- return {
-- 	"hrsh7th/nvim-cmp",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	dependencies = {
-- 		"L3MON4D3/LuaSnip",
-- 		"hrsh7th/cmp-buffer",
-- 		"hrsh7th/cmp-nvim-lsp",
-- 		"hrsh7th/cmp-nvim-lua",
-- 		"hrsh7th/cmp-path",
-- 		"onsails/lspkind.nvim",
-- 		"mlaursen/vim-react-snippets",
-- 		-- Necessary to bridge luasnip to nvim cmp
-- 		"saadparwaiz1/cmp_luasnip",
-- 	},
-- 	config = function()
-- 		local cmp = require("cmp")
-- 		local lspkind = require("lspkind")
-- 		local types = require("luasnip.util.types")
-- 		local ls = require("luasnip")
-- 		require("vim-react-snippets").lazy_load()
--
-- 		ls.setup({
-- 			ext_opts = {
-- 				[types.choiceNode] = {
-- 					active = { virt_text = { { "●", "Orange" } }, hl_mode = "combine" },
-- 				},
-- 			},
-- 		})
--
-- 		cmp.setup({
-- 			history = true,
-- 			update_events = { "TextChanged", "TextChangedI" },
-- 			snippet = {
-- 				expand = function(args)
-- 					ls.lsp_expand(args.body)
-- 				end,
-- 			},
-- 			window = {
-- 				completion = cmp.config.window.bordered(),
-- 				documentation = cmp.config.window.bordered(),
-- 			},
-- 			mapping = cmp.mapping.preset.insert({
-- 				-- Select the [n]ext item
-- 				["<C-n>"] = cmp.mapping.select_next_item(),
-- 				-- Select the [p]revious item
-- 				["<C-p>"] = cmp.mapping.select_prev_item(),
--
-- 				-- Accept ([y]es) the completion.
-- 				--  This will auto-import if your LSP supports it.
-- 				--  This will expand snippets if the LSP sent a snippet.
-- 				["<C-y>"] = cmp.mapping.confirm({ select = true }),
--
-- 				-- Manually trigger a completion from nvim-cmp.
-- 				--  Generally you don't need this, because nvim-cmp will display
-- 				--  completions whenever it has completion options available.
-- 				["<C-Space>"] = cmp.mapping.complete({}),
--
-- 				-- Think of <c-l> as moving to the right of your snippet expansion.
-- 				--  So if you have a snippet that's like:
-- 				--  function $name($args)
-- 				--    $body
-- 				--  end
-- 				--
-- 				-- <c-l> will move you to the right of each of the expansion locations.
-- 				-- <c-h> is similar, except moving you backwards.
-- 				["<C-l>"] = cmp.mapping(function()
-- 					if ls.expand_or_locally_jumpable() then
-- 						ls.expand_or_jump()
-- 					elseif ls.choice_active() then
-- 						ls.change_choice(1)
-- 					end
-- 				end, { "i", "s" }),
--
-- 				["<C-h>"] = cmp.mapping(function()
-- 					if ls.locally_jumpable(-1) then
-- 						ls.jump(-1)
-- 					elseif ls.choice_active() then
-- 						ls.change_choice(-1)
-- 					end
-- 				end, { "i", "s" }),
-- 			}),
-- 			sources = cmp.config.sources({
-- 				{ name = "luasnip", max_item_count = 3 },
-- 				{ name = "nvim_lsp" },
-- 				{ name = "buffer", max_item_count = 5 },
-- 				{ name = "path", max_item_count = 4 },
-- 			}),
-- 			completion = {
-- 				completeopt = "menu,menuone,preview,noselect",
-- 			},
-- 			formatting = {
-- 				expandable_indicator = true,
-- 				format = lspkind.cmp_format({
-- 					mode = "symbol_text",
-- 					maxwidth = 50,
-- 					ellipsis_char = "...",
-- 				}),
-- 			},
-- 		})
--
-- 		-- Load each file type snippet
-- 		for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/chrstntdd/snippets/*.lua", true)) do
-- 			loadfile(ft_path)()
-- 		end
--
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader><leader>s",
-- 			"<cmd>so ~/.config/nvim/lua/chrstntdd/plugins/nvim-cmp.lua<CR><cmd>echo 'reloaded snippets'<CR>",
-- 			{ desc = "Reload snippets" }
-- 		)
-- 	end,
-- }
