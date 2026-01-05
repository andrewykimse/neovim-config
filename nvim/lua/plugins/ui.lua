return {
  -- Dracula colorscheme (high priority, loads first)
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    name = "dracula",
    config = function()
      require("dracula").setup({
        transparent_bg = false,
        lualine_bg_color = "#44475a",
        italics = true,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },
  
  -- Statusline (auto-matches Dracula)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = { 
        theme = "dracula-nvim"  -- Dracula-specific lualine theme
      },
    },
  },
  
  -- Git signs (Dracula colors)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
    },
  },
}

