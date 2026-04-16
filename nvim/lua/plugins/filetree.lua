return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    config = function()
      require("nvim-tree").setup({
        view = { width = 70 },
        renderer = { icons = { show = { file = true, folder = true } } },
      })
    end,
  },
}

