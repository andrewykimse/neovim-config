return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    user_default_options = {
      css = true,
      tailwind = false,
      names = false,
    },
    filetypes = { "*" },
  },
}
