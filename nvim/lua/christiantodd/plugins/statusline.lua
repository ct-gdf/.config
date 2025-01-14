return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		sections = {
			lualine_x = {},
			lualine_c = {
				-- Display the full path of the file in the buffer
				{ "filename", path = 1 },
			},
		},
	},
}
