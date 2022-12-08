
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
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

-- test
local function env(name) 
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
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
    alpha = "alpha", beta = "beta", delta = "delta", gam = "gamma", eps = "epsilon",
    mu = "mu", lmbd = "lambda", sig = "sigma"
}

-- brackets
brackets = {
    a = {"<", ">"}, b = {"[", "]"}, c = {"{", "}"}, m = {"|", "|"}, p = {"(", ")"}
}

-- LFG tables and matrices work
local tab = function(args, snip)
	local rows = tonumber(snip.captures[1])
    local cols = tonumber(snip.captures[2])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
        if j == 1 then
            table.insert(nodes, t{"\\midrule", ""})
        end
	end
    nodes[#nodes] = t"\\\\"
    return sn(nil, nodes)
end

-- yes this is a ripoff
local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
    local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
	end
	-- fix last node.
	nodes[#nodes] = t"\\\\"
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
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.


-- snippets go here

return {
    s({trig = "equation", dscr="equation environmennt",snippetType="autosnippet"},
    fmta(
    [[
    \begin{equation}
       \label{eq:<>}
    <>
    \end{equation}
    <>
    ]],
    { i(1,"label"),
    i(2,"equation"),
    i(0),
}
), 
{condition = line_begin}  -- set condition in the `opts` table
),

s({trig = "eqa", dscr="equation aligned environmennt"},
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
    { i(1,"label"),
    i(2,"equation"),
    i(0),
}
), 
{condition = line_begin}  -- set condition in the `opts` table
),


s({trig="new", dscr="A generic new environmennt"},
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
  {condition = line_begin}
),
-- Another take on the fraction snippet without using a regex trigger
s({trig = "fff",snippetType="autosnippet"},
  fmt(
    "\\frac{<>}{<>}",
    {
      i(1),
      i(2),
    },
{ delimiters='<>'}
  ),
  {condition=math, show_condition=math}  -- `condition` option passed in the snippet `opts` table 
  ),

  s({trig = "qqqq", snippetType="autosnippet"},
  {
      t{"\\quad "},
  },
  {condition=math}
  ),
-- Another take on the fraction snippet without using a regex trigger
s({trig = "ff"},
  fmta(
    "\\frac{<>}{<>}",
    {
      i(1),
      i(2),
    }
  ),
  {condition = in_mathzone}  -- `condition` option passed in the snippet `opts` table 
),

--添加前缀
    postfix("bf", {l("\\mathbf{" .. l.POSTFIX_MATCH .. "}")}, { condition=math }),

}


