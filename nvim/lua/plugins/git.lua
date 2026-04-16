return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit status" },
      { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit commit" },
      { "<leader>gl", function() require("neogit").open({ "log" }) end, desc = "Neogit log" },
      { "<leader>gP", function() require("neogit").open({ "push" }) end, desc = "Neogit push" },
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
    config = true,
  },
}
