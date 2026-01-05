-- Smart window navigation (no plugin needed)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move right" })

-- Resize with HJKL + Alt
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "Resize left" })
vim.keymap.set("n", "<A-j>", "<C-w>-", { desc = "Resize down" })
vim.keymap.set("n", "<A-k>", "<C-w>+", { desc = "Resize up" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "Resize right" })
