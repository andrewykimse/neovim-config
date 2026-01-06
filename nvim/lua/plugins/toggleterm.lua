return {
  "akinsho/toggleterm.nvim",
  version = "*", -- Recommended, use this to pin to the latest release
  config = function()
    -- Basic configuration for toggleterm
    -- Refer to the toggleterm.nvim documentation for more options:
    -- https://github.com/akinsho/toggleterm.nvim#configuration
    require("toggleterm").setup({
      size = 20, -- The size of the terminal window.
      open_mapping = [[<c-t>]], -- The keymap to open/close the terminal.
      hide_numbers = true, -- Hide the number column in the terminal.
      shade_filetypes = {}, -- Filetypes that should be shaded.
      shade_termcolors = {}, -- Colors that should be shaded.
      persist_size = true, -- Persist the size of the terminal window.
      direction = "float", -- 'float', 'vertical', or 'horizontal'
      close_on_exit = true, -- Close the terminal when the process exits.
      -- ... more options can be found in the documentation
    })

    -- Optional: Bindings for easier navigation between windows
    -- These are example mappings, customize them as you see fit.
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-h>]], { desc = "Go to previous window" })
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-l>]], { desc = "Go to next window" })
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-j>]], { desc = "Go to lower window" })
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-k>]], { desc = "Go to upper window" })
  end,
}
