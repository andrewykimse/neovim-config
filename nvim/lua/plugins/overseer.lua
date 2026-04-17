local function cmake_configure(build_dir, build_type, callback)
  local overseer = require("overseer")
  local fidget = require("fidget")
  local label = "cmake configure (" .. build_type .. ")"
  local progress = fidget.progress.handle.create({
    title = label,
    message = "Configuring...",
  })
  local task = overseer.new_task({
    cmd = { "cmake" },
    args = { "-B", build_dir, "-G", "Ninja", "-DCMAKE_BUILD_TYPE=" .. build_type },
    name = label,
  })
  task:subscribe("on_complete", function(t, status)
    if status == "SUCCESS" then
      progress.message = "Done"
      progress:finish()
      callback()
    else
      progress.message = "Failed"
      progress:finish()
      local output = t:get_bufnr()
      if output then
        local buf_lines = vim.api.nvim_buf_get_lines(output, 0, -1, false)
        local tail = table.concat(vim.list_slice(buf_lines, math.max(1, #buf_lines - 30)), "\n")
        vim.notify(label .. " failed:\n" .. tail, vim.log.levels.ERROR)
      else
        vim.notify(label .. " failed", vim.log.levels.ERROR)
      end
    end
  end)
  task:start()
end

local function ninja_build(build_dir, build_type)
  local label = "ninja -C " .. build_dir
  local function run()
    local overseer = require("overseer")
    local fidget = require("fidget")
    local progress = fidget.progress.handle.create({
      title = label,
      message = "Starting...",
      percentage = 0,
    })
    local task = overseer.new_task({
      cmd = { "ninja" },
      args = { "-C", build_dir },
      name = label,
    })
    task:subscribe("on_output_lines", function(_, lines)
      for _, line in ipairs(lines) do
        local current, total = line:match("%[(%d+)/(%d+)%]")
        if current and total then
          current, total = tonumber(current), tonumber(total)
          progress.percentage = math.floor(current / total * 100)
          progress.message = current .. "/" .. total
        end
      end
    end)
    task:subscribe("on_complete", function(t, status)
      if status == "SUCCESS" then
        progress.message = "Done"
        progress:finish()
        vim.notify(label .. " succeeded", vim.log.levels.INFO)
      else
        progress.message = "Failed"
        progress:finish()
        local output = t:get_bufnr()
        if output then
          local buf_lines = vim.api.nvim_buf_get_lines(output, 0, -1, false)
          local tail = table.concat(vim.list_slice(buf_lines, math.max(1, #buf_lines - 30)), "\n")
          vim.notify(label .. " failed:\n" .. tail, vim.log.levels.ERROR)
        else
          vim.notify(label .. " failed", vim.log.levels.ERROR)
        end
      end
    end)
    task:start()
  end

  if vim.fn.isdirectory(build_dir) == 0 then
    vim.notify("Configuring " .. build_dir .. "...", vim.log.levels.INFO)
    cmake_configure(build_dir, build_type, run)
  else
    run()
  end
end

return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle" },
  keys = {
    { "<leader>cb", function() ninja_build("build", "Release") end, desc = "Build (release)" },
    { "<leader>cB", function() ninja_build("build-debug", "Debug") end, desc = "Build (debug)" },
    { "<leader>ct", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
  },
  opts = {
    task_list = {
      direction = "bottom",
    },
    templates = { "builtin" },
  },
}
