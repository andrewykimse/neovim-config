return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local nmap = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end
          nmap("gd", vim.lsp.buf.definition, "Go to definition")
          nmap("gr", vim.lsp.buf.references, "References")
          nmap("K", vim.lsp.buf.hover, "Hover")
          nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
          nmap("<leader>la", vim.lsp.buf.code_action, "Code action")
          nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--query-driver=/nix/store/*/bin/clang++,/nix/store/*/bin/clang",
          "--background-index",
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.enable({
        "clangd",
        "rust_analyzer",
        "gopls",
        "zls",
        "nixd",
        "ts_ls",
        "pyright",
        "lua_ls",
      })
    end,
  },
}
