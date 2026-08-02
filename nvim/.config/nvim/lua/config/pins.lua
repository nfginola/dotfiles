-- Pin files/positions for quick jumping. Each project (cwd) gets its own
-- private set of pins, persisted to disk so they survive closing nvim.
-- Native vim marks aren't used here since they're shared across every nvim
-- session via one global shada file, not scoped per project.
--
-- <Leader>m{a-z}  Pin the cursor position to slot {A-Z}
-- <Leader>j{a-z}  Jump to the pin at slot {A-Z}
-- <Leader>Ml      List all pins; selecting one clears it
-- <Leader>Mn      List all pins; selecting one (re)names it
-- <Leader>Ma      Clear all pins
--
-- Group labels for the which-key popup live in plugins/qol.lua, next to
-- where the which-key plugin itself is configured.

local M = {}

local pins = {} ---@type table<string, { file: string, line: integer, name?: string }>

---@return string path to this project's pin data file
local function data_path()
	local dir = vim.fn.stdpath('data') .. '/pins'
	vim.fn.mkdir(dir, 'p')
	local safe_cwd = vim.fn.getcwd():gsub('[/\\:]', '%%')
	return dir .. '/' .. safe_cwd .. '.json'
end

local function load()
	local ok, content = pcall(vim.fn.readfile, data_path())
	if not ok then
		return
	end
	local decode_ok, decoded = pcall(vim.json.decode, table.concat(content, '\n'))
	if decode_ok and type(decoded) == 'table' then
		pins = decoded
	end
end

local function save()
	vim.fn.writefile({ vim.json.encode(pins) }, data_path())
end

---@return { letter: string, file: string, line: integer, name?: string }[]
local function get_pinned_marks()
	local marks = {}
	for letter, pin in pairs(pins) do
		table.insert(marks, { letter = letter, file = pin.file, line = pin.line, name = pin.name })
	end
	table.sort(marks, function(a, b) return a.letter < b.letter end)
	return marks
end

---@return string[] items formatted as "[LETTER] name  path:line"
local function format_marks(marks)
	local items = {}
	for _, m in ipairs(marks) do
		local label = m.name and (m.name .. '  ') or ''
		table.insert(items, string.format('[%s] %s%s:%d', m.letter, label, vim.fn.fnamemodify(m.file, ':~:.'), m.line))
	end
	return items
end

local function set_pin_keymaps()
	for byte = string.byte('a'), string.byte('z') do
		local letter = string.char(byte)
		local upper = letter:upper()

		vim.keymap.set('n', '<Leader>m' .. letter, function()
			-- Re-pinning the same slot keeps its existing name.
			local existing_name = pins[upper] and pins[upper].name
			pins[upper] = { file = vim.fn.expand('%:p'), line = vim.fn.line('.'), name = existing_name }
			save()
			vim.notify('Pinned to [' .. upper .. ']: ' .. vim.fn.expand('%:~:.'))
		end, { desc = 'Pin file to slot ' .. upper })

		vim.keymap.set('n', '<Leader>j' .. letter, function()
			local pin = pins[upper]
			if not pin then
				vim.notify('No pin at [' .. upper .. ']', vim.log.levels.WARN)
				return
			end
			if vim.fn.expand('%:p') ~= pin.file then
				vim.cmd('edit ' .. vim.fn.fnameescape(pin.file))
			end
			local line = math.min(pin.line, vim.api.nvim_buf_line_count(0))
			vim.api.nvim_win_set_cursor(0, { line, 0 })
			vim.notify(pin.name and ('Jumped to [' .. upper .. ']: ' .. pin.name) or 'Jumped to unnamed mark')
		end, { desc = 'Jump to slot ' .. upper })
	end
end

---Open a centered floating scratch window showing `lines`.
---@param lines string[]
---@param title string
---@return integer win
---@return integer buf
local function float_show(lines, title)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, #line)
	end
	width = math.min(width + 2, math.floor(vim.o.columns * 0.6))

	local win = vim.api.nvim_open_win(buf, false, {
		relative = 'editor',
		width = width,
		height = #lines,
		row = math.floor((vim.o.lines - #lines) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = 'minimal',
		border = 'rounded',
		title = title,
		title_pos = 'center',
	})
	return win, buf
end

---Show the pin list, wait for a single keystroke, close the float, and
---return the picked mark (nil if cancelled with Esc or an unknown key).
---@param marks { letter: string, file: string, line: integer, name?: string }[]
---@param title string
---@param footer string
---@return { letter: string, file: string, line: integer, name?: string }?
local function pick_mark(marks, title, footer)
	local lines = format_marks(marks)
	table.insert(lines, '')
	table.insert(lines, footer)
	local win = float_show(lines, title)
	vim.cmd('redraw')

	local ok, char = pcall(vim.fn.getcharstr)

	if vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end

	if not ok or char == '\27' then -- Esc cancels
		return nil
	end

	local letter = char:upper()
	for _, m in ipairs(marks) do
		if m.letter == letter then
			return m
		end
	end
	vim.notify('No pin at [' .. letter .. ']', vim.log.levels.WARN)
	return nil
end

local function set_manage_keymaps()
	-- Show the pin list, then a single keystroke picks which one to clear
	-- (jumping is still <Leader>j{a-z})
	vim.keymap.set('n', '<Leader>Ml', function()
		local marks = get_pinned_marks()
		if #marks == 0 then
			vim.notify('No pins set', vim.log.levels.INFO)
			return
		end

		local mark = pick_mark(marks, ' Pinned marks ', 'Press the key to clear (Esc to cancel)')
		if not mark then
			return
		end
		pins[mark.letter] = nil
		save()
		vim.notify('Cleared pin [' .. mark.letter .. ']')
	end, { desc = 'List / clear a pin' })

	-- Show the pin list, then a single keystroke picks which one to (re)name
	vim.keymap.set('n', '<Leader>Mn', function()
		local marks = get_pinned_marks()
		if #marks == 0 then
			vim.notify('No pins set', vim.log.levels.INFO)
			return
		end

		local mark = pick_mark(marks, ' Pinned marks ', 'Press the key to name (Esc to cancel)')
		if not mark then
			return
		end
		local name = vim.fn.input('Name for pin [' .. mark.letter .. ']: ', mark.name or '')
		pins[mark.letter].name = name ~= '' and name or nil
		save()
		vim.notify('Pin [' .. mark.letter .. '] named "' .. name .. '"')
	end, { desc = 'List / name a pin' })

	-- Clear every pin
	vim.keymap.set('n', '<Leader>Ma', function()
		pins = {}
		save()
		vim.notify('Cleared all pins')
	end, { desc = 'Clear all pins' })
end

function M.setup()
	load()
	set_pin_keymaps()
	set_manage_keymaps()
end

M.setup()

return M
