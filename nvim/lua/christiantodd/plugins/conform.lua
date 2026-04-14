return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	config = function()
		local conform = require("conform")
		local slow_format_filetypes = {}
		local shared = { "oxfmt", "prettier", stop_after_first = true }
		conform.setup({
			formatters_by_ft = {
				javascript = shared,
				typescript = shared,
				javascriptreact = shared,
				typescriptreact = shared,
				html = shared,
				css = shared,
				json = shared,
				yaml = { "prettier" },
				markdown = { "prettier" },
				svg = shared,
				lua = { "stylua" },
				sh = { "shfmt" },
				sql = { "sql-formatter" },
			},
			format_on_save = function(bufnr)
				if slow_format_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				local function on_format(err)
					if err and err:match("timeout$") then
						slow_format_filetypes[vim.bo[bufnr].filetype] = true
					end
				end

				return { timeout_ms = 500, lsp_fallback = true }, on_format
			end,

			format_after_save = function(bufnr)
				if not slow_format_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				return { lsp_fallback = true }
			end,
		})

		local format_options = {
			lsp_fallback = true,
			async = true,
		}
		vim.keymap.set({ "n", "v" }, "<leader>pp", function()
			conform.format(format_options)
		end, { desc = "Format file" })
	end,
}
