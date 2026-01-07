return {
  -- Other plugins you have will go here...

  {
    "windwp/nvim-autopairs",
    -- Event to trigger loading. "BufReadPre" or "BufNewFile" is often good
    -- to have it available as soon as you open a file or create a new one.
    -- If you want it to load only when needed, you could use "InsertCharPre".
    event = "BufReadPre",
    opts = {
      -- Configuration options for nvim-autopairs go here.
      -- 'opts' is a convenient way to pass a table directly to the plugin's setup function.

      -- Enable autopairs. Defaults to true.
      autopairs_enable = true,

      -- Skip inserting pairs in specific TextYankPost events.
      -- For example, to avoid issues with text transformations:
      skip_ts = { "string" }, -- This uses Treesitter nodes. Requires Treesitter.

      -- Disable autopairs for specific filetypes.
      -- Example:
      -- disable_filetype = { "help" },

      -- Enable auto-closing of pairs.
      -- This is generally what you want. Defaults to true.
      -- If false, typing an opening character won't automatically insert its closing counterpart.
      insert_close = true,

      -- If true, automatically add a space after opening parentheses, brackets, and braces.
      -- Example: when typing '(', it inserts '()' and moves cursor to '()|'
      -- If you want '() |', set insert_space to true.
      insert_space = true,

      -- If true, automatically add a newline after opening parentheses, brackets, and braces.
      -- Example: typing '(' in a new line might insert '(\n\n)' and move the cursor inside.
      -- insert_newline = true,

      -- Enable visual mode text manipulation.
      -- This allows you to type a closing character when text is selected
      -- to surround the selection.
      -- Example: select "hello", type ")", it becomes "(hello)".
      -- visual_extra_close = true,

      -- Mappings for specific actions.
      -- nvim-autopairs provides default mappings, but you can override or add your own.
      -- For example, to map a key to change surrounding characters:
      -- mapping_keys = {
      --   ["<leader>cs"] = { "change_surround", desc = "Change surrounding characters" },
      --   ["<leader>ds"] = { "delete_surround", desc = "Delete surrounding characters" },
      --   ["<leader>ys"] = { "yank_surround", desc = "Yank and surround text" },
      -- },

      -- Enable auto-pair for specific characters.
      -- The default set is usually sufficient. You can customize it.
      -- Example of adding markdown backticks:
      pairs = {
        { "(", ")" },
        { "{", "}" },
        { "[", "]" },
        { "`", "`" }, -- For markdown inline code
        { "\"", "\"" },
        { "'", "'" },
        { "<", ">" }, -- For HTML/XML tags
      },

      -- TextYankPost event hook.
      -- This is useful for advanced integrations, e.g., skipping pairing in certain contexts.
      -- on_text_yanked = function(event)
      --   -- You can add custom logic here based on the yanked text or cursor position.
      --   -- For example, skip pairing if the yanked text is a string literal:
      --   -- local node = require("treesitter.query").get_node_text(event.node, event.buf)
      --   -- if node:match('"') or node:match("'") then
      --   --   return
      --   -- end
      -- end,

      -- Enable logging. Useful for debugging.
      -- log_level = "info", -- or "debug" for more verbose logging
    },
  },

  -- Other plugins...
}
