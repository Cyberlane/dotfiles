-- Git plugins: gitsigns, fugitive, lazygit, diffview
return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        map("n", "]h",         gs.next_hunk,   "Next hunk")
        map("n", "[h",         gs.prev_hunk,   "Prev hunk")
        map("n", "<leader>hs", gs.stage_hunk,  "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,  "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer,    "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hR", gs.reset_buffer,    "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk,    "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis,         "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- Git commands
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "GMove", "GDelete", "GBrowse" },
    event = "VeryLazy",
  },

  -- LazyGit TUI
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },

  -- Full-screen diff + file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    event = "VeryLazy",
    opts = {},
  },
}