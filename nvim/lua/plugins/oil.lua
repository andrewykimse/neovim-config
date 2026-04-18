-- Oil.nvim — file explorer that lets you edit your filesystem like a buffer.
-- Navigate directories, rename, move, copy, and delete files using familiar
-- Vim motions and operators instead of a separate file-tree UI.
-- https://github.com/stevearc/oil.nvim
--
-- Keymaps:
--   -           Open parent directory (replaces netrw-style navigation)
--   <leader>o   Open Oil in a floating window
--
-- Usage:
--   Press `-` from any buffer to navigate up into the parent directory.
--   Edit filenames inline to rename; yank/paste lines to copy/move files.
--   Write the buffer (:w) to apply all pending filesystem changes.
--   Press `-` again to continue navigating up the tree.
--
-- Caveats:
--   • default_file_explorer is false — netrw (or nvim-tree via filetree.lua)
--     remains the default when opening a directory from the command line.
--     Set to true if you want Oil to fully replace the default explorer.
--   • delete_to_trash requires a trash CLI (e.g. `trash-put` on Linux,
--     `trash` on macOS via Homebrew). Without one, deletes are permanent.
--   • show_hidden is enabled — dotfiles are always visible in Oil buffers.

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- File-type icons in the Oil buffer
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    { "<leader>o", function() require("oil").open_float() end, desc = "Oil float" },
  },
  opts = {
    default_file_explorer = false, -- Keep netrw/nvim-tree as the default directory handler
    delete_to_trash = true,        -- Move deleted files to system trash instead of rm
    skip_confirm_for_simple_edits = true, -- No confirmation for single renames/moves
    view_options = {
      show_hidden = true,          -- Show dotfiles (e.g. .gitignore, .env)
    },
    float = {
      padding = 2,                 -- Inner padding around float content (cells)
      max_width = 120,             -- Maximum float width  (columns)
      max_height = 40,             -- Maximum float height (rows)
      border = "rounded",          -- Border style (matches common UI convention)
    },
  },
}
