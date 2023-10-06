local function exists(fname)
  local stat = vim.loop.fs_stat(fname)
  return (stat and stat.type) or false
end

---@param root_dir string
---@param file string
local function has_file(root_dir, file)
  local function fqn(fname)
    fname = vim.fn.fnamemodify(fname, ':p')
    return vim.loop.fs_realpath(fname) or fname
  end
  root_dir = fqn(root_dir)
  file = fqn(file)
  return exists(file) and file:find(root_dir, 1, true) == 1
end

require('neodev').setup {
  override = function(root_dir, library)
    if has_file(root_dir, '/etc/nixos') or has_file(root_dir, 'nvim-config') then
      library.enabled = true
      library.plugins = true
    end
  end,
  lspconfig = false,
}
