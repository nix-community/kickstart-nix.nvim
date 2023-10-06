local api = vim.api

-- delete current buffer
api.nvim_create_user_command('Q', 'bd % <CR>', {})
