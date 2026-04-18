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

-- Open an interactive Claude session in a tmux pane to the left
local function tmux_claude(prompt)
  if vim.env.TMUX == nil then
    vim.notify("Not in a tmux session", vim.log.levels.ERROR)
    return
  end
  local tmpfile = vim.fn.tempname()
  vim.fn.writefile(vim.split(prompt, "\n"), tmpfile)
  local cmd = string.format(
    "tmux split-window -hb -l 80 'claude \"$(cat %s)\"; rm -f %s'",
    tmpfile,
    tmpfile
  )
  vim.fn.system(cmd)
end

-- Ask Claude about current file
vim.keymap.set("n", "<leader>ca", function()
  local file = vim.fn.expand("%:.")
  if file == "" then
    vim.notify("No file associated with buffer", vim.log.levels.WARN)
    return
  end
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  vim.ui.input({ prompt = "Ask Claude: " }, function(input)
    if input and input ~= "" then
      local prompt = string.format("%s\n\nFile: %s\n```\n%s\n```", input, file, content)
      tmux_claude(prompt)
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
      tmux_claude(prompt)
    end
  end)
end, { desc = "Ask Claude about selection" })

-- Ask Claude to review current git diff
vim.keymap.set("n", "<leader>cr", function()
  local diff = vim.fn.system("git diff HEAD")
  if vim.v.shell_error ~= 0 or diff == "" then
    vim.notify("No diff to review", vim.log.levels.INFO)
    return
  end
  tmux_claude("Review this diff for bugs and issues:\n\n" .. diff)
end, { desc = "Claude review git diff" })

-- Open a blank Claude session in a tmux pane to the right
vim.keymap.set("n", "<leader>cc", function()
  if vim.env.TMUX == nil then
    vim.notify("Not in a tmux session", vim.log.levels.ERROR)
    return
  end
  vim.fn.system("tmux split-window -h -l 80 'claude'")
end, { desc = "Open Claude session" })
