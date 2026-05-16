-- Create a :command to write quickfix list to file
vim.api.nvim_create_user_command("Wqf", function(opts)
    local filename = opts.args
    if filename == "" then
        print("Usage: :Wqf <filename>")
        return
    end

    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
        print("Quickfix list is empty!")
        return
    end

    local lines = {}
    for _, item in ipairs(qflist) do
		local bufname = vim.fn.bufname(item.bufnr) -- Must derive file name from bufnr
        local lnum = item.lnum or 0
        local col = item.col or 0
        local text = (item.text or ""):gsub("\n", " ")
        table.insert(lines, string.format("%s:%d:%d:%s", bufname, lnum, col, text))
    end

    vim.fn.writefile(lines, filename)
    print("Quickfix list saved to " .. filename .. ". Use :cfile " .. filename .. " to load")
end, { nargs = 1, desc = "Write quickfix list to file. :cfile <file> to load" })
