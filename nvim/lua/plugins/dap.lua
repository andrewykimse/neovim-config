return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,                                                     desc = "Start/Continue Debugging" },
      { "<F10>",      function() require("dap").step_over() end,                                                    desc = "Step Over" },
      { "<F11>",      function() require("dap").step_into() end,                                                    desc = "Step Into" },
      { "<F12>",      function() require("dap").step_out() end,                                                     desc = "Step Out" },
      { "<Leader>b",  function() require("dap").toggle_breakpoint() end,                                            desc = "Toggle Breakpoint" },
      { "<Leader>B",  function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,         desc = "Set Conditional Breakpoint" },
      { "<Leader>dr", function() require("dap").repl.open() end,                                                    desc = "Open REPL" },
      { "<Leader>dl", function() require("dap").run_last() end,                                                     desc = "Run Last Debug Session" },
      { "<Leader>du", function() require("dapui").toggle() end,                                                     desc = "Toggle DAP UI" },
      { "<Leader>de", function() require("dapui").eval() end,                                                       desc = "Evaluate Expression",        mode = { "n", "v" } },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Adapters
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }

      -- Configurations
      dap.configurations.cpp = {
        {
          name = "Launch Program",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local input = vim.fn.input("Arguments: ")
            return vim.split(input, " ", { trimempty = true })
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Attach to Process",
          type = "gdb",
          request = "attach",
          pid = require("dap.utils").pick_process,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.4 },
              { id = "breakpoints", size = 0.2 },
              { id = "stacks",      size = 0.2 },
              { id = "watches",     size = 0.2 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Auto-open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Virtual text
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })
    end,
  },
}
