-- Smart window navigation (handled by vim-tmux-navigator)

-- Resize with HJKL + Alt
vim.keymap.set("n", "<A-h>", "<C-w><", { desc = "Resize left" })
vim.keymap.set("n", "<A-j>", "<C-w>-", { desc = "Resize down" })
vim.keymap.set("n", "<A-k>", "<C-w>+", { desc = "Resize up" })
vim.keymap.set("n", "<A-l>", "<C-w>>", { desc = "Resize right" })

-- Buffer management
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close current buffer" })

-- Open btop in a tmux pane
vim.keymap.set("n", "<leader>t", function()
    if vim.env.TMUX == nil then
        vim.notify("Not in a tmux session", vim.log.levels.ERROR)
        return
    end
    vim.fn.system("tmux split-window -fhb -l 80 'btop'")
end, { desc = "Open btop" })

-- Copy file:line to clipboard
vim.keymap.set("n", "<leader>yp", function()
    vim.fn.setreg("+", vim.fn.expand("%:.") .. ":" .. vim.fn.line("."))
end, { desc = "Copy file:line to clipboard" })

-- Copy file:line range with content to clipboard (visual mode)
vim.keymap.set("v", "<leader>yp", function()
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

-- Open an interactive Claude session in a tmux pane
local function tmux_claude(prompt, opts)
    if vim.env.TMUX == nil then
        vim.notify("Not in a tmux session", vim.log.levels.ERROR)
        return
    end
    opts = opts or {}
    local args = {}
    local cleanup = {}
    if opts.system_prompt then
        local sp_file = vim.fn.tempname()
        vim.fn.writefile(vim.split(opts.system_prompt, "\n"), sp_file)
        table.insert(args, string.format("--system-prompt \"$(cat %s)\"", sp_file))
        table.insert(cleanup, sp_file)
    end
    if opts.skip_permissions then
        table.insert(args, "--dangerously-skip-permissions")
    end
    local prompt_file = vim.fn.tempname()
    vim.fn.writefile(vim.split(prompt, "\n"), prompt_file)
    table.insert(cleanup, prompt_file)
    local cmd = string.format(
        "tmux split-window -h -l 80 'claude %s \"$(cat %s)\"; rm -f %s'",
        table.concat(args, " "),
        prompt_file,
        table.concat(cleanup, " ")
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

-- Ask Claude to review current file
vim.keymap.set("n", "<leader>cr", function()
    local ctx = file_context()
    if not ctx then return vim.notify("No file open", vim.log.levels.WARN) end
    tmux_claude("Review this code for bugs, issues, and improvements:\n\n" .. ctx, {
        system_prompt =
        "You are an expert code reviewer. Look for bugs, logic errors, performance issues, security concerns, and readability problems. Suggest concrete improvements. Be concise and actionable.",
    })
end, { desc = "Claude: review file" })

-- Open a blank Claude session
vim.keymap.set("n", "<leader>cc", function()
    tmux_claude("")
end, { desc = "Open Claude session" })

-- Open a Claude session with dangerously-skip-permissions
vim.keymap.set("n", "<leader>cC", function()
    tmux_claude("", { skip_permissions = true })
end, { desc = "Open Claude (skip permissions)" })

-- Helper: get current file context string
local function file_context()
    local file = vim.fn.expand("%:.")
    if file == "" then return nil end
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    return string.format("File: %s\n```\n%s\n```", file, content)
end

-- Claude as test writer
vim.keymap.set("n", "<leader>cT", function()
    local ctx = file_context()
    if not ctx then return vim.notify("No file open", vim.log.levels.WARN) end
    tmux_claude("Write tests for this code:\n\n" .. ctx, {
        system_prompt =
        "You are an expert test engineer. Write thorough, well-structured tests. Cover edge cases, error paths, and happy paths. Use the testing framework already in use in the project when possible.",
    })
end, { desc = "Claude: test writer" })

-- Claude as refactorer
vim.keymap.set("n", "<leader>cR", function()
    local ctx = file_context()
    if not ctx then return vim.notify("No file open", vim.log.levels.WARN) end
    tmux_claude("Suggest refactoring improvements for this code:\n\n" .. ctx, {
        system_prompt =
        "You are an expert software engineer focused on code quality. Identify opportunities to simplify, reduce duplication, improve naming, and enhance readability. Prefer small, targeted improvements over large rewrites. Explain the rationale for each suggestion.",
    })
end, { desc = "Claude: refactorer" })

-- Claude as security auditor
vim.keymap.set("n", "<leader>cS", function()
    local ctx = file_context()
    if not ctx then return vim.notify("No file open", vim.log.levels.WARN) end
    tmux_claude("Audit this code for security vulnerabilities:\n\n" .. ctx, {
        system_prompt =
        "You are a security engineer performing a code audit. Look for injection vulnerabilities, buffer overflows, authentication/authorization issues, data exposure, race conditions, and other OWASP top 10 and CWE top 25 issues. Rate severity and suggest fixes.",
    })
end, { desc = "Claude: security audit" })

-- Claude as project-wide security auditor
vim.keymap.set("n", "<leader>cX", function()
    local tree = vim.fn.system(
        "find . -type f -not -path './.git/*' -not -path './node_modules/*' -not -path './build*/*' -not -path './.cache/*' | head -200"
    )
    local prompt = string.format(
        "Perform a security audit of this project. Examine the codebase for vulnerabilities.\n\nProject structure:\n%s",
        tree
    )
    tmux_claude(prompt, {
        system_prompt =
        "You are a security engineer performing a full project audit. Systematically examine source files for injection vulnerabilities, authentication/authorization flaws, data exposure, insecure dependencies, hardcoded secrets, race conditions, and other OWASP top 10 and CWE top 25 issues. Prioritize findings by severity (Critical/High/Medium/Low) and suggest fixes for each. Start by reading the most security-sensitive files.",
        skip_permissions = true,
    })
end, { desc = "Claude: project security audit" })

-- Claude as documenter
vim.keymap.set("n", "<leader>cD", function()
    local ctx = file_context()
    if not ctx then return vim.notify("No file open", vim.log.levels.WARN) end
    tmux_claude("Write documentation for this code:\n\n" .. ctx, {
        system_prompt =
        "You are a technical writer. Write clear, concise documentation including function/module purpose, parameters, return values, usage examples, and important caveats. Match the documentation style already used in the project.",
    })
end, { desc = "Claude: documenter" })

-- Claude as commit message crafter
vim.keymap.set("n", "<leader>cg", function()
    local diff = vim.fn.system("git diff --cached")
    if vim.v.shell_error ~= 0 or diff == "" then
        diff = vim.fn.system("git diff HEAD")
    end
    if diff == "" then
        vim.notify("No changes to describe", vim.log.levels.INFO)
        return
    end
    tmux_claude("Write a commit message for these changes:\n\n" .. diff, {
        system_prompt =
        "You are an expert at writing git commit messages. Write a concise, descriptive commit message following conventional commits style. Start with a short summary line, then add a blank line and bullet points for details if needed. Focus on why, not just what.",
    })
end, { desc = "Claude: commit message" })

-- Claude as PR description writer
vim.keymap.set("n", "<leader>cP", function()
    local base = vim.fn.system("git merge-base HEAD main"):gsub("%s+$", "")
    local diff = vim.fn.system("git diff " .. base .. "..HEAD")
    local log = vim.fn.system("git log --oneline " .. base .. "..HEAD")
    if diff == "" then
        vim.notify("No changes vs main", vim.log.levels.INFO)
        return
    end
    local prompt = string.format("Write a PR description.\n\nCommits:\n%s\n\nDiff:\n%s", log, diff)
    tmux_claude(prompt, {
        system_prompt =
        "You are an expert at writing pull request descriptions. Include a summary of changes, motivation, testing done, and any notable design decisions. Use markdown formatting. Be thorough but concise.",
    })
end, { desc = "Claude: PR description" })

-- Claude as code explainer
vim.keymap.set("n", "<leader>ce", function()
    local ctx = file_context()
    if not ctx then return vim.notify("No file open", vim.log.levels.WARN) end
    tmux_claude("Explain this code in detail:\n\n" .. ctx, {
        system_prompt =
        "You are a patient, thorough code explainer. Break down the code's logic step by step. Explain the purpose, how it works, any patterns or idioms used, and potential gotchas. Tailor your explanation assuming the reader is a competent developer who is new to this codebase.",
    })
end, { desc = "Claude: explain code" })

-- Claude as architect
vim.keymap.set("n", "<leader>cA", function()
    local tree = vim.fn.system(
        "find . -type f -not -path './.git/*' -not -path './node_modules/*' -not -path './build*/*' | head -100")
    local ctx = file_context() or ""
    local prompt = string.format("Advise on architecture.\n\nProject structure:\n%s\n\n%s", tree, ctx)
    tmux_claude(prompt, {
        system_prompt =
        "You are a senior software architect. Analyze the project structure and code to provide architectural guidance. Consider separation of concerns, modularity, scalability, and maintainability. Suggest improvements while respecting existing patterns and constraints.",
    })
end, { desc = "Claude: architect" })
