local M = {}

function M.npm_scripts()
  local file = vim.fn.findfile("package.json", ".;")
  if file == "" then
    vim.notify("No package.json found", vim.log.levels.WARN)
    return
  end

  local f = io.open(file, "r")
  if not f then
    return
  end
  local content = f:read("*all")
  f:close()

  local ok, data = pcall(vim.json.decode, content)
  if not ok or not data.scripts then
    vim.notify("No scripts found in package.json", vim.log.levels.INFO)
    return
  end

  local scripts = {}
  for name, _ in pairs(data.scripts) do
    table.insert(scripts, name)
  end
  table.sort(scripts)

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "NPM Scripts",
      finder = finders.new_table({
        results = scripts,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local function on_select()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd("split | term npm run " .. selection[1])
        end

        actions.select_default:replace(on_select)

        return true
      end,
    })
    :find()
end

function M.breakpoint_picker()
  local dap_breakpoints = require("dap.breakpoints").get()
  local results = {}

  for bufnr, breakpoints in pairs(dap_breakpoints) do
    local filename = vim.api.nvim_buf_get_name(bufnr)
    for _, bp in ipairs(breakpoints) do
      local line = bp.line
      local content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""
      table.insert(results, {
        filename = filename,
        lnum = line,
        col = 1,
        text = content,
        bufnr = bufnr,
        display = string.format("%s:%d -> %s", vim.fn.fnamemodify(filename, ":t"), line, vim.trim(content)),
      })
    end
  end

  if #results == 0 then
    vim.notify("No breakpoints set", vim.log.levels.INFO)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create({
    separator = " │ ",
    items = {
      { width = 20 },
      { width = 5 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { vim.fn.fnamemodify(entry.filename, ":t"), "TelescopeResultsFile" },
      { tostring(entry.lnum), "TelescopeResultsNumber" },
      { vim.trim(entry.text) },
    })
  end

  pickers
    .new({}, {
      prompt_title = "Manage Breakpoints",
      finder = finders.new_table({
        results = results,
        entry_maker = function(entry)
          entry.value = entry
          entry.display = make_display
          entry.ordinal = entry.filename .. " " .. tostring(entry.lnum) .. " " .. entry.text
          return entry
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = conf.qflist_previewer({}),
      attach_mappings = function(prompt_bufnr, map)
        local delete_breakpoint = function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          require("dap").toggle_breakpoint(false, nil, nil, { bufnr = selection.bufnr, lnum = selection.lnum })
          vim.schedule(function()
            M.breakpoint_picker()
          end)
        end

        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.api.nvim_set_current_buf(selection.bufnr)
          vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
        end)

        map("i", "<C-d>", delete_breakpoint)
        map("n", "dd", delete_breakpoint)

        return true
      end,
    })
    :find()
end

return M
