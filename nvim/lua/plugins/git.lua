return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "dlyongemallo/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>gg", function() require("neogit").open() end,             desc = "Neogit status" },
            { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit commit" },
            { "<leader>gl", function() require("neogit").open({ "log" }) end,    desc = "Neogit log" },
            { "<leader>gP", function() require("neogit").open({ "push" }) end,   desc = "Neogit push" },
        },
        opts = {
            integrations = {
                telescope = true,
                diffview = true,
            },
        },
    },

    {
        "dlyongemallo/diffview.nvim",
        keys = {
            { "<leader>gD", "<cmd>DiffviewOpen<cr>",             desc = "Diffview open" },
            { "<leader>gM", "<cmd>DiffviewOpen master<cr>",      desc = "Diffview vs master" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
        },
        config = true,
    },
}
