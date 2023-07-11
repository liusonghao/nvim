local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

-- LaTeX Snippets
-- TODO: set options for matrix and table snippets (either auto generate or user input)
-- TODO: fix env function; make it for tikz
local postfix = require("luasnip.extras.postfix").postfix
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- env stuff
local function math()
	-- global p! functions from UltiSnips
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

-- test
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

local function tikz()
	return env("tikzpicture")
end

local function bp()
	return env("itemize") or env("enumerate")
end

-- table of greek symbols
griss = {
	alpha = "alpha",
	beta = "beta",
	delta = "delta",
	gam = "gamma",
	eps = "epsilon",
	mu = "mu",
	lmbd = "lambda",
	sig = "sigma",
}

-- brackets
brackets = {
	a = { "<", ">" },
	b = { "[", "]" },
	c = { "{", "}" },
	m = { "|", "|" },
	p = { "(", ")" },
}

-- LFG tables and matrices work
local tab = function(args, snip)
	local rows = tonumber(snip.captures[1])
	local cols = tonumber(snip.captures[2])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
		if j == 1 then
			table.insert(nodes, t({ "\\midrule", "" }))
		end
	end
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- yes this is a ripoff
local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- TODO: itemize/enumerate
--[[ rec_ls = function() ]]
--[[ 	return sn(nil, { ]]
--[[ 		c(1, { ]]
--[[ 			-- important!! Having the sn(...) as the first choice will cause infinite recursion. ]]
--[[ 			t({""}), ]]
--[[ 			-- The same dynamicNode as in the snippet (also note: self reference). ]]
--[[ 			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}), ]]
--[[ 		}), ]]
--[[ 	}); ]]
--[[ end ]]
--[[]]
-- Include this `in_mathzone` function at the start of a snippets file...
local in_mathzone = function()
	-- The `in_mathzone` function requires the VimTeX plugin
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

