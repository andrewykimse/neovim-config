return {
  "Zeioth/compiler.nvim",
  dependencies = { "stevearc/overseer.nvim" },
  cmd = { "CompilerOpen", "CompilerRedo", "CompilerStop" },
  keys = {
    { "<leader>mc", "<cmd>CompilerOpen<cr>", desc = "Compiler open" },
    { "<leader>mr", "<cmd>CompilerRedo<cr>", desc = "Compiler redo" },
    { "<leader>mo", "<cmd>CompilerStop<cr>", desc = "Compiler stop" },
  },
  opts = {},
}
