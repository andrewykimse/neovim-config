return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
      separator_style = "slant",
    },
  },
  keys = {
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick close buffer" },
    { "<S-j>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "<S-k>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
}
