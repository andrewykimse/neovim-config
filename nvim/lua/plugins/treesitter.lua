return {
  {
    "nvim-treesitter/nvim-treesitter",
    url = "https://github.com/neovim-treesitter/nvim-treesitter",
    dependencies = { "neovim-treesitter/treesitter-parser-registry" },
    lazy = false, -- community fork does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      -- Replaces highlight.enable and indent.enable opts
      -- Uses vim filetype names (not treesitter parser names)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sh", "bash",          -- bash parser
          "c", "cpp",
          "css",
          "dockerfile",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "nix",
          "python",
          "rust",
          "toml",
          "typescriptreact",     -- tsx parser
          "typescript",
          "vim",
          "help",                -- vimdoc parser
          "yaml",
        },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
