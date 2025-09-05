return {
	"echasnovski/mini.pairs",
	event = { "BufReadPre", "BufNewFile" },
	version = false,
	config = function()
		require("mini.pairs").setup()
	end,
}
