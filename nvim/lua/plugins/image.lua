return {
    {
        "3rd/image.nvim",
        event = "VeryLazy",
        build = false,
        opts = {
            backend = "kitty", -- or "ueberzug", "chafa"
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                },
            },
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
        {
            "hmdfrds/focal.nvim",
            event = "VeryLazy",
            dependencies = {
                "3rd/image.nvim",
                build = false
            },
            opts = {},
            build = false
        },
        config = function(_, opts)
            require("image").setup(opts)
        end,
    },
}
