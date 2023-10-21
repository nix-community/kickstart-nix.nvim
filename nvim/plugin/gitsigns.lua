vim.schedule(function()
  require('gitsigns').setup {
    current_line_blame = false,
    current_line_blame_opts = {
      ignore_whitespace = true,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']g', function()
        if vim.wo.diff then
          return ']g'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = '[git] next hunk' })

      map('n', '[g', function()
        if vim.wo.diff then
          return '[g'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = '[git] previous hunk' })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', function()
        vim.cmd.Gitsigns('stage_hunk')
      end, { desc = '[git] stage hunk' })
      map({ 'n', 'v' }, '<leader>hr', function()
        vim.cmd.Gitsigns('reset_hunk')
      end, { desc = '[git] reset hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = '[git] stage buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[git] undo stage hunk' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = '[git] reset buffer' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = '[git] preview hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line { full = true }
      end, { desc = '[git] blame line (full)' })
      map('n', '<leader>glb', gs.toggle_current_line_blame, { desc = '[git] toggle current line blame' })
      map('n', '<leader>hd', gs.diffthis, { desc = '[git] diff this' })
      map('n', '<leader>hD', function()
        gs.diffthis('~')
      end, { desc = '[git] diff ~' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = '[git] toggle deleted' })
      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[git] stage buffer' })
    end,
  }
end)
