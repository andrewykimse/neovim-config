return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
    {
      "<leader>cF",
      function()
        local overseer = require("overseer")
        local task = overseer.new_task({
          cmd = { "bash" },
          args = { "-c", "find . -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' | xargs clang-format -i" },
          name = "clang-format (project)",
        })
        task:subscribe("on_complete", function(_, status)
          if status == "SUCCESS" then
            vim.notify("Project formatted", vim.log.levels.INFO)
            -- reload open buffers to pick up changes
            vim.cmd("checktime")
          else
            vim.notify("Project format failed", vim.log.levels.ERROR)
          end
        end)
        task:start()
      end,
      desc = "Format project (C/C++)",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettier" },
      markdown = { "prettier" },
      bash = { "shfmt" },
      sh = { "shfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 500,
    },
  },
}
