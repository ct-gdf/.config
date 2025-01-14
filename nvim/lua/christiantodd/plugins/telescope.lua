return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	event = { "VeryLazy" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local trouble = require("trouble.sources.telescope")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-tt>"] = trouble.open,
					},
					n = {
						["<C-tt>"] = trouble.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("harpoon")

		vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find string in git project" })
		vim.keymap.set(
			"n",
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			{ desc = "Find string under cursor in cwd" }
		)
		vim.keymap.set("n", "<leader>xx", function()
			require("trouble").toggle()
		end)

		vim.keymap.set("n", "<leader>xw", function()
			require("trouble").toggle("workspace_diagnostics")
		end)

		vim.keymap.set("n", "<leader>xd", function()
			require("trouble").toggle("document_diagnostics")
		end)

		vim.keymap.set("n", "<leader>xq", function()
			require("trouble").toggle("quickfix")
		end)

		vim.keymap.set("n", "<leader>xl", function()
			require("trouble").toggle("loclist")
		end)
	end,
}
