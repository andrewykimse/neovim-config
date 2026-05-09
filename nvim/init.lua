vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.autoread = true
vim.g.lazyvim_rocks = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} │%l "
require("config.options")
require("config.keymaps")
require("config.lazy") -- where you set up lazy and your plugins
