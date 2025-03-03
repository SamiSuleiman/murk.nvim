local M = {}

-- returns the path to the watched file and creates it if it doesn't exist.
local function get_watched_file()
  local path = vim.fn.stdpath 'data' .. '/murk/watched.txt'
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({}, path)
  end
  return path
end

local function path_to_file_name(path)
  return path:gsub('[\\/]', '__'):gsub('[^%w%.%-]', '_') .. '.html'
end

M.print_table = function(t)
  local val = vim.inspect(t)
  print(val)
end

M.ensure_dirs = function()
  local dirs = {
    data = vim.fn.stdpath 'data' .. '/murk',
    html = vim.fn.stdpath 'data' .. '/murk/html',
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

M.convert_to_html = function(path, stylePath)
  local isAlreadyConverted = false
  local dataPath = vim.fn.stdpath 'data' .. '/murk' .. '/html'
  local newFileName = path_to_file_name(path)
  local newPath = dataPath .. '/' .. newFileName

  if vim.fn.filereadable(newPath) == 1 then
    isAlreadyConverted = true
  end

  local cmd = 'pandoc -s -c ' .. stylePath .. ' ' .. path .. ' -o ' .. newPath
  vim.fn.system(cmd)
  return {
    path = newPath,
    isAlreadyConverted = isAlreadyConverted,
  }
end

M.open_html = function(path)
  local cmd = 'open '
    .. vim.fn.stdpath 'data'
    .. '/murk/html/'
    .. path_to_file_name(path)
  vim.fn.system(cmd)
end

M.init_cleanup = function(cleanWatched)
  local dataPath = vim.fn.stdpath 'data' .. '/murk' .. '/html'
  vim.fn.delete(dataPath, 'rf')
  if cleanWatched then
    M.purge_watched_files()
  end
end

return M
