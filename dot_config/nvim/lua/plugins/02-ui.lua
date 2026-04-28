-- UI Plugins: lualine, bufferline, which-key, fidget
-- Note: Using snacks.notifier instead of noice (LazyVim default)
return {
  -- Better notify - replaces noice.nvim
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      dashboard = {
        enabled = true,
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }

      return {
        options = {
          theme = "nord",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_x = {
            { "encoding" },
            { "fileformat" },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "neo-tree", "lazy", "trouble", "mason" },
      }
    end,
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
      },
    },
  },

  -- Keymap hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunks" },
        { "<leader>n", group = "npm" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search/symbols" },
        { "<leader>t", group = "test" },
        { "<leader>x", group = "trouble" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "s", group = "surround/flash" },
      },
    },
  },

-- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Better vim.ui
  { "stevearc/dressing.nvim", event = "VeryLazy" },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "lazyterm",
        },
      },
    },
  },

  -- Treesitter context
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 3,
      trim_scope = "outer",
      mode = "cursor",
      zindex = 20,
    },
  },

  -- LSP progress
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = { winblend = 0 },
      },
    },
  },

  -- Colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        css = true,
        css_fn = true,
        mode = "background",
      },
    },
  },

  -- Symbol outline
  {
    "stevearc/aerial.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_mode = "window",
      backends = { "treesitter", "lsp", "markdown", "man" },
      show_guides = true,
      layout = {
        min_width = 28,
        default_direction = "prefer_right",
      },
      guides = {
        mid_item   = "├ ",
        last_item  = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
      filter_kind = false,
    },
  },
}