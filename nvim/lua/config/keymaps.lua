-- Smart window navigation (handled by vim-tmux-navigator)

-- Resize with HJKL + Alt
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "Resize left" })
vim.keymap.set("n", "<A-j>", "<C-w>-", { desc = "Resize down" })
vim.keymap.set("n", "<A-k>", "<C-w>+", { desc = "Resize up" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "Resize right" })

-- Buffer management
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close current buffer" })
