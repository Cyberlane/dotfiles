-- Testing: neotest, xcodebuild
return {
  -- Swift / XCTest via xcodebuild.nvim
  {
    "wojciech-kulik/xcodebuild.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      show_build_progress_bar = true,
      auto_save = true,
      restore_on_start = true,
      commands = {
        build_project = "<leader>xb",
        build_and_run = "<leader>xr",
        build_for_testing = "<leader>xB",
        run_tests = "<leader>xt",
        run_failing_tests = "<leader>xT",
        select_scheme = "<leader>xs",
        select_device = "<leader>xd",
        show_logs = "<leader>xl",
      },
    },
  },

  -- Test runner
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-go",
      "wojciech-kulik/xcodebuild.nvim",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = function()
              local file = vim.fn.expand("%:p")
              if string.find(file, "/packages/") then
                return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
              end
              return vim.fn.getcwd() .. "/jest.config.ts"
            end,
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-vitest"),
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s" },
          }),
          require("xcodebuild.integrations.quick"),
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        output = {
          open_on_run = true,
        },
        quickfix = {
          open = function()
            require("trouble").open({ mode = "quickfix", focus = false })
          end,
        },
      }
    end,
  },
}