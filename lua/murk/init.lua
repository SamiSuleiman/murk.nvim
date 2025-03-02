local utils = require 'murk.utils'

local M = {}

-- vim.api.nvim_create_autocmd('BufWritePost', {
--   pattern = { '*.md'},
--   callback = function(ctx)
--   end,
-- })

M.setup = function(opts)
  local style = opts.css or utils.get_plugin_root() .. '/assets/style.css'

  local fileContent  = vim.fn.readfile(style)
  utils.print_table(fileContent)


  vim.api.nvim_create_user_command('Murk', function()
    print 'murk'
  end, {})
end

return M
