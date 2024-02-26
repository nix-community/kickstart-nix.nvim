if vim.g.did_load_eyeliner_plugin then
  return
end
vim.g.did_load_eyeliner_plugin = true

-- Highlights unique characters for f/F and t/T motions
require('eyeliner').setup {
  highlight_on_key = true, -- show highlights only after key press
  dim = true, -- dim all other characters
}
