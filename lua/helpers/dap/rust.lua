local M = {}

-- Auto-reattach state
M.state = {
  enabled = false,
  reattaching = false,
  timer = nil,
  last_pid = nil,
  process_name = nil,
}

local function resolve_binary_name()
  local output = vim.fn.system("cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].name'")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to resolve binary name from cargo metadata", vim.log.levels.ERROR)
    return nil
  end
  return output:gsub("%s+$", "")
end

local function find_pid_by_name(name, exclude_pid)
  local cmd = "pgrep -x " .. vim.fn.shellescape(name)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  for line in output:gmatch("[^\r\n]+") do
    local pid = tonumber(line)
    if pid and pid ~= exclude_pid then
      return pid
    end
  end
  return nil
end

function M.start_reattach_poll()
  if M.state.timer then
    M.state.timer:stop()
    M.state.timer:close()
    M.state.timer = nil
  end

  if not M.state.enabled then
    return
  end

  M.state.reattaching = true
  vim.notify("Waiting for new process...", vim.log.levels.INFO)

  local elapsed = 0
  local interval = 500
  local timeout = 60000

  M.state.timer = vim.uv.new_timer()
  M.state.timer:start(interval, interval, vim.schedule_wrap(function()
    if not M.state.enabled then
      M.stop_reattach()
      return
    end

    elapsed = elapsed + interval
    if elapsed >= timeout then
      vim.notify("Auto-reattach timed out after 60s", vim.log.levels.WARN)
      M.stop_reattach()
      return
    end

    local pid = find_pid_by_name(M.state.process_name, M.state.last_pid)
    if pid then
      M.state.last_pid = pid
      M.state.reattaching = false
      M.state.timer:stop()
      M.state.timer:close()
      M.state.timer = nil

      vim.notify("Reattaching to PID " .. pid .. "...", vim.log.levels.INFO)

      local dap = require("dap")
      dap.run({
        name = "Auto-reattach",
        type = "lldb",
        request = "attach",
        pid = pid,
        program = vim.fn.getcwd() .. "/target/debug/" .. M.state.process_name,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      })
    end
  end))
end

function M.toggle_auto_reattach()
  M.state.enabled = not M.state.enabled
  if M.state.enabled then
    local name = resolve_binary_name()
    if not name then
      M.state.enabled = false
      return
    end
    M.state.process_name = name
    vim.notify("Auto-reattach enabled for: " .. name, vim.log.levels.INFO)
  else
    M.stop_reattach()
    vim.notify("Auto-reattach disabled", vim.log.levels.INFO)
  end
end

function M.stop_reattach()
  M.state.enabled = false
  M.state.reattaching = false
  if M.state.timer then
    M.state.timer:stop()
    M.state.timer:close()
    M.state.timer = nil
  end
  vim.notify("Auto-reattach stopped", vim.log.levels.INFO)
end

function M.rust_setup(dap)
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"

  dap.adapters.lldb = {
    type = "server",
    port = "${port}",
    name = "rust debugger run",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
      detached = false,
    },
  }

  dap.configurations.rust = {
    {
      name = "Run debugger",
      type = "lldb",
      request = "launch",
      program = function()
        vim.notify("Building project...", vim.log.levels.INFO)
        local result = vim.fn.system("cargo build 2>&1")
        if vim.v.shell_error ~= 0 then
          vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
          return ""
        end
        vim.notify("Build succeeded", vim.log.levels.INFO)

        local name = resolve_binary_name()
        if not name then
          return ""
        end
        return vim.fn.getcwd() .. "/target/debug/" .. name
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
    {
      name = "Attach to dev server",
      type = "lldb",
      request = "attach",
      pid = function()
        local name = resolve_binary_name()
        if not name then
          return nil
        end
        M.state.process_name = name

        local pid = find_pid_by_name(name, nil)
        if not pid then
          vim.notify("No running process found for: " .. name, vim.log.levels.ERROR)
          return nil
        end

        -- Auto-enable reattach when using this config
        M.state.enabled = true
        M.state.last_pid = pid
        vim.notify("Attached to PID " .. pid .. " (auto-reattach enabled)", vim.log.levels.INFO)
        return pid
      end,
      program = function()
        local name = M.state.process_name or resolve_binary_name()
        if not name then
          return ""
        end
        return vim.fn.getcwd() .. "/target/debug/" .. name
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

return M
