local neogit = require('neogit')

neogit.setup {
  disable_builtin_notifications = true,
  disable_insert_on_commit = 'auto',
  integrations = {
    diffview = true,
    telescope = true,
    fzf_lua = true,
  },
  sections = {
    ---@diagnostic disable-next-line: missing-fields
    recent = {
      folded = false,
    },
  },
}
vim.keymap.set('n', '<leader>go', neogit.open, { noremap = true, silent = true, desc = '[neogit] open' })
vim.keymap.set('n', '<leader>gs', function()
  neogit.open { kind = 'auto' }
end, { noremap = true, silent = true, desc = '[neogit] open (split)' })
vim.keymap.set('n', '<leader>gc', function()
  neogit.open { 'commit' }
end, { noremap = true, silent = true, desc = '[neogit] commit' })
