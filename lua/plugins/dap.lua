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

      dap.configurations.javascript = {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
        },
        {
          type = "node2",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
        },
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
      }

      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript

      -- Chrome debugger (attach to running dev server, e.g. Vite/CRA/Next)
      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = {
          require("mason-registry").get_package("chrome-debug-adapter"):get_install_path() .. "/out/src/chromeDebug.js",
        },
      }

      dap.configurations.javascriptreact = {
        {
          type = "chrome",
          request = "attach",
          name = "Attach Chrome (localhost:3000)",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222, -- Chrome remote debugging port
          webRoot = "${workspaceFolder}/src",
        },
      }

      dap.configurations.typescriptreact = dap.configurations.javascriptreact
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
