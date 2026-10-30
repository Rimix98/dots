-- ~/.config/nvim/init.lua
-- Neovim 0.12+: plugins installed by built-in vim.pack, LSP built in.

------------------------------------------------------------------
-- Settings
------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-tree wants built-in netrw disabled before loading
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local o = vim.opt
o.termguicolors = true
o.number = true
o.cursorline = true
o.cursorlineopt = "number"   -- highlight only the current line number
o.signcolumn = "yes"
o.scrolloff = 6
o.wrap = false
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.updatetime = 250
o.clipboard = "unnamedplus"  -- shared clipboard with system (requires wl-clipboard)
o.winborder = "single"       -- borders of floating windows
o.showmode = false           -- status line shows the mode
o.completeopt = "menu,menuone,noselect,popup"

------------------------------------------------------------------
-- Theme (before plugins so their colors are not reset)
------------------------------------------------------------------
vim.cmd.colorscheme("rice")

------------------------------------------------------------------
-- Plugins
------------------------------------------------------------------
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/neovim/nvim-lspconfig",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- mini.nvim: icons, statusline, picker, pairs
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()  -- icons for nvim-tree
require("mini.statusline").setup()
require("mini.pick").setup()
require("mini.pairs").setup()

-- git signs in the gutter
require("gitsigns").setup()

-- File tree like VS Code
require("nvim-tree").setup({
  view = { width = 32 },
  renderer = { group_empty = true, indent_markers = { enable = true } },
  git = { enable = true, ignore = false },
  filters = { dotfiles = false },
  update_focused_file = { enable = true },
})

-- Open the tree on startup: with a directory (nvim .) and with a file (nvim file)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local is_dir = data.file ~= "" and vim.fn.isdirectory(data.file) == 1
    if is_dir then
      vim.cmd.cd(data.file)
    end
    require("nvim-tree.api").tree.open()
    if not is_dir and data.file ~= "" then
      vim.cmd("wincmd p")  -- return cursor to the file
    end
  end,
})

-- Treesitter: parsers are installed asynchronously, highlighting is enabled by Neovim
require("nvim-treesitter").install({
  "bash", "css", "go", "gomod", "html", "javascript", "json",
  "lua", "markdown", "markdown_inline", "typescript", "vim", "vimdoc", "vue",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)  -- silently skip languages without a parser
  end,
})

------------------------------------------------------------------
-- LSP
------------------------------------------------------------------
-- Servers must be installed on the system (see the list in the message)
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- TypeScript/JS and Vue. For Vue two servers are needed: vtsls with plugin
-- @vue/typescript-plugin and vue_ls (do not enable ts_ls together with vtsls).
local enabled = { "gopls", "lua_ls", "vtsls" }

local vue_bin = vim.fn.exepath("vue-language-server")
if vue_bin ~= "" then
  -- package directory of @vue/language-server: two levels up from bin/*.js
  local vue_path = vim.fs.dirname(vim.fs.dirname(vim.fn.resolve(vue_bin)))
  vim.lsp.config("vtsls", {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_path,
              languages = { "vue" },
              configNamespace = "typescript",
            },
          },
        },
      },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  })
  table.insert(enabled, "vue_ls")
end

vim.lsp.enable(enabled)

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "single" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- completion provided by the server
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    local function bmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    bmap("gd", vim.lsp.buf.definition, "Go to definition")
    bmap("<leader>d", vim.diagnostic.open_float, "Error under cursor")
    bmap("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
  end,
})

------------------------------------------------------------------
-- Keybindings
------------------------------------------------------------------
local map = vim.keymap.set
map("n", "<C-b>",     "<cmd>NvimTreeToggle<cr>",   { desc = "File tree" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>",   { desc = "File tree" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Reveal file in tree" })
map("n", "<leader>f", "<cmd>Pick files<cr>",       { desc = "Files" })
map("n", "<leader>g", "<cmd>Pick grep_live<cr>",   { desc = "Live grep" })
map("n", "<leader>b", "<cmd>Pick buffers<cr>",     { desc = "Buffers" })
map("n", "<Esc>",     "<cmd>nohlsearch<cr>")
