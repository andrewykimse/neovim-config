-- ~/.config/nvim/lua/plugins/dap.lua

return {
  {
    "mfussenegger/nvim-dap",
    -- This plugin depends on mason.nvim for managing debug adapters
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim", -- If you plan to use dap with LSP features
      "jay-babu/mason-nvim-dap.nvim",     -- Automatically installs debug adapters

      -- Optional: for visual feedback of debugging state
      "rcarriga/nvim-dap-virtual-text",
    },
    config = function()
      -- Import required plugins
      local dap = require("dap")
      local dap_virtual_text = require("nvim-dap-virtual-text")
      local mason_nvim_dap = require("mason-nvim-dap")

      -- 1. Setup nvim-dap-virtual-text (optional, for visual feedback)
      dap_virtual_text.setup({
        -- Optionally configure virtual text features here
        -- Example:
        -- odd_fields = { enable = true },
        -- etc.
      })

      -- 2. Configure mason-nvim-dap to install debug adapters
      -- This tells mason-nvim-dap which adapters you want to install.
      -- Common ones for C/C++ are 'codelldb' and 'gdb'.
      -- You can find a list of supported adapters in the mason-nvim-dap README.
      mason_nvim_dap.setup({
        handlers = {
          -- This is a generic handler. You can define specific handlers for each adapter.
          -- The following example configures 'codelldb' and 'gdb'
          "codelldb",
          "gdb",
          -- Add other adapters you might need, e.g.,
          -- "js", "python", "go", "rust", etc.
          -- Make sure to install the corresponding binaries via mason.nvim first!
        },
        ensure_installed = {
          "codelldb", -- C/C++/Rust debugger
          "gdb",      -- GNU Debugger
          -- Add other adapters as needed
        },
      })

      -- 3. Configure nvim-dap's debugging sessions
      -- This is where you define how to launch your debugger (e.g., GDB)
      -- and set up configurations for different projects or languages.

      -- Example configurations for C/C++ using codelldb or gdb
      -- You can define multiple configurations for different scenarios.

      -- Example using codelldb (recommended for its features and ease of use)
      -- You might need to ensure 'codelldb' is installed via mason.nvim
      -- For more detailed codelldb setup, refer to its documentation.
      dap.adapters.codelldb = {
        type = "server",
        command = {
          -- This is the path to the codelldb executable.
          -- mason.nvim usually installs it to ~/.local/share/nvim/mason/bin/codelldb
          -- You can dynamically get this path.
          vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb"),
          "--port",
          "13000", -- You can use any available port, or let it be dynamic.
        },
        -- Optional: Specify how to get the server port if it's not hardcoded
        -- port = "{{port}}",
        -- Note: Using a fixed port like 13000 is simpler for initial setup.
      }

      -- Example configuration for launching a C/C++ executable with codelldb
      dap.configurations.cpp = {
        {
          name = "Launch file", -- Name of this debug configuration
          type = "codelldb",    -- The adapter to use (must match the entry in dap.adapters)
          request = "launch",   -- 'launch' to start a new process, 'attach' to attach to an existing one
          program = function()
            -- This function will be called when you start debugging.
            -- It prompts you to enter the path to your executable.
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${fileDirname}", -- Set the working directory to the directory of the current file
          stopOnEntry = false,    -- Set to true to stop execution immediately upon starting
          args = {},              -- Command-line arguments to pass to your program
          -- Required for codelldb
          stdio = { "pipe", "pipe", "pipe" },
          externalConsole = false, -- Set to true if you want the program's output in an external terminal
          -- You can add more options here as per codelldb's documentation.
        },
        {
          name = "Attach",
          type = "codelldb",
          request = "attach",
          processId = require("dap.utils").pick_process, -- Allows you to pick a running process to attach to
        },
      }

      -- You can define configurations for other languages similarly.
      -- For example, if you have a C project:
      dap.configurations.c = dap.configurations.cpp -- Often, C and C++ use similar configurations

      -- Add any other language configurations you need here.
      -- For example:
      -- dap.configurations.python = { ... }
      -- dap.configurations.rust = { ... }

      -- 4. Set up Keybindings for nvim-dap
      -- These are essential for interacting with the debugger.
      local keymap = vim.keymap.set

      -- Debugging commands
      keymap("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      keymap("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      keymap("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      keymap("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
      keymap("n", "<F9>", dap.run_last, { desc = "Debug: Run Last" }) -- Runs the last executed command (e.g., continue, step)
      keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      keymap("n", "<leader>dR", dap.reset, { desc = "Debug: Reset debugger" })
      keymap("n", "<leader>dk", dap.clear_breakpoints, { desc = "Debug: Clear Breakpoints" })
      keymap("n", "<leader>dl", dap.list_breakpoints, { desc = "Debug: List Breakpoints" })
      keymap("n", "<leader>di", dap.up, { desc = "Debug: Go up in stack" }) -- Step up in stack frames
      keymap("n", "<leader>dj", dap.down, { desc = "Debug: Go down in stack" }) -- Step down in stack frames
      keymap("n", "<leader>dD", dap.disconnect, { desc = "Debug: Disconnect debugger" })

      -- Optional: Commands to view DAP UI elements
      -- You might need to install plugins like 'nvim-telescope/telescope.nvim' for these to work fully
      keymap("n", "<leader>de", dap.examine, { desc = "Debug: Examine variable" })
      keymap("n", "<leader>dv", dap.scopes, { desc = "Debug: Show scopes" })
      keymap("n", "<leader>dW", dap.repl_write, { desc = "Debug: REPL Write" })

      print("nvim-dap configured successfully!")
    end,
  },

  -- If you want to use mason.nvim to manage your debug adapters, you'll need this.
  -- If you already have a mason.lua plugin, you can merge this configuration into it.
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- Ensure mason is updated
    config = function()
      require("mason").setup()
    end,
  },

  -- This plugin helps mason.nvim discover and install debug adapters
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- This plugin depends on mason.nvim, so it should be loaded after mason
    -- lazy = true, -- Can be lazy loaded if not always needed immediately
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-nvim-dap").setup({
        -- You can define the same ensure_installed list here to be sure
        -- Or even omit it and let nvim-dap's config handler take care of it.
        -- For clarity, let's keep it here as well.
        ensure_installed = {
          "codelldb",
          "gdb",
          -- Add other adapters you need for other languages
        },
      })
    end,
  },

  -- Optional: nvim-dap-virtual-text for better visual feedback
  -- This plugin should be loaded after nvim-dap
  {
    "rcarriga/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
}
