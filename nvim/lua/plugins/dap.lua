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

      -- DAP run history (persists executable + args per project)
      local history_path = vim.fn.stdpath("data") .. "/dap_history.json"
      local max_history = 10
      local pending = nil

      local function load_history()
        local f = io.open(history_path, "r")
        if not f then return {} end
        local content = f:read("*a")
        f:close()
        local ok, data = pcall(vim.json.decode, content)
        return ok and data or {}
      end

      local function save_history(data)
        local f = io.open(history_path, "w")
        if not f then return end
        f:write(vim.json.encode(data))
        f:close()
      end

      local function add_to_history(program, args_str)
        local cwd = vim.fn.getcwd()
        local data = load_history()
        data[cwd] = data[cwd] or {}

        for i, entry in ipairs(data[cwd]) do
          if entry.program == program and entry.args == args_str then
            table.remove(data[cwd], i)
            break
          end
        end

        table.insert(data[cwd], 1, { program = program, args = args_str })

        while #data[cwd] > max_history do
          table.remove(data[cwd])
        end

        save_history(data)
      end

      local function select_debug_config()
        if pending then return pending end

        local cwd = vim.fn.getcwd()
        local data = load_history()
        local entries = data[cwd] or {}

        if #entries == 0 then
          local program = vim.fn.input("Path to executable: ", cwd .. "/", "file")
          if program == "" then
            pending = { program = nil, args = {} }
            return pending
          end
          local args_str = vim.fn.input("Arguments: ")
          add_to_history(program, args_str)
          pending = {
            program = program,
            args = vim.split(args_str, " ", { trimempty = true }),
          }
          return pending
        end

        local items = vim.list_extend({}, entries)
        table.insert(items, { program = nil, args = nil })

        local co = coroutine.running()
        local picked = false

        local function on_choice(choice)
          if not choice then
            pending = { program = nil, args = {} }
          elseif choice.program then
            add_to_history(choice.program, choice.args)
            pending = {
              program = choice.program,
              args = vim.split(choice.args or "", " ", { trimempty = true }),
            }
          else
            local program = vim.fn.input("Path to executable: ", cwd .. "/", "file")
            if program == "" then
              pending = { program = nil, args = {} }
            else
              local args_str = vim.fn.input("Arguments: ")
              add_to_history(program, args_str)
              pending = {
                program = program,
                args = vim.split(args_str, " ", { trimempty = true }),
              }
            end
          end
          picked = true
          if co and coroutine.status(co) == "suspended" then
            coroutine.resume(co)
          end
        end

        vim.ui.select(items, {
          prompt = "Debug configuration:",
          format_item = function(item)
            if not item.program then return "[New configuration]" end
            local display = vim.fn.fnamemodify(item.program, ":~:.")
            if item.args and item.args ~= "" then
              display = display .. "  " .. item.args
            end
            return display
          end,
        }, on_choice)

        if not picked and co then coroutine.yield() end
        return pending
      end

      local function pick_program()
        return select_debug_config().program
      end

      local function pick_args()
        return select_debug_config().args
      end

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
          program = pick_program,
          args = pick_args,
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

      -- Auto-open/close UI and reset history selection between sessions
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_terminated["dap_history"] = function() pending = nil end
      dap.listeners.before.event_exited["dap_history"] = function() pending = nil end

      -- Virtual text
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })
    end,
  },
}
