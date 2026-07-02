local function gh(repo) return 'https://github.com/' .. repo end

---@type (string|vim.pack.Spec)[]
local telescope_plugins = {
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
}
if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

vim.pack.add(telescope_plugins)

require('telescope').setup {
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>lh', builtin.help_tags, { desc = '[L]ook for [H]elp' })
vim.keymap.set('n', '<leader>lk', builtin.keymaps, { desc = '[L]ook for [K]eymaps' })
vim.keymap.set('n', '<leader>lf', builtin.find_files, { desc = '[L]ook for [F]iles' })
vim.keymap.set('n', '<leader>ls', builtin.builtin, { desc = '[L]ook for [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>lw', builtin.grep_string, { desc = '[L]ook for current [W]ord' })
vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = '[L]ook for by [G]rep' })
vim.keymap.set('n', '<leader>ld', builtin.diagnostics, { desc = '[L]ook for [D]iagnostics' })
vim.keymap.set('n', '<leader>lr', builtin.resume, { desc = '[L]ook for [R]esume' })
vim.keymap.set('n', '<leader>l.', builtin.oldfiles, { desc = '[L]ook for Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>lc', builtin.commands, { desc = '[L]ook for [C]ommands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
    vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})

vim.keymap.set(
  'n',
  '<leader>/',
  function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end,
  { desc = '[/] Fuzzily search in current buffer' }
)

vim.keymap.set(
  'n',
  '<leader>l/',
  function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end,
  { desc = '[L]ook for [/] in Open Files' }
)

vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
