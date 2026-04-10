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
          dapui.toggle({ layout = 2 })
        end,
        mode = "n",
        desc = "Toggle DAP UI",
      },
      {
        "<leader>da",
        function()
          require("helpers.dap.rust").toggle_auto_reattach()
        end,
        mode = "n",
        desc = "Toggle DAP auto-reattach",
      },
      {
        "<leader>ds",
        function()
          require("helpers.dap.rust").stop_reattach()
        end,
        mode = "n",
        desc = "Stop DAP auto-reattach",
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      ---@diagnostic disable-next-line: missing-fields
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.05 },
              { id = "console", size = 0.95 },
            },
            size = 0.4,
            position = "bottom",
          },
        },
      })

      local js = require("helpers.dap.js")
      js.js_setup(dap)

      local rust = require("helpers.dap.rust")
      rust.rust_setup(dap)

      dap.listeners.before.event_terminated["dapui_config"] = function()
        if rust.state.enabled then
          rust.start_reattach_poll()
        else
          dapui.close()
        end
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        if rust.state.enabled then
          rust.start_reattach_poll()
        else
          dapui.close()
        end
      end
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
