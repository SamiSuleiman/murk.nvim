local M = {}

local path = vim.fn.stdpath 'data' .. '/murk'

M.log_file_path = path .. '/log'

return M
