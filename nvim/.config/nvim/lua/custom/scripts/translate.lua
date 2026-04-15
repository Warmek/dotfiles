local function show_text_floating()
  local mode = vim.fn.mode()
  local text = ''

  -- Get text based on mode
  if mode == 'v' or mode == 'V' or mode == '\22' then
    vim.cmd 'normal! "vy'
    text = vim.fn.getreg 'v'
  else
    text = vim.fn.expand '<cword>'
  end

  if text and text ~= '' then
    -- Run translation command
    local command = "trans -brief '" .. text:gsub("'", "'\\''") .. "'"
    local handle = io.popen(command)
    if not handle then
      return
    end

    local result = handle:read '*a'
    handle:close()

    -- Clean up the result and split into lines
    result = result:gsub('^%s*(.-)%s*$', '%1') -- trim whitespace
    local lines = vim.split(result, '\n')

    -- Calculate window dimensions
    local max_width = 0
    for _, line in ipairs(lines) do
      if #line > max_width then
        max_width = #line
      end
    end
    local width = math.max(max_width, 10)
    local height = #lines

    -- Create a temporary, unlisted, scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Define window configuration
    local win_opts = {
      relative = 'cursor',
      row = -1,
      col = 0,
      width = width,
      height = height,
      style = 'minimal',
      border = 'rounded',
      title = ' Translation ',
      title_pos = 'center',
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Set buffer options so it can be easily closed
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true })
    vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, silent = true })
  else
    vim.notify('No text under cursor', vim.log.levels.WARN)
  end
end

vim.keymap.set({ 'n', 'v' }, '<leader>st', show_text_floating, {
  desc = 'Translate text under cursor/selection in float',
})
