return {
  "Cannon07/code-preview.nvim",
  lazy = false,
  config = function()
    require("code-preview").setup({
      diff = {
        layout = "tab",       -- "tab" | "vertical" | "inline"
        show_full_file = true,
      },
    })
  end,
}
