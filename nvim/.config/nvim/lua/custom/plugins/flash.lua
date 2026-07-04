vim.pack.add {
  'https://github.com/folke/flash.nvim',
}
local flash = require 'flash'

vim.keymap.set({ "n", "x", "o" }, 's', flash.jump, { desc = 'miniharp: toggle file mark' })
