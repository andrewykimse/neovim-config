return {
    {
        "HakonHarnes/img-clip.nvim",
        ft = { "markdown" },
        opts = {
            default = {
                dir_path = "assets/images",
                use_absolute_path = false,
                prompt_for_file_name = false,
            },
            filetypes = {
                markdown = {
                    url_encode_path = true,
                    template = "![$CURSOR]($FILE_PATH)",
                },
            },
        },
        keys = {
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
        },
    },
}
