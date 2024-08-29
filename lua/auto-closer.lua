local auto_closer = {}

local prevCol

local function get_prev_col()
  prevCol=vim.api.nvim_win_get_cursor(0)[2]
end

local function check_insertion()
  local currCol=vim.api.nvim_win_get_cursor(0)[2]
  if prevCol<currCol then
    prevCol=currCol
    return true
  else
    prevCol=currCol
    return false
  end
end

local brackets={
  ["("]=")",
  ["["]="]",
  ["{"]="}"
}

local quotes={
  ["'"]={true},
  ['"']={true},
  ["`"]={true}
}

local function check_brackets()
  if not check_insertion() then
    return
  end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local char = line:sub(col, col)
  if brackets[char] then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(brackets[char], true, false, true), 'n', true)
  elseif quotes[char] then
    if quotes[char][1] then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(char, true, false, true), 'n', true)
    end
    quotes[char][1]=not quotes[char][1]
  end
  return
end

function auto_closer.setup()
  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = get_prev_col
  })
  vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = check_brackets
  })
end

return auto_closer

