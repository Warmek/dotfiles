vim.pack.add({
  {
    src = 'https://github.com/vieitesss/miniharp.nvim',
    version = vim.version.range("v*"),
  }
})

require('miniharp').setup({
  autoload = true,
  autosave = true,
  show_on_autoload = false,
  notifications = true, -- enable notification and status messages (default: true)
  ui = {
    position = 'center', -- 'center' | 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
    show_hints = true, -- show close hints in the floating list (default: true)
    enter = true, -- enter the floating window when it opens (default: true)
  },
})

local miniharp = require('miniharp')

vim.keymap.set('n', '<leader>a', miniharp.toggle_file, { desc = 'miniharp: toggle file mark' })
vim.keymap.set('n', '<C-n>',     miniharp.next,        { desc = 'miniharp: next file mark' })
vim.keymap.set('n', '<C-p>',     miniharp.prev,        { desc = 'miniharp: prev file mark' })
vim.keymap.set('n', '<C-e>', miniharp.show_list,   { desc = 'miniharp: toggle marks list' })

vim.keymap.set('n', '<C-h>', function() miniharp.go_to(1) end, { desc = 'miniharp: go to mark 1' })
vim.keymap.set('n', '<C-j>', function() miniharp.go_to(2) end, { desc = 'miniharp: go to mark 2' })
vim.keymap.set('n', '<C-k>', function() miniharp.go_to(3) end, { desc = 'miniharp: go to mark 3' })
vim.keymap.set('n', '<C-l>', function() miniharp.go_to(4) end, { desc = 'miniharp: go to mark 4' })
