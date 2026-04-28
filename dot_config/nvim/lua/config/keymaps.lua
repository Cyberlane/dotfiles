-- lua/config/keymaps.lua
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ─────────────────────────────────────────────────────────────
-- WINDOW NAVIGATION
-- ─────────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<C-Up>",    ":resize -2<CR>",         { desc = "Decrease window height" })
map("n", "<C-Down>",  ":resize +2<CR>",          { desc = "Increase window height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- ─────────────────────────────────────────────────────────────
-- BUFFER
-- ─────────────────────────────────────────────────────────────
map("n", "<S-h>",      "<cmd>bprevious<cr>",                                        { desc = "Prev buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",                                            { desc = "Next buffer" })
map("n", "[b",         "<cmd>BufferLineCyclePrev<cr>",                              { desc = "Prev buffer" })
map("n", "]b",         "<cmd>BufferLineCycleNext<cr>",                              { desc = "Next buffer" })
map("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end,   { desc = "Delete buffer" })
map("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end,    { desc = "Delete buffer (force)" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>",                              { desc = "Toggle pin" })
map("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>",                   { desc = "Delete non-pinned buffers" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>",                            { desc = "Delete other buffers" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>",                             { desc = "Delete buffers to right" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>",                              { desc = "Delete buffers to left" })

-- ─────────────────────────────────────────────────────────────
-- EDITOR
-- ─────────────────────────────────────────────────────────────
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>",    { desc = "Escape and clear hlsearch" })
map("n", "n",  "nzzzv",                             { desc = "Next search result centered" })
map("n", "N",  "Nzzzv",                             { desc = "Prev search result centered" })
map("v", "<",  "<gv",                               { desc = "Indent left" })
map("v", ">",  ">gv",                               { desc = "Indent right" })
map("n", "J",  "mzJ`z",                             { desc = "Join lines without moving cursor" })
map("n", "<A-j>", "<cmd>m .+1<cr>==",               { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",               { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",        { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",        { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",               { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",               { desc = "Move selection up" })
map("x", "<leader>p", [["_dP]],                      { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", [["+y]],              { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]],                       { desc = "Yank line to clipboard" })

-- ─────────────────────────────────────────────────────────────
-- FILE / FIND (Telescope)
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>,",  "<cmd>Telescope buffers show_all_buffers=true<cr>",                          { desc = "Switch buffer" })
map("n", "<leader>/",  "<cmd>Telescope live_grep<cr>",                                             { desc = "Find in files (grep)" })
map("n", "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end,  { desc = "Find files" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                              { desc = "Recent files" })
map("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                             { desc = "Fuzzy find in buffer" })
map("n", "<leader>fp", "<cmd>Telescope projects<cr>",                                              { desc = "Projects" })
map("n", "<leader>nr", function() require("config.utils").npm_scripts() end,                       { desc = "NPM run" })
map("n", "<leader>nd", function() require("config.utils").npm_debug() end,                         { desc = "NPM debug" })

-- ─────────────────────────────────────────────────────────────
-- SEARCH
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>",                                             { desc = "Help pages" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>",                                               { desc = "Keymaps" })
map("n", "<leader>sw", "<cmd>Telescope grep_string<cr>",                                           { desc = "Word under cursor" })
map("n", "<leader>sR", "<cmd>Telescope resume<cr>",                                                { desc = "Resume search" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>",                                                   { desc = "Todo comments" })
map("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",                           { desc = "Todo/Fix/Fixme" })
map("n", "<leader>sr", function() require("grug-far").open() end,                                  { desc = "Search & replace (project)" })
map("n", "<leader>sW", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search & replace word under cursor" })
map({ "n", "x", "o" }, "s", function() require("flash").jump() end,                               { desc = "Flash jump" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end,                         { desc = "Flash treesitter" })

-- ─────────────────────────────────────────────────────────────
-- CODE (LSP — buffer-local keymaps set in autocmds.lua LspAttach)
-- ─────────────────────────────────────────────────────────────
map("n", "[d",         vim.diagnostic.goto_prev,                                                   { desc = "Prev diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,                                                   { desc = "Next diagnostic" })
map("n", "gl",         vim.diagnostic.open_float,                                                  { desc = "Open diagnostic float" })
map("n", "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format buffer" })

-- ─────────────────────────────────────────────────────────────
-- DEBUG (DAP)
-- ─────────────────────────────────────────────────────────────
map("n", "<F5>",       function() require("dap").continue() end,                                   { desc = "DAP: Continue" })
map("n", "<F10>",      function() require("dap").step_over() end,                                  { desc = "DAP: Step over" })
map("n", "<F11>",      function() require("dap").step_into() end,                                  { desc = "DAP: Step into" })
map("n", "<F12>",      function() require("dap").step_out() end,                                   { desc = "DAP: Step out" })
map("n", "<leader>dB", function() require("dap").toggle_breakpoint() end,                          { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end,                                   { desc = "Continue" })
map("n", "<leader>dL", function() require("config.utils").breakpoint_picker() end,                 { desc = "List breakpoints" })
map("n", "<leader>dX", function() require("dap").clear_breakpoints() end,                          { desc = "Clear all breakpoints" })
map("n", "<leader>du", function() require("dapui").toggle({}) end,                                 { desc = "Toggle DAP UI" })
map({ "n", "v" }, "<leader>de", function() require("dapui").eval() end,                            { desc = "Eval expression" })

-- ─────────────────────────────────────────────────────────────
-- TESTING
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>tt", function() require("neotest").run.run() end,                                { desc = "Run nearest test" })
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,               { desc = "Run file tests" })
map("n", "<leader>ts", function() require("neotest").summary.toggle() end,                         { desc = "Toggle test summary" })
map("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end,             { desc = "Test output" })
map("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,             { desc = "Debug nearest test" })
map("n", "<leader>tw", function() require("neotest").run.run({ jestCommand = "jest --watch" }) end, { desc = "Toggle watch mode" })
map("n", "<leader>tx", "<cmd>XcodebuildPicker<cr>",                                                { desc = "Xcode: picker" })
map("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>",                                                 { desc = "Xcode: build" })
map("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>",                                       { desc = "Xcode: build for testing" })
map("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>",                                              { desc = "Xcode: build and run" })
map("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>",                                          { desc = "Xcode: select device" })
map("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>",                                          { desc = "Xcode: select scheme" })
map("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",                                            { desc = "Xcode: toggle logs" })

-- ─────────────────────────────────────────────────────────────
-- GIT
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>gg", "<cmd>Git<cr>",                        { desc = "Git status (fugitive)" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<cr>",                 { desc = "Git diff" })
map("n", "<leader>gB", "<cmd>Git blame<cr>",                  { desc = "Git blame" })
map("n", "<leader>gl", "<cmd>Git log<cr>",                    { desc = "Git log" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>",      { desc = "Git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>",       { desc = "Git status (telescope)" })
map("n", "<leader>gL", "<cmd>LazyGit<cr>",                    { desc = "LazyGit" })
map("n", "<leader>gv", "<cmd>DiffviewOpen<cr>",               { desc = "Diffview open" })
map("n", "<leader>gV", "<cmd>DiffviewClose<cr>",              { desc = "Diffview close" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",      { desc = "File history" })
-- Git hunks: ]h [h <leader>hs/hr/hS/hu/hR/hp/hb/hd/hD set in git.lua on_attach

-- ─────────────────────────────────────────────────────────────
-- EXPLORER
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>Neotree reveal toggle<cr>", { desc = "Toggle file explorer" })
map("n", "-",         "<cmd>Oil<cr>",                   { desc = "Open parent dir (oil)" })

-- ─────────────────────────────────────────────────────────────
-- SYMBOLS / OUTLINE
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>ss", "<cmd>Trouble symbols toggle focus=false<cr>",                      { desc = "Symbols (Trouble)" })
map("n", "<leader>sl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",       { desc = "LSP refs/defs (Trouble)" })
map("n", "<leader>so", "<cmd>AerialToggle<cr>",                                            { desc = "Symbol outline (aerial)" })

-- ─────────────────────────────────────────────────────────────
-- TROUBLE / DIAGNOSTICS
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",               { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",  { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                   { desc = "Location list" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                    { desc = "Quickfix list" })

-- ─────────────────────────────────────────────────────────────
-- SESSIONS
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>qs", function() require("persistence").load() end,                { desc = "Restore session" })
map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
map("n", "<leader>qd", function() require("persistence").stop() end,                { desc = "Stop session persistence" })
map("n", "<leader>qq", "<cmd>qa<cr>",                                               { desc = "Quit all" })

-- ─────────────────────────────────────────────────────────────
-- DATABASE
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>db", "<cmd>DBUIToggle<cr>",       { desc = "Toggle DB UI" })
map("n", "<leader>dA", "<cmd>DBUIAddConnection<cr>", { desc = "Add DB connection" })

-- ─────────────────────────────────────────────────────────────
-- UI TOGGLES
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, { desc = "Dismiss notifications" })

-- ─────────────────────────────────────────────────────────────
-- TODO COMMENTS
-- ─────────────────────────────────────────────────────────────
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev todo comment" })

-- ─────────────────────────────────────────────────────────────
-- HARPOON
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>a", function() require("harpoon"):list():add() end,                                         { desc = "Harpoon add file" })
map("n", "<C-e>",     function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,      { desc = "Harpoon menu" })
map("n", "<leader>1", function() require("harpoon"):list():select(1) end,                                     { desc = "Harpoon file 1" })
map("n", "<leader>2", function() require("harpoon"):list():select(2) end,                                     { desc = "Harpoon file 2" })
map("n", "<leader>3", function() require("harpoon"):list():select(3) end,                                     { desc = "Harpoon file 3" })
map("n", "<leader>4", function() require("harpoon"):list():select(4) end,                                     { desc = "Harpoon file 4" })
map("n", "<leader>5", function() require("harpoon"):list():select(5) end,                                     { desc = "Harpoon file 5" })

-- ─────────────────────────────────────────────────────────────
-- MISC
-- ─────────────────────────────────────────────────────────────
map("n", "<leader>u",  "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
map("n", "<leader>cm", "<cmd>Mason<cr>",           { desc = "Mason" })
