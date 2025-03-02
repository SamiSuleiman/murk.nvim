local M = {}

-- returns the path to the watched file and creates it if it doesn't exist.
local function get_watched_file()
  local path = vim.fn.stdpath 'data' .. '/murk/watched.txt'
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({}, path)
  end
  return path
end


M.print_table = function(t)
  local val = vim.inspect(t)
  print(val)
end

M.ensure_dirs = function()
  local dirs = {
    data = vim.fn.stdpath 'data' .. '/murk',
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

M.is_file_markdown = function(path)
  local ext = vim.fn.fnamemodify(path, ':e')
  return ext == 'md'
end


M.get_watched_files = function()
  return vim.fn.readfile(get_watched_file())
end

M.watched_files = M.get_watched_files()

M.purge_watched_files = function()
  vim.fn.writefile({}, get_watched_file())
  M.watched_files = {}
end

M.print_watched_files = function()
  local watched = vim.fn.readfile(get_watched_file())
  M.print_table(watched)
end

M.add_file_to_watched = function(path)
  local watched = vim.fn.readfile(get_watched_file())
  if vim.fn.index(watched, path) == -1 then
    table.insert(watched, path)
    vim.fn.writefile(watched, get_watched_file())
  end
  M.watched_files = watched
end

M.remove_file_from_watched = function(path)
  local watched = vim.fn.readfile(get_watched_file())
  local idx = vim.fn.index(watched, path)
  if idx ~= -1 then
    table.remove(watched, idx + 1)
    M.print_table(watched)
    vim.fn.writefile(watched, get_watched_file())
  end
  M.watched_files = watched
end

M.is_file_in_watched = function(path)
  local watched

  if M.watched_files == nil or #M.watched_files == 0 then
    watched = M.get_watched_files()
  else
    watched = M.watched_files
  end

  return vim.fn.index(watched, path) ~= -1
end

return M
