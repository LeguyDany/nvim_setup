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

      local js = require("helpers.dap.js")
      js.js_setup(dap)

      local rust = require("helpers.dap.rust")
      rust.rust_setup(dap)

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
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
