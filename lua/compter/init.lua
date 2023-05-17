local getMatched = function(str, pattern)
    local _, cursorCol = vim.api.nvim_win_get_cuirsor(0)
    for match in str:gmatch(pattern) do
        local start, finish = str:find(match, 1, true)
        if cursorCol >= start and cursorCol <= finish then
            return match
        end
    end
    return nil
end

