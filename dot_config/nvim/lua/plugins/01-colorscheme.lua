-- Nord Colorscheme with custom overrides
return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_bold = true
      require("nord").set()

      local c = {
        bg       = "#2E3440",
        bg_dark  = "#272C36",
        bg_float = "#2E3440",
        border   = "#4C566A",
        fg       = "#ECEFF4",
        accent   = "#88C0D0",
        blue     = "#81A1C1",
        orange   = "#D08770",
        purple   = "#B48EAD",
      }

      local overrides = {
        NormalFloat           = { bg = c.bg_float },
        FloatBorder           = { fg = c.border, bg = c.bg_float },
        FloatTitle            = { fg = c.fg, bg = c.bg_float, bold = true },
        TelescopeBorder       = { fg = c.border, bg = c.bg_float },
        TelescopeNormal       = { bg = c.bg_float },
        TelescopePromptBorder = { fg = c.accent, bg = c.bg_float },
        TelescopePromptTitle  = { fg = c.accent, bold = true },
        AlphaHeader           = { fg = c.accent },
        AlphaButtons         = { fg = c.blue },
        AlphaShortcut         = { fg = c.orange },
        AlphaFooter           = { fg = c.purple },
        TreesitterContext     = { bg = c.bg_dark },
        IblIndent             = { fg = c.border },
        CmpGhostText          = { fg = c.border },
      }

      for group, hl in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, hl)
      end
    end,
  },
}