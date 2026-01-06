return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "main",
  dependencies = {
    -- LSP Lower: Base LSP configuration
    {
      "neovim/nvim-lspconfig",
      opts = {}, -- You can pass configuration options here if needed
    },
    -- Autocompletion
    {
      "hrsh7th/nvim-cmp",
      event = "BufReadPre",
      dependencies = {
        "L3MON4D3/LuaSnip", -- Snippet engine
        "saadparwaiz1/cmp_luasnip", -- Snippet completion
        "hrsh7th/cmp-nvim-lsp", -- LSP completion
        "hrsh7th/cmp-buffer", -- Buffer completion
        "hrsh7th/cmp-path", -- Path completion
      },
      opts = {}, -- You can pass configuration options here if needed
    },
    -- Snippets
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      opts = {}, -- You can pass configuration options here if needed
    },
  },
  opts = {
    -- Your LSP Zero specific configuration goes here.
    -- For example:
    // setup = {
    //   lsp = {
    //     -- Enable the recommended LSP servers.
    //     -- See `:help lsp-zero-configuration` for a full list.
    //     servers = {
    //       "clangd",
    //       "pyright",
    //       "tsserver",
    //     },
    //   },
    //   completion = {
    //     -- Enable the nvim-cmp.
    //     -- See `:help lsp-zero-completion` for a full list.
    //     autocomplete = true,
    //     hints = true,
    //   },
    // },
  },
}
