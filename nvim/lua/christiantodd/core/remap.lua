vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = false

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move [u]p and [d]own half a page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move selected lines up and down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Vistual feedback to show when lines are yanked
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>cab", function()
	local before = #vim.fn.getbufinfo({ buflisted = 1 })
	vim.cmd("%bd|e#|bd#")
	local closed = before - #vim.fn.getbufinfo({ buflisted = 1 })
	vim.notify(("Closed %d buffer%s"):format(closed, closed == 1 and "" or "s"), vim.log.levels.INFO)
end, { desc = "[C]leanup [A]ll [B]uffers and reopen current buffer. Cursor position is retained with a mark" })

vim.keymap.set(
	"n",
	"<leader>pk",
	"viw:s/\\([A-Z]\\)/\\-\\L\\1/g<CR>:s/^\\--%//<CR>",
	{ desc = "Convert word under cursor from camelCase/PascalCase to kebab-case" }
)

vim.keymap.set("n", "<leader>cpa", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	vim.notify("File path copied to clipboard!", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "[C]opy current file [P]ath [A]bsolute" })

vim.keymap.set("n", "<leader>cpr", function()
	vim.fn.setreg("+", vim.fn.expand("%:."))
	vim.notify("Relative file path copied to clipboard!", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "[C]opy current file [P]ath [R]elative" })
