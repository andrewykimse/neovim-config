return {
  "mikavilpas/yazi.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>e", "<cmd>Yazi<cr>",     desc = "Open yazi (cwd)" },
    { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open yazi (project root)" },
  },
  opts = {
    open_for_directories = false, -- keep oil/nvim-tree as directory handlers
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_border = "rounded",
    integrations = {
      grep_in_directory = function(directory)
        require("telescope.builtin").live_grep({ cwd = directory })
      end,
      grep_in_selected_files = function(selected_files)
        require("telescope.builtin").live_grep({ search_dirs = selected_files })
      end,
    },
  },
}
