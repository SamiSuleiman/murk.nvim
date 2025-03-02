local consts = require 'murk.consts'

local M = {}

M.print_table = function(t)
  local val = vim.inspect(t)
  print(val)
end

M.ensure_dirs = function()
  local dirs = {
    changes = consts.log_file_path .. '/changes',
  }

  for _, dir in pairs(dirs) do
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end
end

M.get_plugin_root = function()
  local paths =
    vim.api.nvim_get_runtime_file('lua/' .. 'murk' .. '/init.lua', false)
  if #paths > 0 then
    return vim.fn.fnamemodify(paths[1], ':h:h:h')
  end
  return nil
end

return M
