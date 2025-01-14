return {
	{
		"stevearc/oil.nvim",
		config = function()
			local oil = require("oil")

			oil.setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = { show_hidden = true },
			})

			vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open cwd" })
			vim.keymap.set("n", "<space>-", oil.toggle_float)
		end,
	},
}
