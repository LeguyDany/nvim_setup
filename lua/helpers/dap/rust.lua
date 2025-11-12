local M = {}

function M.rust_setup(dap)
  ---@diagnostic disable-next-line: undefined-field
  local codelldb_path = vim.fn.expand("$MASON/packages/codelldb/extension/adapter/codelldb")

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
        local name =
          vim.fn.system("cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].name'"):gsub("%s+$", "")
        return vim.fn.getcwd() .. "/target/debug/" .. name
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }
end

return M
