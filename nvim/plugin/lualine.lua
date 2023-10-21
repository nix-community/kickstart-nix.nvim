local navic = require('nvim-navic')
navic.setup()

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end

require('lualine').setup {
  globalstatus = true,
  sections = {
    lualine_c = {
      -- nvim-navic
      { navic.get_location, cond = navic.is_available },
    },
    lualine_z = {
      -- (see above)
      { extra_mode_status },
    },
  },
  options = {
    theme = 'auto',
  },
  -- Example top tabline configuration (this may clash with other plugins)
  -- tabline = {
  --   lualine_a = {
  --     {
  --       'tabs',
  --       mode = 1,
  --     },
  --   },
  --   lualine_b = {
  --     {
  --       'buffers',
  --       show_filename_only = true,
  --       show_bufnr = true,
  --       mode = 4,
  --       filetype_names = {
  --         TelescopePrompt = 'Telescope',
  --         dashboard = 'Dashboard',
  --         fzf = 'FZF',
  --       },
  --       buffers_color = {
  --         -- Same values as the general color option can be used here.
  --         active = 'lualine_b_normal', -- Color for active buffer.
  --         inactive = 'lualine_b_inactive', -- Color for inactive buffer.
  --       },
  --     },
  --   },
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {},
  -- },
  winbar = {
    lualine_z = {
      {
        'filename',
        path = 1,
        file_status = true,
        newfile_status = true,
      },
    },
  },
  extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
}
