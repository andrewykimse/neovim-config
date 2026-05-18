return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        transparent_bg = false,
        lualine_bg_color = "#44475a",
        italics = true,
      })
      vim.cmd.colorscheme("dracula")

      local dimmed_bg = "#1a1b26"

      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = dimmed_bg })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = dimmed_bg })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = dimmed_bg })
          vim.api.nvim_set_hl(0, "LineNr", { fg = "#3b3f51", bg = dimmed_bg })
        end,
      })

      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          vim.cmd.colorscheme("dracula")
        end,
      })
    end,
  },
}
