return {
  -- Your other plugins here...

  {
    "anuvyath/nvim-smart-input",
    config = function()
      require("smart-input").setup({
        -- Configuration options for nvim-smart-input
        -- Example:
        autoclose = true,
        autoindent = true,
      })
    end,
  },

  -- More plugins...
}
