if vim.g.did_load_commands_plugin then
  return
end
vim.g.did_load_commands_plugin = true

local api = vim.api

-- delete current buffer
api.nvim_create_user_command('Q', 'bd % <CR>', {})
