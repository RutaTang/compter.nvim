-- Get matched content from current line
-- @param pattern: regex pattern, e.g. [[\d\{2}/\d\{2}/\d\{4}]]
-- @param cursorRow: cursor row
-- @param cursorCol: cursor column
-- @return: {content, start, finish} (inclusively) or nil
local getMatched = function(pattern, cursorRow, cursorCol)
    local regex = vim.regex(pattern)
    local originalLine = vim.fn.getline(cursorRow)
    local searchStart = 1
    while true do
        local line = string.sub(originalLine, searchStart)
        local mStart, mEnd = regex:match_str(line) -- index from 0
        if mStart == nil or mEnd == nil then
            return nil
        end
        -- update mStart and mEnd while considering searchStart
        mStart = mStart + searchStart
        mEnd = mEnd + searchStart -- exclusive
        -- check if cursor in matched range
        if cursorCol >= mStart and cursorCol < mEnd then
            return { string.sub(originalLine, mStart, mEnd - 1), mStart, mEnd - 1 }
        end
        -- update searchStart
        searchStart = mEnd
    end
end

-- Sort templates by priority, in place
-- Priority is in descending order
-- @param templates: templates to sort
local sortTemplatesByPriority = function(templates)
    table.sort(templates, function(a, b)
        return a.priority > b.priority
    end)
end

local config = {
    -- templates for increase and decrease
    -- @param pattern: regex pattern, e.g. [[\d\{2}/\d\{2}/\d\{4}]]
    -- @param increase: function(content) -> newContent, handled, e.g. function(content) return content + 1, true end
    -- @param decrease: function(content) -> newContent, handled, e.g. function(content) return content - 1, true end
    templates = {},
}

-- Operate on matched content
-- @param pattern: regex pattern, e.g. [[\d\{2}/\d\{2}/\d\{4}]]
-- @param op: function(content) -> newContent, handled, e.g. function(content) return content + 1, true end
-- @return: true if handled, false otherwise
local operate = function(pattern, op)
    -- get cursor position
    local cursorRow = vim.fn.line(".")
    local cursorCol = vim.fn.col(".")
    -- get current line
    local line = vim.fn.getline(cursorRow)
    -- get matched content: {content, start, finish} or nil
    local matched = getMatched(pattern, cursorRow, cursorCol)
    if matched then
        local start, finish = matched[2], matched[3]
        -- get count and set it default to 1
        local count = vim.v.count
        if count == 0 then
            count = 1
        end
        -- get new content after count operate, and check if it is handled
        local newContent, handled = op(matched[1])
        if not handled then
            return false
        end
        for i = 1, count - 1 do
            newContent, handled = op(newContent)
            if not handled then
                return false
            end
        end
        -- replace new content
        local newLine = line:sub(1, start - 1) .. newContent .. line:sub(finish + 1)
        -- set new line
        vim.api.nvim_set_current_line(newLine)
        -- return true to stop other operation
        return true
    end
    return false
end

local increase = function()
    for _, template in ipairs(config.templates) do
        if operate(template.pattern, template.increase) then
            return
        end
    end
    vim.cmd("normal!" .. (vim.v.count == 0 and 1 or vim.v.count) .. "")
end

local decrease = function()
    for _, template in ipairs(config.templates) do
        if operate(template.pattern, template.decrease) then
            return
        end
    end
    vim.cmd("normal!" .. (vim.v.count == 0 and 1 or vim.v.count) .. "")
end

local setup = function(opts)
    -- replace default keymap of <C-a> and <C-x>
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
    -- merge templates
    config = vim.tbl_deep_extend("force", config, opts or {})
    -- sort templates by priority
    sortTemplatesByPriority(config.templates)
end

return {
    setup = setup,
    increase = increase,
    decrease = decrease,
}
