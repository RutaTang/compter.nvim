local getMatched = function(str, pattern, cursorCol)
    for match in str:gmatch(pattern) do
        local start, finish = str:find(match, 1, true)
        if cursorCol >= start and cursorCol <= finish then
            return { match, start, finish }
        end
    end
    return nil
end

local increase = function()
    local cursorRow = vim.fn.line(".")
    local cursorCol = vim.fn.col(".")
    local line = vim.api.nvim_get_current_line()
    local matched = getMatched(line, "-?%d+", cursorCol)
    if matched then
        local num = tonumber(matched[1])
        local start, finish = matched[2], matched[3]
        local count = vim.v.count
        local newNum = num
        if count > 0 then
            newNum = num + count
        else -- count == 0
            newNum = num + 1
        end
        local newLine = line:sub(1, start - 1) .. newNum .. line:sub(finish + 1)
        vim.api.nvim_set_current_line(newLine)
    end
end

local decrease = function()
    local cursorRow = vim.fn.line(".")
    local cursorCol = vim.fn.col(".")
    local line = vim.api.nvim_get_current_line()
    local matched = getMatched(line, "-?%d+", cursorCol)
    if matched then
        local num = tonumber(matched[1])
        local start, finish = matched[2], matched[3]
        local count = vim.v.count
        local newNum = num
        if count > 0 then
            newNum = num - count
        else -- count == 0
            newNum = num - 1
        end
        local newLine = line:sub(1, start - 1) .. newNum .. line:sub(finish + 1)
        vim.api.nvim_set_current_line(newLine)
    end
end

local setup = function(opts)
    vim.api.nvim_set_keymap(
        "n",
        "<C-a>",
        "<cmd>lua require('compter').increase()<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap(
        "n",
        "<C-x>",
        "<cmd>lua require('compter').decrease()<CR>",
        { noremap = true, silent = true }
    )
end

return {
    setup = setup,
    increase = increase,
    decrease = decrease,
}
