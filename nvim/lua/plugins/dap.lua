return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      { "<F5>", ":lua require('dap').continue()<CR>", desc = "Start/Continue Debugging" },
      { "<F10>", ":lua require('dap').step_over()<CR>", desc = "Step Over" },
      { "<F11>", ":lua require('dap').step_into()<CR>", desc = "Step Into" },
      { "<F12>", ":lua require('dap').step_out()<CR>", desc = "Step Out" },
      { "<Leader>b", ":lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle Breakpoint" },
      { "<Leader>B", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", desc = "Set Conditional Breakpoint" },
      { "<Leader>dr", ":lua require('dap').repl.open()<CR>", desc = "Open REPL" },
      { "<Leader>dl", ":lua require('dap').run_last()<CR>", desc = "Run Last Debug Session" },
    },
    config = function()
      local dap = require("dap")

      -- Debug Configurations for C++ (and C)
      dap.configurations.cpp = {
        {
          name = "Launch Program",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {}, -- Pass arguments here if needed
          runInTerminal = false,
        },
      }

      -- Use the same configuration for C
      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
