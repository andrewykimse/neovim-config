vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.autoread = true
vim.g.lazyvim_rocks = false
vim.cmd("set number relativenumber")
require("config.options")
require("config.keymaps")
require("config.lazy") -- where you set up lazy and your plugins
