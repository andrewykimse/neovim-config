return {
  -- ... other plugins ...
  {
    "windwp/nvim-autoclose",
    config = function()
      require("nvim-autoclose").setup({
        -- Enable auto-closing for common pairs
        auto_close = true,
        insert_close = true,
        ensure_closer = true,

        -- Add markdown pairs
        pairs = {
          { "(", ")" },
          { "{", "}" },
          { "[", "]" },
          { "`", "`" }, -- For inline code in markdown
          { '"', '"' },
          { "'", "'" },
          { "<", ">" }, -- For HTML/XML tags in markdown
        },

        -- Enable autoclose for common programming languages
        filetypes = {
          "lua", "python", "javascript", "typescript", "html", "css", "markdown", "vim", "c", "cpp", "java", "go", "ruby", "php", "sql", "json", "yaml",
        },
      })
    end,
  },

}
