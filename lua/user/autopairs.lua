-- Setup nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
	return
end

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
	fast_wrap = {
		map = "<M-e>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "PmenuSel",
		highlight_grey = "LineNr",
	},
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")

npairs.add_rule(Rule("\\lvert", "\\rvert", "tex"))


local cond = require('nvim-autopairs.conds')

require('nvim-autopairs').setup({
  ignored_next_char = "[\\%w]"  
})


require('nvim-autopairs').remove_rule('`') -- remove rule (
require('nvim-autopairs').remove_rule('"') -- remove rule (
require('nvim-autopairs').remove_rule("'") -- remove rule (

















-- npairs.add_rule(Rule("$", "$", "tex"))

-- npairs.add_rule(Rule("\\lVert", "\\rVert" , "tex"))
-- npairs.add_rlue(Rule("\\bigl(", "\\bigr)" , "tex"))
-- npairs.add_rlue(Rule("\\Bigl(", "\\Bigr)" , "tex"))
-- npairs.add_rlue(Rule("\\biggl(", "\\biggr)" , "tex"))
-- npairs.add_rlue(Rule("\\Biggl(", "\\Biggr)" , "tex"))
-- npairs.add_rlue(Rule("\\bigl[", "\\bigr]" , "tex"))
-- npairs.add_rlue(Rule("\\Bigl[", "\\Bigr]" , "tex"))
-- npairs.add_rlue(Rule("\\biggl[", "\\biggr]" , "tex"))
-- npairs.add_rlue(Rule("\\Biggl[", "\\Biggr]" , "tex"))
-- npairs.add_rlue(Rule("\\bigl\\{", "\\bigr\\}" , "tex"))
-- npairs.add_rlue(Rule("\\Bigr\\{", "\\Bigr\\}" , "tex"))
-- npairs.add_rlue(Rule("\\biggl\\{", "\\biggr\\}" , "tex"))
-- npairs.add_rlue(Rule("\\Biggl\\{", "\\Biggr\\}" , "tex"))
-- npairs.add_rlue(Rule("\\bigl\\lvert", "\\bigr\\rvert" , "tex"))
-- npairs.add_rlue(Rule("\\Bigl\\lvert", "\\Bigr\\rvert" , "tex"))
-- npairs.add_rlue(Rule("\\biggl\\lvert", "\\biggr\\rvert" , "tex"))
-- npairs.add_rlue(Rule("\\Biggl\\lvert", "\\Biggr\\rvert" , "tex"))
-- npairs.add_rlue(Rule("\\bigl\\lVert", "\\bigr\\rVert" , "tex"))
-- npairs.add_rlue(Rule("\\Bigl\\lVert", "\\Bigr\\rVert" , "tex"))
-- npairs.add_rlue(Rule("\\biggl\\lVert", "\\biggr\\rVert" , "tex"))
-- npairs.add_rlue(Rule("\\Biggl\\lVert", "\\Biggr\\rVert" , "tex"))











