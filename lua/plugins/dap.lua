local function launch_chromium()
  vim.fn.jobstart({
    "chromium",
    "--remote-debugging-port=9222",
    "--user-data-dir=/tmp/chrome-debug",
    "http://localhost:3000",
  }, { detach = true })
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>dd",
        mode = { "n" },
        desc = "Toggle breakpoint",
        function()
          require("dap").toggle_breakpoint()
        end,
      },
      {
        "<leader>dh",
        mode = { "n" },
        desc = "Continue",
        function()
          require("dap").continue()
        end,
      },
      {
        "<leader>dj",
        function()
          require("dap").step_over()
        end,
        mode = "n",
        desc = "Step over",
      },
      {
        "<leader>dk",
        function()
          require("dap").step_into()
        end,
        mode = "n",
        desc = "Step into",
      },
      {
        "<leader>dl",
        function()
          require("dap").step_out()
        end,
        mode = "n",
        desc = "Step out",
      },
      {
        "<leader>du",
        function()
          local dapui = require("dapui")
          dapui.toggle()
        end,
        mode = "n",
        desc = "Toggle DAP UI",
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      --------------------------------------------------------------------
      -- Node / Chrome configs (for React projects)
      --------------------------------------------------------------------
      -- React debugger
      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = {
          require("mason-registry").get_package("node-debug2-adapter"):get_install_path() .. "/out/src/nodeDebug.js",
        },
      }

      -- JS / TS debugger
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      local js_config = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Express.js with Nodemon",
          program = "${workspaceFolder}/node_modules/nodemon/bin/nodemon.js",
          args = { "${workspaceFolder}/server.js" }, -- Adjust path as needed
          cwd = "${workspaceFolder}",
          env = {
            NODE_ENV = "development",
          },
          runtimeExecutable = "node",
          runtimeArgs = { "--inspect" },
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          restart = true,
        },
        {
          name = "Run React dev server (npm dev)",
          type = "pwa-node",
          request = "launch",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "dev" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          name = "Run React dev server (npm start)",
          type = "pwa-node",
          request = "launch",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "start" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          name = "Launch Chromium (React dev server)",
          type = "chrome",
          request = "launch",
          runtimeExecutable = "chromium",
          runtimeArgs = { "--remote-debugging-port=9222", "--user-data-dir=/tmp/chrome-debug" },
          webRoot = "${workspaceFolder}/src",
          before = launch_chromium,
        },
        {
          name = "Attach React app to Chromium",
          type = "chrome",
          request = "attach",
          port = 9222,
          webRoot = "${workspaceFolder}/src",
        },
      }

      dap.configurations.javascript = js_config
      dap.configurations.typescript = js_config
      dap.configurations.javascriptreact = js_config
      dap.configurations.typescriptreact = js_config

      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = {
          require("mason-registry").get_package("chrome-debug-adapter"):get_install_path() .. "/out/src/chromeDebug.js",
        },
      }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "js", "chrome", "node2" },
      handlers = {},
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({
        clear_on_continue = true,
      })
    end,
  },
}
