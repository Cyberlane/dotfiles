local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 3
opt.showmode = false
opt.cmdheight = 0

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime = 200
opt.timeoutlen = 300

opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0

opt.shortmess:append("c")
opt.shortmess:append("C")
opt.shortmess:append("I")

opt.fillchars:append({
  eob = " ",
})

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.inccommand = "split"

opt.smoothscroll = true

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

vim.g.markdown_recommended_style = 0
