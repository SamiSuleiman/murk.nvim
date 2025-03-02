local utils = require 'murk.utils'

local M = {}

local function get_curr_file_path()
  local buf = vim.api.nvim_get_current_buf()
  local bufPath = vim.api.nvim_buf_get_name(buf)
  local normalizedPath = vim.fn.fnamemodify(bufPath, ':p')
  return normalizedPath
end

local function create_cmds()
  vim.api.nvim_create_user_command('MurkStart', function()
    local bufPath = get_curr_file_path()
    if utils.is_file_markdown(bufPath) then
      utils.add_file_to_watched(bufPath)
    end
  end, {})

  vim.api.nvim_create_user_command('MurkStop', function()
    local bufPath = get_curr_file_path()
    if utils.is_file_markdown(bufPath) then
      utils.remove_file_from_watched(bufPath)
    end
  end, {})

  vim.api.nvim_create_user_command('MurkDump', function()
    utils.print_watched_files()
  end, {})

  vim.api.nvim_create_user_command('MurkStopAll', function()
    utils.purge_watched_files()
  end, {})
end

local function create_autocmds()
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.md' },
    callback = function()
      local bufPath = get_curr_file_path()
      if utils.is_file_in_watched(bufPath) then
        print('writing to css')
      end
    end,
  })
end

M.setup = function(opts)
  utils.ensure_dirs()
  local style = opts.css or utils.get_plugin_root() .. '/assets/style.css'

  create_cmds()
  create_autocmds()
end

return M
