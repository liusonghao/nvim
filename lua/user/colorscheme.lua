-- local colorscheme = "base16-solarflare"
-- local colorscheme = "solarized"
local colorscheme = "base16-solarized-dark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end
