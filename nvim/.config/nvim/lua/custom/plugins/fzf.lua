return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',

      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Help:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?

    require('telescope').setup {
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            width = { padding = 0 },
            height = { padding = 0 },
            preview_width = 0.5,
          },
        },
        sorting_strategy = 'ascending',
        border = false,
        file_ignore_patterns = {
          '^node_modules/',
          '^%.git/',
          '^%.cache/',
          '%.lock$',
          '%.env$',
        },

        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>lh', builtin.help_tags, { desc = '[L]ook for [H]elp' })
    vim.keymap.set('n', '<leader>lk', builtin.keymaps, { desc = '[L]ook for [K]eymaps' })
    vim.keymap.set('n', '<leader>ls', builtin.builtin, { desc = '[L]ook for [S]elect Telescope' })
    vim.keymap.set('n', '<leader>lw', builtin.grep_string, { desc = '[L]ook for current [W]ord' })
    vim.keymap.set('n', '<leader>ls', builtin.git_status, { desc = '[L]ook for [S]taging' })
    vim.keymap.set('n', '<leader>lc', builtin.git_commits, { desc = '[L]ook for [C]commit' })
    vim.keymap.set('n', '<leader>lt', builtin.git_bcommits, { desc = '[L]ook for [T]his file history' })
    vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = '[L]ook for by [G]rep' })
    vim.keymap.set('n', '<leader>ld', builtin.diagnostics, { desc = '[L]ook for [D]iagnostics' })
    vim.keymap.set('n', '<leader>lb', builtin.git_branches, { desc = '[L]ook for [B]ranches' })
    vim.keymap.set('n', '<leader>lr', builtin.resume, { desc = '[L]ook for [R]esume' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ]Look for Recent Files ("." for repeat)' })
    vim.keymap.set(
      'n',
      '<leader>la',
      ':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
      { noremap = true, silent = true, desc = 'Look for [A]ll files' }
    )

    vim.keymap.set(
      'n',
      '<Leader>lf',
      ':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
      { noremap = true, silent = true, desc = '[S]earch [F]iles' }
    )

    vim.keymap.set('n', '<leader>gd', function()
      require('config.telescope.diff_branch').diff_status()
    end, { desc = 'Live grep diff between branches' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