--visual placeholder snippets setting
local get_visual = function(args, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

-- snippets go here

return {
--tex node only
 s({trig="iid", snippetType = "autosnippet"}, -- the snip_param table is replaced by a single string holding `trig`
    { -- Table 2: snippet nodes
      t("i.i.d. "),
    }
  ),
  s({trig="...", snippetType = "autosnippet"}, -- the snip_param table is replaced by a single string holding `trig`
    { -- Table 2: snippet nodes
      t("\\ldots "),
    },
    {condition= math}
  ),


  --------------------------
	s(
		{ trig = "equation", dscr = "equation environmennt", snippetType = "autosnippet" },
		fmta(
			[[
    \begin{equation}
       \label{eq:<>}
    <>
    \end{equation}
    <>
    ]],
			{ i(1, "label"), i(2, "equation"), i(0) }
		),
		{ condition = line_begin } -- set condition in the `opts` table
	),

	-- s(
	-- 	{ trig = "eqa", dscr = "equation aligned environmennt" },
	-- 	fmta(
	-- 		[[
 --    \begin{equation}
 --       \label{eq:<>}
 --      \begin{aligned}
 --      <>
 --      \end{aligned}
 --    \end{equation}
 --    <>
 --    ]],
	-- 		{ i(1, "label"), i(2, "equation"), i(0) }
	-- 	),
	-- 	{ condition = line_begin } -- set condition in the `opts` table
	-- ),

	s(
		{ trig = "new", dscr = "A generic new environmennt" },
		fmta(
			[[
      \begin{<>}
          <>
      \end{<>}
    ]],
			{
				i(1),
				i(2),
				rep(1),
			}
		),
		{ condition = line_begin }
	),
	-- Another take on the fraction snippet without using a regex trigger
	s(
		{ trig = "exp", snippetType = "autosnippet" },
		fmta([[\exp\left\{ <> \right\}<>]], {
			i(1),
			i(0),
		}),
		{ condition = in_mathzone } -- `condition` option passed in the snippet `opts` table
	),

	s({ trig = "qqqq", snippetType = "autosnippet" }, {
		t({ "\\quad " }),
	}, { condition = math }),
	-- Another take on the fraction snippet without using a regex trigger
	

	s(
		{ trig = "jj", snippetType = "autosnippet" },
		fmta("$<>$<>", {
			i(1),
			i(2),
		})
		--{condition = in_mathzone}  -- `condition` option passed in the snippet `opts` table
	),

	s(
		{ trig = "^^", snippetType = "autosnippet", wordTrig = false },
		fmta([[^{<>}]], {
			i(1),
		}),
		{ condition = in_mathzone } -- `condition` option passed in the snippet `opts` table
	),

	s(
		{ trig = "__", name = "superscript", dscr = "superscript", wordTrig = false, snippetType = "autosnippet" },
		fmt([[_{<>}<>]], { i(1), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),

	-- s(
	-- 	{ trig = "||", name = "absolute value", dscr = "absolute value", wordTrig = false, snippetType = "autosnippet" },
	-- 	fmt([[\lvert <> \rvert <>]], { i(1), i(0) }, { delimiters = "<>" }),
	-- 	{ condition = math }
	-- ),

	

	s({ trig = "cite", wordTrig = false }, fmt([[\cite{<>} <>]], { i(1), i(0) }, { delimiters = "<>" })),
	s({ trig = "lab", wordTrig = false }, fmt([[\label{<>}<>]], { i(1), i(0) }, { delimiters = "<>" })),
	s({ trig = "cqq", snippetType = "autosnippet" }, fmt([[\cref{<>}<>]], { i(1), i(0) }, { delimiters = "<>" })),
	s(
		{ trig = "sum", snippetType = "autosnippet" },
		fmt([[\sum_{ <> }^{ <> } <>]], { i(1,"i=1"), i(2,"n"), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),
	s(
		{ trig = "hxi", snippetType = "autosnippet" },
		fmt([[ \hat{\xi}<>]], { i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),
	--添加前缀
	s(
		{ trig = "(\\?[%w]+)(bf)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\math<>{<>}<>]], {
			f(function(_, snip)
				return snip.captures[2]
			end),
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		}),
		{ condition = math }
	),

	s(
		{ trig = "(\\?[%w]+)(bb)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\math<>{<>}<>]], {
			f(function(_, snip)
				return snip.captures[2]
			end),
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		}),
		{ condition = math }
	),

	s(
		{ trig = "(\\?[%w]+)(hat)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\<>{<>}<>]], {
			f(function(_, snip)
				return snip.captures[2]
			end),
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		}),
		{ condition = math }
	),
s(
		{ trig = "(\\?[%w]+)til", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\tilde{<>}<>]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		}),
		{ condition = math }
	),
s(
		{ trig = "(\\?[%w]+)che", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\check{<>}<>]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		}),
		{ condition = math }
	),

	s(
		{ trig = "(\\?[%w]+)cal", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta([[\mathcal{<>}<>]], {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(1),
		}),
		{ condition = math }
	),
	--environmennt

s({trig="beg", name="begin env", dscr="begin/end environment"},
    fmt([[
    \begin{<>}\label{<>}
    <>
    \end{<>}]],
    {i(1), i(2), i(0), rep(1) },
    { delimiters="<>" }
    )),

s(
		{ trig = "proof"},
		fmta([[
          \begin{proof}[<><>]
          <>
          \end{proof}
          <>]],
			{
        i(1, "Proof of " ),
				i(2),
        i(3),
        i(0)
			}
		),
    {condition = line_begin}
	),


s(
		{ trig = "lemma"},
		fmta([[
          \begin{lemma}\label{lemma:<>}
          <>
          \end{lemma}
          <>]],
			{
        i(1),
				i(2),
        i(0)
			}
		),
    {condition = line_begin}
	),
	s(
		{ trig = "theorem"},
		fmta([[
          \begin{theorem}\label{theorem:<>}
          <>
          \end{theorem}
          <>]],
			{
        i(1,"label"),
				i(2,"theorem"),
        i(0)
			}
		),
    {condition = line_begin}
	),

	-- Example: italic font implementing visual selection
	s(
		{ trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command." },
		fmta("\\textit{<>}", {
			d(1, get_visual),
		})
	),


	s(
		{ trig = "||", dscr = "absolue value", snippetType = "autosnippet" },
		fmta([[\lvert <> \rvert]], {
			d(1, get_visual),
		}),
		{ condition = math }
	),
s(
		{ trig = "ang", dscr = "absolue value", snippetType = "autosnippet" },
		fmta([[\langle <> \rangle]], {
			d(1, get_visual),
		}),
		{ condition = math }
	),

s(
		{ trig = "ff", dscr = "absolue value", snippetType = "autosnippet" },
		fmta([[\frac{<>}{<>}]], {
			d(1, get_visual),
      i(2),
		}),
		{ condition = math }
	),
s(
		{ trig = "int", dscr = "integral"},
		fmta([[\int_{<>}^{<>}]], {
			d(1, get_visual),
      i(2),
		}),
		{ condition = math }
	),
s(
		{ trig = "kk", dscr = "absolue value", snippetType = "autosnippet" },
		fmta([[\{ <> \}]], {
			d(1, get_visual),
		}),
		{ condition = math }
	),
s(
		{ trig = "ll", dscr = "absolue value", snippetType = "autosnippet" },
		fmta([[\left( <> \right)]], {
			d(1, get_visual),
		}),
		{ condition = math }
	),

s(
		{ trig = "eqa", dscr = "equation aligned environmennt" },
		fmta(
			[[
    \begin{equation}
       \label{eq:<>}
      \begin{aligned}
      <>
      \end{aligned}
    \end{equation}
    <>
    ]],
			{ i(1, "label"), d(2, get_visual), i(0) }
		),
		{ condition = line_begin } -- set condition in the `opts` table
	),




s({ trig=' td', name='superscript', dscr='superscript', wordTrig=false, snippetType = 'autosnippet'},
    fmt([[^{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math }),
s({ trig=' ttd', name='superscript', dscr='superscript', wordTrig=false, snippetType = 'autosnippet'},
    fmt([[^{2}<>]],
    { i(1) },
    { delimiters='<>' }
    ), { condition=math }),
s({ trig=' tttd', name='superscript', dscr='superscript', wordTrig=false, snippetType = 'autosnippet'},
    fmt([[^{3}<>]],
    { i(1) },
    { delimiters='<>' }
    ), { condition=math }),


}
