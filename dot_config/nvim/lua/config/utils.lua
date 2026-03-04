local M = {}

local task_state = {
  bufnr = nil,
  last_cmd = nil,
  last_cwd = nil,
  history = {},
  auto_close = false,
}

local picker_state = {
  scope = "root",
}

local task_autocmd_created = false

local function is_task_terminal(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "terminal"
end

local function task_terminal_job_id(bufnr)
  local ok, job_id = pcall(vim.api.nvim_buf_get_var, bufnr, "terminal_job_id")
  if ok then
    return job_id
  end
  return nil
end

local function push_task_history(command, cwd)
  local last = task_state.history[1]
  if last and last.command == command and last.cwd == cwd then
    return
  end

  table.insert(task_state.history, 1, { command = command, cwd = cwd })
  if #task_state.history > 10 then
    table.remove(task_state.history)
  end
end

local function ensure_task_autocmd()
  if task_autocmd_created then
    return
  end

  vim.api.nvim_create_autocmd("TermClose", {
    callback = function(args)
      if not task_state.auto_close or args.buf ~= task_state.bufnr then
        return
      end

      for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, false)
        end
      end
    end,
  })

  task_autocmd_created = true
end

local function task_window()
  if not is_task_terminal(task_state.bufnr) then
    return nil
  end

  local wins = vim.fn.win_findbuf(task_state.bufnr)
  if #wins > 0 and vim.api.nvim_win_is_valid(wins[1]) then
    return wins[1]
  end

  return nil
end

local function open_task_terminal()
  local win = task_window()
  if win then
    vim.api.nvim_set_current_win(win)
    return task_state.bufnr
  end

  vim.cmd("botright split")

  if is_task_terminal(task_state.bufnr) then
    vim.api.nvim_win_set_buf(0, task_state.bufnr)
  else
    vim.cmd("terminal")
    task_state.bufnr = vim.api.nvim_get_current_buf()
    vim.b[task_state.bufnr].task_terminal = true
  end

  return task_state.bufnr
end

local function run_in_task_terminal(command, cwd)
  local bufnr = open_task_terminal()
  local job_id = task_terminal_job_id(bufnr)

  if not job_id or job_id <= 0 then
    task_state.bufnr = nil
    bufnr = open_task_terminal()
    job_id = task_terminal_job_id(bufnr)
  end

  if not job_id or job_id <= 0 then
    vim.notify("Task terminal is unavailable", vim.log.levels.ERROR)
    return nil
  end

  local command_cwd = cwd or vim.fn.getcwd()
  vim.fn.chansend(job_id, "cd " .. vim.fn.shellescape(command_cwd) .. "\n")
  vim.fn.chansend(job_id, command .. "\n")
  vim.cmd("startinsert")

  return {
    job_id = job_id,
    cwd = command_cwd,
  }
end

function M.project_root()
  local current_file_dir = vim.fn.expand("%:p:h")
  local start_path = current_file_dir ~= "" and current_file_dir or vim.fn.getcwd()
  local git_marker = vim.fs.find(".git", {
    path = start_path,
    upward = true,
  })[1]

  if git_marker then
    return vim.fs.dirname(git_marker)
  end

  return vim.fn.getcwd()
end

function M.picker_cwd()
  if picker_state.scope == "cwd" then
    return vim.fn.getcwd()
  end

  return M.project_root()
end

function M.toggle_picker_scope()
  if picker_state.scope == "root" then
    picker_state.scope = "cwd"
  else
    picker_state.scope = "root"
  end

  vim.notify("Picker scope: " .. picker_state.scope, vim.log.levels.INFO)
end

function M.smart_find_files()
  local builtin = require("telescope.builtin")
  local cwd = M.picker_cwd()
  local git_marker = vim.fs.find(".git", {
    path = cwd,
    upward = true,
  })[1]

  if git_marker then
    local ok = pcall(builtin.git_files, {
      cwd = cwd,
      show_untracked = true,
    })

    if ok then
      return
    end
  end

  builtin.find_files({
    hidden = true,
    cwd = cwd,
  })
end

function M.live_grep_project()
  require("telescope.builtin").live_grep({ cwd = M.project_root() })
end

function M.live_grep_scope()
  require("telescope.builtin").live_grep({ cwd = M.picker_cwd() })
end

