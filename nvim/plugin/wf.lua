-- Show keymap hints after a delay (triggered by <leader> or <space>)
local wf = require('wf')
wf.setup()

local which_key = require('wf.builtin.which_key')
local register = require('wf.builtin.register')
local buffer = require('wf.builtin.buffer')
local mark = require('wf.builtin.mark')

-- Register
vim.keymap.set(
  'n',
  '<leader>wr',
  -- register(opts?: table) -> function
  -- opts?: option
  register(),
  { noremap = true, silent = true, desc = '[wf.nvim] register' }
)

-- Buffer
vim.keymap.set('n', '<Space>wb', buffer(), { noremap = true, silent = true, desc = '[wf.nvim] buffer' })

-- Mark
vim.keymap.set('n', "'", mark(), { nowait = true, noremap = true, silent = true, desc = '[wf.nvim] mark' })

-- Which Key
vim.keymap.set(
  'n',
  '<leader>',
  which_key { text_insert_in_advance = '<Leader>' },
  { noremap = true, silent = true, desc = '[wf.nvim] which-key /' }
)

vim.keymap.set(
  'n',
  '<space>',
  which_key { text_insert_in_advance = '<Space>' },
  { noremap = true, silent = true, desc = '[wf.nvim] which-key /' }
)
