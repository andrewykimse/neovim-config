return {
  "akinsho/toggleterm.nvim",
  version = "*", -- Recommended, use this to pin to the latest release
  config = function()
    -- Basic configuration for toggleterm
    -- Refer to the toggleterm.nvim documentation for more options:
    -- https://github.com/akinsho/toggleterm.nvim#configuration
    require("toggleterm").setup({
      size = 20,
      hide_numbers = true,
      shade_filetypes = {},
      shade_termcolors = {},
      persist_size = true,
      direction = "float",
      close_on_exit = true,
    })

    vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

    -- Optional: Bindings for easier navigation between windows
    -- These are example mappings, customize them as you see fit.
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-h>]], { desc = "Go to previous window" })
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-l>]], { desc = "Go to next window" })
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-j>]], { desc = "Go to lower window" })
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-k>]], { desc = "Go to upper window" })
  end,
}
