return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",                 -- recommended by the plugin README
    build = ":TSUpdate",               -- auto-update parsers
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "json",
        "javascript",
        "typescript",
        "python",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

