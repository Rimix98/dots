-- ~/.config/nvim/colors/rice.lua
-- Gray interface, one purple accent, muted colors for code.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "rice"

-- true: background taken from terminal (kitty), false: own #1c1c1c
local transparent = true

local c = {
  bg        = "#1c1c1c",
  bg_dark   = "#141414",
  bg_light  = "#222222",
  bg_sel    = "#2c2c2c",
  border    = "#333333",
  gray      = "#4a4a4a",
  comment   = "#6a6a6a",
  subtle    = "#919191",
  fg        = "#d0d0d0",
  white     = "#ffffff",
  accent    = "#9f78bd",
  accent_lt = "#c9a5f0",
  accent_dk = "#3d2552",
  red       = "#a05050",
  red_br    = "#c06666",
  green     = "#7a9a6a",
  yellow    = "#b0a070",
  blue      = "#7aa2c4",
  magenta   = "#9a7aa0",
  cyan      = "#6a9a9a",
}

local bg = transparent and "NONE" or c.bg

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Interface
hl("Normal",       { fg = c.fg, bg = bg })
hl("NormalNC",     { fg = c.fg, bg = bg })
hl("NormalFloat",  { fg = c.fg, bg = c.bg_dark })
hl("FloatBorder",  { fg = c.accent, bg = c.bg_dark })
hl("FloatTitle",   { fg = c.accent_lt, bg = c.bg_dark, bold = true })
hl("Cursor",       { fg = c.bg, bg = c.accent })
hl("lCursor",      { fg = c.bg, bg = c.accent })
hl("TermCursor",   { fg = c.bg, bg = c.accent })
hl("CursorLine",   { bg = c.bg_light })
hl("CursorColumn", { bg = c.bg_light })
hl("ColorColumn",  { bg = c.bg_light })
hl("LineNr",       { fg = c.gray })
hl("CursorLineNr", { fg = c.accent, bold = true })
hl("SignColumn",   { fg = c.gray, bg = bg })
hl("FoldColumn",   { fg = c.gray, bg = bg })
hl("Folded",       { fg = c.subtle, bg = c.bg_light })
hl("EndOfBuffer",  { fg = c.bg })
hl("NonText",      { fg = c.gray })
hl("Whitespace",   { fg = c.border })
hl("SpecialKey",   { fg = c.gray })
hl("Conceal",      { fg = c.subtle })
hl("Directory",    { fg = c.accent_lt })
hl("Title",        { fg = c.accent_lt, bold = true })
hl("MatchParen",   { fg = c.white, bg = c.accent_dk, bold = true })
hl("Visual",       { bg = c.accent_dk })
hl("VisualNOS",    { bg = c.accent_dk })
hl("Search",       { fg = c.bg, bg = c.accent_lt })
hl("CurSearch",    { fg = c.bg, bg = c.accent, bold = true })
hl("IncSearch",    { fg = c.bg, bg = c.accent, bold = true })
hl("Substitute",   { fg = c.bg, bg = c.red_br })
hl("WinSeparator", { fg = c.border })
hl("VertSplit",    { fg = c.border })

hl("StatusLine",   { fg = c.fg, bg = c.bg_light })
hl("StatusLineNC", { fg = c.comment, bg = c.bg_dark })
hl("TabLine",      { fg = c.comment, bg = c.bg_dark })
hl("TabLineFill",  { bg = c.bg_dark })
hl("TabLineSel",   { fg = c.white, bg = c.bg_light, bold = true })
hl("WinBar",       { fg = c.subtle, bg = bg })
hl("WinBarNC",     { fg = c.comment, bg = bg })

hl("Pmenu",        { fg = c.fg, bg = c.bg_dark })
hl("PmenuSel",     { fg = c.bg, bg = c.accent })
hl("PmenuSbar",    { bg = c.bg_light })
hl("PmenuThumb",   { bg = c.gray })

