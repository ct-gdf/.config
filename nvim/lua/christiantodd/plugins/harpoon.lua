return {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	config = function()
		vim.keymap.set(
			"n",
			"<leader>ha",
			"<cmd>lua require('harpoon.mark').add_file()<cr>",
			{ desc = "Mark file with harpoon" }
		)
		vim.keymap.set(
			"n",
			"<leader>hui",
			"<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
			{ desc = "Toggle harpoon menu" }
		)
		vim.keymap.set(
			"n",
			"<leader>hup",
			"<cmd>lua require('harpoon.ui').nav_prev()<cr>",
			{ desc = "Navigate to previous mark" }
		)
		vim.keymap.set(
			"n",
			"<leader>hun",
			"<cmd>lua require('harpoon.ui').nav_next()<cr>",
			{ desc = "Navigate to next mark" }
		)

		local slots = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
		for _, n in ipairs(slots) do
			vim.keymap.set("n", "<leader>" .. n, "<cmd>lua require('harpoon.ui').nav_file(" .. n .. ")<cr>")
		end
	end,
}
