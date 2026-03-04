return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      { "<leader>bb", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Show Buffers" },
      { "<leader>fg", function() require("config.utils").live_grep_scope() end, desc = "Search in Scope" },
      {
        "<leader>ff",
        function()
          require("config.utils").smart_find_files()
        end,
        desc = "Find Files",
      },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find Recent Files" },
      { "<leader>fp", "<cmd>Telescope commands<cr>", desc = "Show Command Palette" },
      { "<leader>f;", "<cmd>Telescope command_history<cr>", desc = "Show Command History" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Search Word Under Cursor" },
      { "<leader>fo", function() require("config.utils").live_grep_open_files() end, desc = "Search in Open Files" },
      { "<leader>fc", function() require("config.utils").live_grep_scope() end, desc = "Search in Current Scope" },
      { "<leader>fR", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
      { "<leader>fT", function() require("config.utils").toggle_picker_scope() end, desc = "Toggle Search Scope" },
      { "<leader>fs", function() require("config.utils").workspace_symbols_prompt() end, desc = "Search Workspace Symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search Document Symbols" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search Help Tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Search Keymaps" },
      { "<leader>bf", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Buffer" },
      { "<leader>tr", function() require("config.utils").npm_scripts() end, desc = "Run NPM Task" },
      { "<leader>tl", function() require("config.utils").rerun_last_task() end, desc = "Rerun Last Task" },
      { "<leader>tt", function() require("config.utils").toggle_task_terminal() end, desc = "Toggle Task Terminal" },
      { "<leader>tf", function() require("config.utils").focus_task_terminal() end, desc = "Focus Task Terminal" },
      { "<leader>ts", function() require("config.utils").stop_task() end, desc = "Stop Running Task" },
      { "<leader>tc", function() require("config.utils").clear_task_terminal() end, desc = "Clear Task Terminal" },
      { "<leader>th", function() require("config.utils").task_history_picker() end, desc = "Show Task History" },
      { "<leader>ta", function() require("config.utils").toggle_task_autoclose() end, desc = "Toggle Task Auto Close" },
      { "<leader>xg", function() require("config.utils").live_grep_to_quickfix() end, desc = "Search and Fill Quickfix" },
      { "<leader>xw", function() require("config.utils").grep_word_to_quickfix() end, desc = "Search Word and Fill Quickfix" },
      { "<leader>xo", function() require("config.utils").find_files_to_quickfix() end, desc = "Find Files and Fill Quickfix" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Show Git Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Show Git Status" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = { "node_modules", ".git/", ".cache", "dist/", "build/" },
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.outer",
          },
        },
      },
    },
    config = function(_, opts)
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if ok then
        treesitter.setup(opts)
      end
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>ga", gs.stage_hunk, "Git Stage Hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Git Reset Hunk")
        map("v", "<leader>ga", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git Stage Hunk")
        map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git Reset Hunk")
        map("n", "<leader>gA", gs.stage_buffer, "Git Stage Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Git Undo Stage Hunk")
        map("n", "<leader>gR", gs.reset_buffer, "Git Reset Buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Git Preview Hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Git Blame Line")
        map("n", "<leader>gD", gs.diffthis, "Git Diff This")
        map("n", "<leader>g~", function() gs.diffthis("~") end, "Git Diff Against ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff" },
      { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git Blame" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log" },
    },
  },

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
  },

  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      warn_no_results = false,
      open_no_results = true,
      win = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = " Problems ",
        title_pos = "center",
        footer = " (Empty means no errors/warnings found) ",
        footer_pos = "center",
        position = { 0.98, 0.5 },
        size = { width = 0.9, height = 0.15 },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Show Project Diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Show Buffer Diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Show Symbols List" },
      { "<leader>xi", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Show LSP Locations" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Show Location List" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Show Quickfix List" },
    },
  },

  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTelescope<cr>", desc = "Todo List" },
      { "<leader>xT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local keys = {
        {
          "<leader>ba",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Add Bookmark",
        },
        {
          "<leader>bm",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Bookmark Menu",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>b" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Open Bookmark " .. i,
        })
      end
      return keys
    end,
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
  },

  {
    "stevearc/oil.nvim",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
  },
}
