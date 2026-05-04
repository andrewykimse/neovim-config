return {
  -- Dracula colorscheme (high priority, loads first)
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    name = "dracula",
    config = function()
      require("dracula").setup({
        transparent_bg = false,
        lualine_bg_color = "#44475a",
        italics = true,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },
  
  -- Statusline (auto-matches Dracula)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = { 
        theme = "dracula-nvim"  -- Dracula-specific lualine theme
      },
    },
  },
  
  -- Git signs (Dracula colors)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Previous hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gd", gs.diffthis, "Diff against index")
      end,
    },
  },

  -- Bracket pair colorization and matching
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
}

