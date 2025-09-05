local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local snippet = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

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
	snippet(
		{
			trig = "caps",
			desc = "Remix loader/action capabilities",
		},
		fmt(
			[[const capabilities = {{
  logger: args.context.logger,
  $yerba: args.context.$yerba,
}}]],
			{}
		)
	),
}

ls.add_snippets("typescript", ts_tsx)
ls.add_snippets("typescriptreact", ts_tsx)