hl("MsgArea",      { fg = c.fg })
hl("ModeMsg",      { fg = c.accent_lt, bold = true })
hl("MoreMsg",      { fg = c.green })
hl("Question",     { fg = c.accent_lt })
hl("ErrorMsg",     { fg = c.red_br, bold = true })
hl("WarningMsg",   { fg = c.yellow })

-- Syntax
hl("Comment",      { fg = c.comment, italic = true })
hl("Constant",     { fg = c.yellow })
hl("String",       { fg = c.green })
hl("Character",    { fg = c.green })
hl("Number",       { fg = c.yellow })
hl("Boolean",      { fg = c.yellow })
hl("Float",        { fg = c.yellow })
hl("Identifier",   { fg = c.fg })
hl("Function",     { fg = c.blue })
hl("Statement",    { fg = c.accent })
hl("Conditional",  { fg = c.accent })
hl("Repeat",       { fg = c.accent })
hl("Label",        { fg = c.accent })
hl("Operator",     { fg = c.subtle })
hl("Keyword",      { fg = c.accent })
hl("Exception",    { fg = c.accent })
hl("PreProc",      { fg = c.magenta })
hl("Include",      { fg = c.magenta })
hl("Define",       { fg = c.magenta })
hl("Macro",        { fg = c.magenta })
hl("Type",         { fg = c.cyan })
hl("StorageClass", { fg = c.accent })
hl("Structure",    { fg = c.cyan })
hl("Special",      { fg = c.accent_lt })
hl("SpecialChar",  { fg = c.accent_lt })
hl("Delimiter",    { fg = c.subtle })
hl("Tag",          { fg = c.accent_lt })
hl("Todo",         { fg = c.bg, bg = c.yellow, bold = true })
hl("Underlined",   { fg = c.accent_lt, underline = true })
hl("Error",        { fg = c.red_br })

-- Treesitter, where default links do not give the desired look
hl("@variable",           { fg = c.fg })
hl("@variable.builtin",   { fg = c.accent_lt })
hl("@variable.parameter", { fg = c.fg, italic = true })
hl("@property",           { fg = c.fg })
hl("@constructor",        { fg = c.cyan })
hl("@punctuation",        { fg = c.subtle })
hl("@tag",                { fg = c.accent })
hl("@tag.attribute",      { fg = c.cyan })
hl("@tag.delimiter",      { fg = c.subtle })

-- Diagnostics and LSP
hl("DiagnosticError", { fg = c.red_br })
hl("DiagnosticWarn",  { fg = c.yellow })
hl("DiagnosticInfo",  { fg = c.blue })
hl("DiagnosticHint",  { fg = c.cyan })
hl("DiagnosticOk",    { fg = c.green })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red_br })
hl("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.yellow })
hl("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.blue })
hl("DiagnosticUnderlineHint",  { undercurl = true, sp = c.cyan })
hl("LspReferenceText",  { bg = c.bg_sel })
hl("LspReferenceRead",  { bg = c.bg_sel })
hl("LspReferenceWrite", { bg = c.bg_sel })

-- Diff and git
hl("DiffAdd",    { bg = "#22301f" })
hl("DiffChange", { bg = "#2a2a1f" })
hl("DiffDelete", { fg = c.red, bg = "#301f1f" })
hl("DiffText",   { bg = "#3a3a24" })
hl("Added",      { fg = c.green })
hl("Changed",    { fg = c.yellow })
hl("Removed",    { fg = c.red_br })
hl("GitSignsAdd",    { fg = c.green })
hl("GitSignsChange", { fg = c.yellow })
hl("GitSignsDelete", { fg = c.red_br })

-- Spell checking
hl("SpellBad",   { undercurl = true, sp = c.red_br })
hl("SpellCap",   { undercurl = true, sp = c.yellow })
hl("SpellLocal", { undercurl = true, sp = c.blue })
hl("SpellRare",  { undercurl = true, sp = c.cyan })
