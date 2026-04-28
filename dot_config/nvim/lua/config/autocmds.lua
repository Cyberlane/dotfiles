-- lua/config/autocmds.lua
local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close certain filetypes with just <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup", "help", "lspinfo", "notify", "qf",
    "spectre_panel", "startuptime", "tsplayground", "neotest-output",
    "checkhealth", "neotest-summary", "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Wrap and spell check in text files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- LSP keymaps (set on every buffer where LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_keymaps"),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd",         vim.lsp.buf.definition,                                                      "Goto Definition")
    map("gD",         vim.lsp.buf.declaration,                                                     "Goto Declaration")
    map("gI",         vim.lsp.buf.implementation,                                                  "Goto Implementation")
    map("gr",         function() require("telescope.builtin").lsp_references() end,                "Goto References")
    map("K",          function() vim.lsp.buf.hover({ border = "rounded" }) end,                    "Hover Documentation")
    map("<C-k>",      function() vim.lsp.buf.signature_help({ border = "rounded" }) end,           "Signature Help")
    map("<leader>D",  vim.lsp.buf.type_definition,                                                 "Type Definition")
    map("<leader>cr", vim.lsp.buf.rename,                                                          "Rename")
    map("<leader>ca", vim.lsp.buf.code_action,                                                     "Code Action")
    map("<leader>cs", function() require("telescope.builtin").lsp_document_symbols() end,          "Document Symbols")
    map("<leader>cw", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, "Workspace Symbols")

    -- Enable inlay hints if supported
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})
