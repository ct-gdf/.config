local opt = vim.opt

opt.number = true
opt.relativenumber = true

-- No need to show the mode, we have the status line
opt.showmode = false

opt.guicursor = ""

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50
opt.colorcolumn = "80"
-- Sync copy with system clipboard
opt.clipboard = "unnamed,unnamedplus"

opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blickwait600-blinkoff300-blinkon200A",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}
