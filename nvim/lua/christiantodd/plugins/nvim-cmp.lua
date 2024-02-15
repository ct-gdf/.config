return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
		"windwp/nvim-autopairs",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		require("nvim-autopairs").setup()

		-- Integrate nvim-autopairs with cmp
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-c>"] = cmp.mapping.abort(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-u>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete({}),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "luasnip", max_item_count = 3 },
				{ name = "nvim_lsp" },
				{ name = "buffer", max_item_count = 5 },
				{ name = "path", max_item_count = 4 },
			}),
			competion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			formatting = {
				expandable_indicator = true,
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
}