function M.live_grep_open_files()
  require("telescope.builtin").live_grep({
    cwd = M.picker_cwd(),
    grep_open_files = true,
  })
end

function M.workspace_symbols_prompt()
  vim.ui.input({ prompt = "Workspace symbol query: " }, function(input)
    if input == nil then
      return
    end

    local opts = {
      cwd = M.picker_cwd(),
    }

    if input ~= "" then
      opts.query = input
    end

    require("telescope.builtin").lsp_workspace_symbols(opts)
  end)
end

function M.run_task(command, cwd)
  if not command or command == "" then
    return
  end

  ensure_task_autocmd()

  local wrapped_command = command
  if task_state.auto_close then
    wrapped_command = command .. "; __claude_task_status=$?; if [ $__claude_task_status -eq 0 ]; then exit; fi"
  end

  local run = run_in_task_terminal(wrapped_command, cwd)
  if not run then
    return
  end

  task_state.last_cmd = command
  task_state.last_cwd = run.cwd
  push_task_history(command, run.cwd)
end

function M.rerun_last_task()
  if not task_state.last_cmd then
    vim.notify("No task has been run yet", vim.log.levels.INFO)
    return
  end

  M.run_task(task_state.last_cmd, task_state.last_cwd)
end

function M.stop_task()
  if not is_task_terminal(task_state.bufnr) then
    vim.notify("No task terminal is active", vim.log.levels.INFO)
    return
  end

  local job_id = task_terminal_job_id(task_state.bufnr)
  if not job_id or job_id <= 0 then
    vim.notify("No running task to stop", vim.log.levels.INFO)
    return
  end

  vim.fn.jobstop(job_id)
end

function M.clear_task_terminal()
  if not is_task_terminal(task_state.bufnr) then
    vim.notify("No task terminal is active", vim.log.levels.INFO)
    return
  end

  local job_id = task_terminal_job_id(task_state.bufnr)
  if not job_id or job_id <= 0 then
    vim.notify("Task terminal is unavailable", vim.log.levels.INFO)
    return
  end

  vim.fn.chansend(job_id, "clear\n")
end

function M.task_history_picker()
  if #task_state.history == 0 then
    vim.notify("No task history yet", vim.log.levels.INFO)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Task History",
      finder = finders.new_table({
        results = task_state.history,
        entry_maker = function(entry)
          return {
            value = entry,
            ordinal = entry.command .. " " .. entry.cwd,
            display = entry.command .. "  [" .. entry.cwd .. "]",
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection and selection.value then
            M.run_task(selection.value.command, selection.value.cwd)
          end
        end)

        return true
      end,
    })
    :find()
end

function M.toggle_task_autoclose()
  task_state.auto_close = not task_state.auto_close
  vim.notify("Task auto-close: " .. (task_state.auto_close and "on" or "off"), vim.log.levels.INFO)
end

function M.toggle_task_terminal()
  local win = task_window()
  if win then
    vim.api.nvim_win_close(win, false)
    return
  end

  open_task_terminal()
end

function M.focus_task_terminal()
  local win = task_window()
  if win then
    vim.api.nvim_set_current_win(win)
    return
  end

  open_task_terminal()
end

function M.live_grep_to_quickfix(default_text)
  local actions = require("telescope.actions")

  require("telescope.builtin").live_grep({
    cwd = M.picker_cwd(),
    default_text = default_text,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.smart_send_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
        pcall(vim.cmd, "Trouble qflist open")
      end)

      return true
    end,
  })
end

function M.grep_word_to_quickfix()
  local actions = require("telescope.actions")

  require("telescope.builtin").grep_string({
    cwd = M.picker_cwd(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.smart_send_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
        pcall(vim.cmd, "Trouble qflist open")
      end)

      return true
    end,
  })
end

function M.find_files_to_quickfix()
  local actions = require("telescope.actions")

  require("telescope.builtin").find_files({
    cwd = M.picker_cwd(),
    hidden = true,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.smart_send_to_qflist(prompt_bufnr)
        actions.open_qflist(prompt_bufnr)
        pcall(vim.cmd, "Trouble qflist open")
      end)

      return true
    end,
  })
end

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
      attach_mappings = function(prompt_bufnr)
        local function on_select()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          M.run_task("npm run " .. selection[1], vim.fn.fnamemodify(file, ":h"))
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
