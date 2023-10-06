local builtin = require('statuscol.builtin')
require('statuscol').setup {
  setopt = true,
  relculright = true,
  segments = {
    { text = { '%s' }, click = 'v:lua.ScSa' },
    {
      text = { builtin.lnumfunc, ' ' },
      condition = { true, builtin.not_empty },
      click = 'v:lua.ScLa',
    },
  },
}
