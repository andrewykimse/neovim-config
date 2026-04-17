return {
  "Zeioth/compiler.nvim",
  dependencies = { "stevearc/overseer.nvim" },
  cmd = { "CompilerOpen", "CompilerRedo", "CompilerStop" },
  keys = {
    { "<leader>cc", "<cmd>CompilerOpen<cr>", desc = "Compiler open" },
    { "<leader>cr", "<cmd>CompilerRedo<cr>", desc = "Compiler redo" },
    { "<leader>co", "<cmd>CompilerStop<cr>", desc = "Compiler stop" },
  },
  opts = {},
}
