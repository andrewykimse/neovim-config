return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {},
    config = function()
      require("nvim-tree").setup({
        view = { width = 70 },
        renderer = { icons = { show = { file = true, folder = true } } },
      })
    end,
  },
}

