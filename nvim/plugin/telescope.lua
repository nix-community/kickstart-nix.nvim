local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = {
      '--type',
      current_file_ext,
    }
  end
  local conf = require('telescope.config').values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end

vim.keymap.set('n', '<leader>tp', function()
  builtin.find_files()
end, { desc = '[telescope] find files' })
vim.keymap.set('n', '<M-p>', builtin.oldfiles, { desc = '[telescope] old files' })
vim.keymap.set('n', '<C-g>', builtin.live_grep, { desc = '[telescope] live grep' })
vim.keymap.set('n', '<leader>tf', fuzzy_grep, { desc = '[telescope] fuzzy grep' })
vim.keymap.set('n', '<M-f>', fuzzy_grep_current_file_type, { desc = '[telescope] fuzzy grep filetype' })
vim.keymap.set('n', '<M-g>', live_grep_current_file_type, { desc = '[telescope] live grep filetype' })
vim.keymap.set('n', '<leader>t*', grep_string_current_file_type, { desc = '[telescope] grep string filetype' })
vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = '[telescope] grep string' })
vim.keymap.set('n', '<leader>tg', project_files, { desc = '[telescope] project files' })
vim.keymap.set('n', '<leader>tc', builtin.quickfix, { desc = '[telescope] quickfix list' })
vim.keymap.set('n', '<leader>tq', builtin.command_history, { desc = '[telescope] command history' })
vim.keymap.set('n', '<leader>tl', builtin.loclist, { desc = '[telescope] loclist' })
vim.keymap.set('n', '<leader>tr', builtin.registers, { desc = '[telescope] registers' })
vim.keymap.set('n', '<leader>tbb', builtin.buffers, { desc = '[telescope] buffers' })
vim.keymap.set(
  'n',
  '<leader>tbf',
  builtin.current_buffer_fuzzy_find,
  { desc = '[telescope] fuzzy find (current buffer)' }
)
vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, { desc = '[telescope] lsp document symbols' })
vim.keymap.set(
  'n',
  '<leader>to',
  builtin.lsp_dynamic_workspace_symbols,
  { desc = '[telescope] lsp dynamic workspace symbols' }
)

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    layout_strategy = 'vertical',
    layout_config = layout_config,
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        -- ['<esc>'] = actions.close,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-a>'] = actions.cycle_previewers_prev,
      },
      n = {
        q = actions.close,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension('fzy_native')
-- telescope.load_extension('smart_history')
