return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
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
    vim.keymap.set('n', '<leader>l.', builtin.oldfiles, { desc = '[L]ook for Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set(
      'n',
      '<leader>la',
      ':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
      { noremap = true, silent = true, desc = 'Look for [A]ll files' }
    )

    vim.keymap.set('n', '<leader>lf', function()
      vim.fn.system 'git rev-parse --is-inside-work-tree'
      if vim.v.shell_error == 0 then
        builtin.git_files()
      else
        builtin.find_files()
      end
    end, { desc = '[S]earch [F]iles' })

    -- In your main config file or keymap file
    vim.keymap.set('n', '<leader>gd', function()
      require('config.telescope.diff_branch').diff_status()
    end, { desc = 'Live grep diff between branches' })

    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
