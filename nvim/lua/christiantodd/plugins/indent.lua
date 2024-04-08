return {
	"echasnovski/mini.nvim",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local plug = require("mini.indentscope")
		plug.setup({
			delay = 16,
			symbol = "│",
			options = { try_as_border = true },
			draw = {
				delay = 0,
				animation = plug.gen_animation.none(),
			},
		})
	end,
}
