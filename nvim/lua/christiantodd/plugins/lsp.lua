return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry",
					},
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				tag = "v1.2.0",
				opts = {},
			},
			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		opts = {
			servers = {
				-- eslint = {
				-- 	settings = {
				-- 		useFlatConfig = true,
				-- 		experimental = {
				-- 			useFlatConfig = true,
				-- 		},
				-- 	},
				-- },
			},
			setup = {
				-- eslint = function()
				-- 	require("lazyvim.util").lsp.on_attach(function(client)
				-- 		if client.name == "eslint" then
				-- 			client.server_capabilities.documentFormattingProvider = true
				-- 		elseif client.name == "tsserver" then
				-- 			client.server_capabilities.documentFormattingProvider = false
				-- 		end
				-- 	end)
				-- end,
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("chrstntdd-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gr", "<cmd>Telescope lsp_references<CR>", "Show LSP references") -- show definition, references

					map("gD", vim.lsp.buf.declaration, "Go to declaration") -- go to declaration

					map("gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions") -- show lsp definitions

					map("gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations") -- show lsp implementations

					map("gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions") -- show lsp type definitions

					map("<leader>ca", vim.lsp.buf.code_action, "See available code actions", { "n", "v" }) -- see available code actions, in visual mode will apply to selection

					map("<leader>rn", vim.lsp.buf.rename, "Smart rename") -- smart rename

					map("<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics") -- show  diagnostics for file

					map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics") -- show diagnostics for line

					map("K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "Show documentation for what is under cursor") -- show documentation for what is under cursor

					map("<C-h>", function()
						vim.lsp.buf.signature_help({ border = "rounded" })
					end, "Show function signature", "i")

					map("<leader>rs", ":lsp restart<CR>", "Restart LSP")
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				update_in_insert = true,
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local vtsls_inlay_hints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				functionParameterTypes = { enabled = true },
				parameterNames = { enabled = "all" },
				parameterNameWhenArgumentMatchesNames = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = true },
				variableTypeWhenTypeMatchesNames = { enabled = true },
			}

			-- local base_eslint = vim.lsp.config.eslint.on_attach

			---@class LspServersConfig
			---@field mason table<string, vim.lsp.Config>
			---@field others table<string, vim.lsp.Config>
			local servers = {
				mason = {
					jsonls = {
						settings = {
							json = {
								schemas = {
									{
										fileMatch = { "package.json" },
										url = "https://json.schemastore.org/package.json",
									},
								},
							},
						},
					},
					html = {},
					typos_lsp = {},
					-- ts_ls = {
					-- 	settings = {
					-- 		maxTsServerMemory = 12288,
					-- 		completions = {
					-- 			completeFunctionCalls = true,
					-- 		},
					-- 	},
					-- 	root_dir = lspconfig.util.root_pattern("package.json"),
					-- },
					--
					-- eslint = {
					-- 	on_attach = function(client, bufnr)
					-- 		if not base_eslint then
					-- 			return
					-- 		end
					--
					-- 		base_eslint(client, bufnr)
					-- 		vim.api.nvim_create_autocmd("BufWritePre", {
					-- 			buffer = bufnr,
					-- 			command = "LspEslintFixAll",
					-- 		})
					-- 	end,
					-- },
					vtsls = {
						root_dir = lspconfig.util.root_pattern("package.json"),
						-- on_attach = function(client, buffer_number)
						-- 	require("twoslash-queries").attach(client, buffer_number)
						-- 	return on_attach(client, buffer_number)
						-- end,
						settings = {
							complete_function_calls = true,
							vtsls = {
								autoUseWorkspaceTsdk = true,
								experimental = {
									completion = {
										enableServerSideFuzzyMatch = true,
									},
								},
							},
							typescript = {
								updateImportOnFileMove = { enabled = "always" },
								suggest = {
									completeFunctionCalls = true,
								},
								tsserver = {
									maxTsServerMemory = 12288,
								},
								inlayHints = vtsls_inlay_hints,
							},
							javascript = { inlayHints = vtsls_inlay_hints },
						},
					},
					cssls = {},
					tailwindcss = {
						settings = {
							tailwindCSS = {
								experimental = {
									classRegex = {
										{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
										{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
										{ "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									},
								},
							},
						},
					},
					emmet_ls = {
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"svelte",
							"typescript",
							"javascript",
						},
					},
					lua_ls = {
						settings = { -- custom settings for lua
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									-- make language server aware of runtime files
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					},
					astro = {},
					omnisharp = {},
				},
				others = {
					ocamllsp = {
						-- use local switch's version of ocamllsp instead of using mason
						cmd = { "opam", "exec", "ocamllsp" },
						manual_install = true,
						settings = {
							codelens = { enable = true },
							inlayHints = { enable = true },
							syntaxDocumentation = { enable = true },
						},
					},

					gleam = {
						cmd = { "gleam", "lsp" },
						-- filetypes = { "gleam" },
						manual_install = true,
						-- root_dir = lspconfig.util.root_pattern("gleam.toml", ".git"),
					},
					-- oxlint = {
					-- 	cmd = { "pnpm", "exec", "oxlint", "--lsp" },
					-- 	root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" },
					-- },
				},
			}

			local ensure_installed = vim.tbl_keys(servers.mason or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
			-- to the default language server configs as provided by nvim-lspconfig or
			-- define a custom server config that's unavailable on nvim-lspconfig.
			for server, config in pairs(vim.tbl_extend("keep", servers.mason, servers.others)) do
				if not vim.tbl_isempty(config) then
					vim.lsp.config(server, config)
				end
			end

			-- After configuring our language servers, we now enable them
			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_enable = true, -- automatically run vim.lsp.enable() for all servers that are installed via Mason
			})

			-- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
			if not vim.tbl_isempty(servers.others) then
				print("enabling servers", vim.tbl_keys(servers.others))
				vim.lsp.enable(vim.tbl_keys(servers.others))
			end
		end,
	},
}
