vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"

-- Auto-reload buffers when files change on disk (e.g. after Claude edits)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, { command = "checktime" })
