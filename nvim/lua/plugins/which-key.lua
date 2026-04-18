return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>x", group = "diagnostics" },
      { "<leader>d", group = "debug" },
      { "<leader>c", group = "claude" },
      { "<leader>l", group = "lsp" },
      { "<leader>b", group = "build" },
      { "<leader>y", group = "yank" },
      { "<leader>g", group = "git" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
