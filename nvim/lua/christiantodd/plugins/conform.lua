return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local format_on_save = {
			lsp_fallback = true,
			async = false,
		}
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				svg = { "prettier" },
				lua = { "stylua" },
				bash = { "shfmt" },
			},
			format_on_save = format_on_save,
		})
		vim.keymap.set({ "n", "v" }, "<leader>pp", function()
			conform.format(format_on_save)
		end, { desc = "Format file" })
	end,
}
