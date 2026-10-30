-- Установка лидеров (очень пригодится для плагинов)
vim.g.mapleader = " "

-- Основные настройки
vim.opt.number = true          -- Включить номера строк
vim.opt.relativenumber = false -- Относительные номера строк
vim.opt.expandtab = true       -- Пробелы вместо табов
vim.opt.shiftwidth = 4         -- Ширина отступа
vim.opt.smartindent = true     -- Умные отступы
vim.opt.termguicolors = true   -- Поддержка 24-битного цвета
vim.cmd.colorscheme("rice")
vim.opt.mouse = "a"            -- Включить мышь
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
