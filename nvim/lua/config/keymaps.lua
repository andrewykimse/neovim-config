-- Smart window navigation (handled by vim-tmux-navigator)

-- Resize with HJKL + Alt
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "Resize left" })
vim.keymap.set("n", "<A-j>", "<C-w>-", { desc = "Resize down" })
vim.keymap.set("n", "<A-k>", "<C-w>+", { desc = "Resize up" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "Resize right" })

-- Buffer management
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close current buffer" })

-- Copy file:line to clipboard
vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%:.") .. ":" .. vim.fn.line("."))
end, { desc = "Copy file:line to clipboard" })

-- Copy file:line range with content to clipboard (visual mode)
vim.keymap.set("v", "<leader>cp", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local file = vim.fn.expand("%:.")
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local result = file .. ":" .. start_line .. "-" .. end_line .. "\n" .. table.concat(lines, "\n")
  vim.fn.setreg("+", result)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Copy file:lines with content to clipboard" })

-- Ask Claude about current file
vim.keymap.set("n", "<leader>ca", function()
  local file = vim.fn.expand("%:p")
  vim.ui.input({ prompt = "Ask Claude: " }, function(input)
    if input and input ~= "" then
      local cmd = string.format("claude -p %q < %q", input, file)
      require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "float", close_on_exit = false }):toggle()
    end
  end)
end, { desc = "Ask Claude about current file" })

-- Ask Claude about visual selection
vim.keymap.set("v", "<leader>ca", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local code = table.concat(lines, "\n")
  local file = vim.fn.expand("%:.")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  vim.ui.input({ prompt = "Ask Claude: " }, function(input)
    if input and input ~= "" then
      local prompt = string.format("%s\n\nFrom %s:%d-%d:\n```\n%s\n```", input, file, start_line, end_line, code)
      local cmd = string.format("claude -p %q", prompt)
      require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "float", close_on_exit = false }):toggle()
    end
  end)
end, { desc = "Ask Claude about selection" })
