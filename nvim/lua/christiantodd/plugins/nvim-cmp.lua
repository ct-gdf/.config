return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
		"saadparwaiz1/cmp_luasnip",
		"windwp/nvim-autopairs",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local lspkind = require("lspkind")
		local ls = require("luasnip")
		local snippet, i, t, c = ls.s, ls.insert_node, ls.text_node, ls.choice_node
		local fmt = require("luasnip.extras.fmt").fmt
		local rep = require("luasnip.extras").rep
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		ls.config.set_config = {
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		}

		require("nvim-autopairs").setup()

		-- Integrate nvim-autopairs with cmp
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		cmp.setup({
			snippet = {
				expand = function(args)
					ls.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don't need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if ls.expand_or_locally_jumpable() then
						ls.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if ls.locally_jumpable(-1) then
						ls.jump(-1)
					end
				end, { "i", "s" }),
			}),

			sources = cmp.config.sources({
				{ name = "luasnip", max_item_count = 3 },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "buffer", max_item_count = 5 },
				{ name = "path", max_item_count = 4 },
			}),
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			formatting = {
				expandable_indicator = true,
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})

		-- Reload the snippets
		vim.keymap.set(
			"n",
			"<leader><leader>s",
			"<cmd>source ~/.config/nvim/lua/christiantodd/plugins/nvim-cmp.lua<CR>"
		)

		local ts_tsx = {
			snippet({ trig = "iR", desc = "Import React as a namespace" }, {
				t('import * as React from "react"'),
			}),

			snippet(
				{ trig = "fun", desc = "function declaration" },
				fmt(
					[[
          function {fnName}(
            {params}: {paramsType},
          ) {{
            return {returnValue};
          }}
        ]],
					{

						fnName = i(1),
						params = i(2),
						paramsType = c(3, {
							t("unknown"),
							i(3),
						}),
						returnValue = i(4),
					}
				)
			),

			snippet(
				{ trig = "fc", desc = "Function component" },
				fmt(
					[[
          function {}(
            props: React.ComponentPropsWithoutRef,
          ) {{
            return <{} />;
          }}
        ]],
					{ i(1), i(2) }
				)
			),
			snippet(
				{ trig = "racf", desc = "Wrap a react-aria component in a facade" },
				fmt(
					[[
          import * as React from "react"
          import {{ {} as RAC{} }} from 'react-aria-components';

          export function {}(
            props: React.ComponentPropsWithoutRef<typeof RAC{}>,
          ) {{
            return <RAC{} {{...props}} />;
          }}
        ]],
					{ i(1), rep(1), rep(1), rep(1), rep(1) }
				)
			),
			snippet(
				{ trig = "dc", dec = "Documentation comment" },
				fmt(
					[[
/**
 * @{}
 */
        ]],
					{
						i(1),
					}
				)
			),
			snippet({ trig = "cn", desc = "Class name attribute" }, {
				t('className="'),
				i(1),
				t('"'),
				i(0),
			}),
			snippet({ trig = "lmt", desc = "Lingui msg tag" }, {
				t("_(msg`"),
				i(1),
				t("`)"),
				i(0),
			}),
			snippet({ trig = "cl", desc = "Print to the console" }, {
				t("console.log("),
				i(1),
				t(")"),
				i(0),
			}),
			snippet({ trig = "pp", desc = "Pretty print recursively" }, {
				t("console.dir("),
				i(1),
				t(", { depth: Infinity }"),
				t(")"),
				i(0),
			}),
			snippet(
				{ trig = "impN", desc = "Namespace import " },
				fmt(
					[[
import * as {} from "{}"
        ]],
					{
						i(1),
						i(2),
					}
				)
			),

			snippet(
				{ trig = "imp", desc = "Normal import" },
				fmt(
					[[
import {{ {} }} from "{}"
        ]],
					{
						i(1),
						i(2),
					}
				)
			),
			snippet(
				{ trig = "ReL", desc = "A Remix loader" },
				fmt(
					[[
export async function loader(args: LoaderFunctionArgs) {{
  return {returnType}
}}
      ]],
					{
						returnType = c(1, {
							t("json({ some: {ob: 'ject'} })"),
							t("defer({ some: prom })"),
						}),
					}
				)
			),
			snippet(
				{ trig = "ReA", desc = "A remix action" },
				fmt(
					[[
export async function action(args: ActionFunctionArgs) {{
	return {actionReturn};
}}
]],
					{
						actionReturn = c(1, { t("null") }),
					}
				)
			),
			snippet(
				{ trig = "ReR", desc = "A remix Route component" },
				fmt(
					[[
export default function Route() {{
	return <div>{innerTag}</div>;
}}
          ]],
					{
						innerTag = i(1),
					}
				)
			),
			snippet(
				{
					trig = "vbsP",
					desc = "Boilerplate to create a publicly available branded schema with a parser using valibot API",
				},
				fmt(
					[[
/** @private */
const {}Schema = v.brand(
  {schema},
	"{}",
);

export type {}Output = v.Output<typeof {}Schema>;

export function parse{}(x: unknown) {{
	return v.safeParse({}Schema, x);
}}
        ]],
					{
						i(1),
						rep(1),
						rep(1),
						rep(1),
						rep(1),
						rep(1),
						schema = i(2),
					}
				)
			),
			snippet(
				{ trig = "fddbug", desc = "Print the current search params in a Remix loader" },
				fmt(
					[[
Object.fromEntries(new URL(args.request.url).searchParams.entries())
]],
					{}
				)
			),
			snippet(
				{ trig = "test", desc = "A test block" },
				fmt(
					[[
test("{description}", () => {{
  {assertions}
}})

          ]],
					{
						assertions = i(1),
						description = i(2),
					}
				)
			),

			snippet({ trig = "vitIm", desc = "Imports for a vitest" }, {
				t('import { test, expect, describe } from "vitest";'),
			}),
			snippet(
				{ trig = "cTE", desc = "Create a tagged error" },
				fmt(
					[[
export class {} extends Error {{
	static readonly _tag = "{}";
}}
        ]],
					{
						i(1),
						rep(1),
					}
				)
			),

			snippet({ trig = "tsee", desc = "silence TypeScript compiler" }, t("// @ts-expect-error This is fine")),
		}

		ls.add_snippets("typescript", ts_tsx)
		ls.add_snippets("typescriptreact", ts_tsx)
	end,
}
