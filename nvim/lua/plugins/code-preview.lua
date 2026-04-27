return {
  "Cannon07/code-preview.nvim",
  lazy = false,
  keys = {
    { "<leader>cp", "<cmd>CodePreview<cr>", desc = "Code Preview" },
  },
  config = function()
    require("code-preview").setup({
      diff = {
        layout = "tab",       -- "tab" | "vertical" | "inline"
        show_full_file = true,
      },
    })
  end,
}
