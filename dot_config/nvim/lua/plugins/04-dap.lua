-- Debug Adapter Protocol
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "microsoft/vscode-js-debug",
        -- No build needed - pre-built binaries included in plugin
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = {
          debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        },
      },
      {
        "nvim-telescope/telescope-dap.nvim",
        config = function()
          require("telescope").load_extension("dap")
        end,
      },
      -- Go: delve adapter
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        opts = {
          dap_configurations = {
            {
              type = "go",
              name = "Attach remote",
              mode = "remote",
              request = "attach",
            },
          },
          delve = {
            port = "${port}",
            args = {},
          },
        },
      },
      -- Python: debugpy adapter
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy"
          require("dap-python").setup(path .. "/venv/bin/python")
        end,
      },
    },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/vsDebugServer.js",
              "${port}",
            },
          },
        }
      end

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node)",
            cwd = vim.fn.getcwd(),
            args = { "${file}" },
            sourceMaps = true,
            protocol = "inspector",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Port 9229",
            address = "localhost",
            port = 9229,
            cwd = vim.fn.getcwd(),
          },
        }
      end

      -- C#: netcoredbg adapter
      local netcoredbg_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg"
      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path .. "/netcoredbg",
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
        {
          type = "coreclr",
          name = "Attach",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },
}