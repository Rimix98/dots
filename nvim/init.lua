-- ~/.config/nvim/init.lua
-- Neovim 0.12+: плагины ставит встроенный vim.pack, LSP встроенный.

------------------------------------------------------------------
-- Настройки
------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-tree просит отключить встроенный netrw до загрузки
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local o = vim.opt
o.termguicolors = true
o.number = true
o.cursorline = true
o.cursorlineopt = "number"   -- подсвечивать только номер текущей строки
o.signcolumn = "yes"
o.scrolloff = 6
o.wrap = false
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.undofile = true
o.updatetime = 250
o.clipboard = "unnamedplus"  -- общий буфер с системой (нужен wl-clipboard)
o.winborder = "single"       -- рамки плавающих окон
o.showmode = false           -- режим покажет строка статуса
o.completeopt = "menu,menuone,noselect,popup"

------------------------------------------------------------------
-- Тема (до плагинов, чтобы их цвета не сбросились)
------------------------------------------------------------------
vim.cmd.colorscheme("rice")

------------------------------------------------------------------
-- Плагины
------------------------------------------------------------------
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/neovim/nvim-lspconfig",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- mini.nvim: иконки, строка статуса, поиск, парные скобки
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()  -- иконки для nvim-tree
require("mini.statusline").setup()
require("mini.pick").setup()
require("mini.pairs").setup()

-- git-знаки на полях
require("gitsigns").setup()

-- Дерево файлов как в VS Code
require("nvim-tree").setup({
  view = { width = 32 },
  renderer = { group_empty = true, indent_markers = { enable = true } },
  git = { enable = true, ignore = false },
  filters = { dotfiles = false },
  update_focused_file = { enable = true },
})

-- Открывать дерево при запуске: с папкой (nvim .) и с файлом (nvim файл)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local is_dir = data.file ~= "" and vim.fn.isdirectory(data.file) == 1
    if is_dir then
      vim.cmd.cd(data.file)
    end
    require("nvim-tree.api").tree.open()
    if not is_dir and data.file ~= "" then
      vim.cmd("wincmd p")  -- вернуть курсор в файл
    end
  end,
})

-- Treesitter: парсеры ставятся асинхронно, подсветку включает сам Neovim
require("nvim-treesitter").install({
  "bash", "css", "go", "gomod", "html", "javascript", "json",
  "lua", "markdown", "markdown_inline", "typescript", "vim", "vimdoc", "vue",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)  -- тихо пропускаем языки без парсера
  end,
})

------------------------------------------------------------------
-- LSP
------------------------------------------------------------------
-- Серверы должны быть установлены в системе (см. список в сообщении)
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- TypeScript/JS и Vue. Для Vue нужны два сервера: vtsls с плагином
-- @vue/typescript-plugin и vue_ls (ts_ls вместе с vtsls не включаем).
local enabled = { "gopls", "lua_ls", "vtsls" }

local vue_bin = vim.fn.exepath("vue-language-server")
if vue_bin ~= "" then
  -- папка пакета @vue/language-server: два уровня вверх от bin/*.js
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

    -- автодополнение от сервера
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    local function bmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    bmap("gd", vim.lsp.buf.definition, "К определению")
    bmap("<leader>d", vim.diagnostic.open_float, "Ошибка под курсором")
    bmap("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Форматировать")
  end,
})

------------------------------------------------------------------
-- Клавиши
------------------------------------------------------------------
local map = vim.keymap.set
map("n", "<C-b>",     "<cmd>NvimTreeToggle<cr>",   { desc = "Дерево файлов" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>",   { desc = "Дерево файлов" })
map("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Показать файл в дереве" })
map("n", "<leader>f", "<cmd>Pick files<cr>",       { desc = "Файлы" })
map("n", "<leader>g", "<cmd>Pick grep_live<cr>",   { desc = "Поиск по тексту" })
map("n", "<leader>b", "<cmd>Pick buffers<cr>",     { desc = "Буферы" })
map("n", "<Esc>",     "<cmd>nohlsearch<cr>")
