return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						-- ["af"] = "@function.outer",
						-- ["if"] = "@function.inner",
						["ap"] = "@parameter.outer",
						["ip"] = "@parameter.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
					},
					goto_next_end = {
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
					},
					goto_previous_start = {
						["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
					},
				},
			})

			vim.keymap.set({ "x", "o", "n" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o", "n" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Enable treesitter highlighting and disable regex syntax
					pcall(vim.treesitter.start)
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
		config = function()
			local ensure_installed = {
				"bash",
				"comment",
				"css",
				"dockerfile",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"query",
				"sql",
				"typescript",
				"vim",
				"yaml",
			}
			local alreadyInstalled = require("nvim-treesitter.config").get_installed()
			local parsersToInstall = vim.iter(ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()

			require("nvim-treesitter").install(parsersToInstall)
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	opts = {},
	-- },
	-- {
	-- 	"davidmh/mdx.nvim",
	-- 	-- event = "BufEnter *.mdx",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- },
}
