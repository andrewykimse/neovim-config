return {
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      providers = { "lsp", "treesitter", "regex" },
      delay = 200,
      filetypes_denylist = {
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
      },
    })
  end,
}
