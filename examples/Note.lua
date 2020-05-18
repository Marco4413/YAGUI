
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- SETTINGS

local default_name = "new"
local default_extension = ".txt"

local WSS_broadcast_interval = 1
local FPS = 20
local EPS = 6
local loop_stats = true

local SH_timeout = 0.5

local cursor_char = string.char(149)
local cursor_blinking_speed = 0.5
local cursor_color = colors.white
local cursor_background_color = nil

local text_color = colors.white
local editor_background = colors.black

local background_color = colors.gray
local lighter_background_color = colors.lightGray

-- PINK IS CONVERTED TO RGB: 119, 119, 119
local hover_color = colors.pink

local special_button_active_color = colors.green
local special_button_hover_color = colors.orange
local special_button_not_active_color = colors.red

local keywords_highlight_color = colors.yellow
local API_highlight_color = colors.blue
local YAGUI_highlight_color = colors.orange

local comment_highlight_color = colors.green
local string_highlight_color = colors.red

local shadows = true
local memo_borders = true

local syntax_highlight_enabled = true

-- END OF SETTINGS

local native_palette = {}
for key, value in next, colors do
    if type(value) == "number" then
        native_palette[value] = {term.getPaletteColor(value)}
    end
end

local default_path = default_name..default_extension
local current_file_path = shell.resolve(default_path)
local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local tArgs = {...}

YAGUI.screen_buffer.buffer.background.background = background_color
YAGUI.screen_buffer.buffer.background.foreground = background_color

-- Layout is only used to be able to make this program compatible with all computers (pockets, turtles and normal computers)
--  It has nothing to do with YAGUI
local LAYOUT = {}

-- These tables contain words to be highlighted
local words_highlight = {}

local function add_to_highlight(tbl, col)
    for key, word in next, tbl do
        words_highlight[word] = col
    end
end

add_to_highlight(
    {
        "and",
        "break",
        "do",
        "else",
        "elseif",
        "end",
        "false",
        "for",
        "function",
        "if",
        "in",
        "local",
        "nil",
        "not",
        "or",
        "repeat",
        "return",
        "then",
        "true",
        "until",
        "while"
    }, keywords_highlight_color
)
add_to_highlight(
    {
        "bit",
        "colors",
        "colours",
        "commands",
        "coroutine",
        "disk",
        "fs",
        "gps",
        "help",
        "http",
        "io",
        "keys",
        "math",
        "multishell",
        "os",
        "paintutils",
        "parallel",
        "peripheral",
        "rednet",
        "redstone",
        "rs",
        "settings",
        "shell",
        "string",
        "table",
        "term",
        "textutils",
        "turtle",
        "pocket",
        "vector",
        "window",
        "YAGUI"
    }, API_highlight_color
)
add_to_highlight(
    {
        "info",
        "generic_utils",
        "string_utils",
        "math_utils",
        "table_utils",
        "color_utils",
        "event_utils",
        "setting_utils",
        "monitor_utils",
        "screen_buffer",
        "input",
        "gui_elements",
        "WSS",
        "wireless_screen_share",
        "FT",
        "file_transfer",
        "Loop",
        "self"
    }, YAGUI_highlight_color
)

-- Creating elements

-- Creating loops
local lMain      = YAGUI.Loop(FPS, EPS)
local lInput     = YAGUI.Loop(FPS, EPS)
local lOverWrite = YAGUI.Loop(FPS, EPS)

local loops = {
    [ "main" ] = lMain,
    [ "input" ] = lInput,
    [ "overwrite" ] = lOverWrite
}

-- Creating WSS (Wireless Screen Share)
local WSS = YAGUI.WSS(WSS_broadcast_interval)

-- Creating main loop elements
local lLines    = YAGUI.gui_elements.Label(0, 0, "Lines: 0", text_color)
local lCursor   = YAGUI.gui_elements.Label(0, 0, "Cursor: (1; 1)", text_color)
local bCompact  = YAGUI.gui_elements.Button(0, 0, 0, 0, "C", text_color, special_button_active_color, special_button_not_active_color, special_button_hover_color)
local mEditor   = YAGUI.gui_elements.Memo(0, 0, 0, 0, text_color, editor_background)
local lPath     = YAGUI.gui_elements.Label(0, 0, "/path/", text_color)
local cSHL      = YAGUI.gui_elements.Clock(SH_timeout)

bCompact.hold = true
bCompact.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI.KEY_LEFTSHIFT, YAGUI.KEY_C}

mEditor.cursor.text = cursor_char
mEditor.cursor.blink.interval = cursor_blinking_speed
mEditor.colors.cursor = cursor_background_color
mEditor.colors.cursor_text = cursor_color

mEditor.border = memo_borders
mEditor.colors.border_color = background_color

cSHL.oneshot = true

-- Creating elements that will make File menu
local bFile     = YAGUI.gui_elements.Button(0, 0, 0, 0, "File", text_color, lighter_background_color, background_color, hover_color)
local wFileMenu = YAGUI.gui_elements.Window(0, 0, 0, 0, background_color, shadows)
local bNewOpen  = YAGUI.gui_elements.Button(0, 0, 0, 0, "New/Open", text_color, lighter_background_color, background_color, hover_color)
local bSave     = YAGUI.gui_elements.Button(0, 0, 0, 0, "Save"    , text_color, lighter_background_color, background_color, hover_color)
local bSaveAs   = YAGUI.gui_elements.Button(0, 0, 0, 0, "SaveAs"  , text_color, lighter_background_color, background_color, hover_color)
local bDelete   = YAGUI.gui_elements.Button(0, 0, 0, 0, "Delete"  , text_color, lighter_background_color, background_color, hover_color)
local bGoto     = YAGUI.gui_elements.Button(0, 0, 0, 0, "Goto"    , text_color, lighter_background_color, background_color, hover_color)
local bRun      = YAGUI.gui_elements.Button(0, 0, 0, 0, "Run"     , text_color, lighter_background_color, background_color, hover_color)
local bSHL      = YAGUI.gui_elements.Button(0, 0, 0, 0, "SyntaxHL", text_color, lighter_background_color, background_color, hover_color)
local bQuit     = YAGUI.gui_elements.Button(0, 0, 0, 0, "Exit"    , text_color, special_button_active_color, special_button_not_active_color, special_button_hover_color)

wFileMenu.draw_priority = YAGUI.LOW_PRIORITY
wFileMenu.hidden = true
wFileMenu.dragging.enabled = false
wFileMenu.resizing.enabled = false
wFileMenu:set_elements({bNewOpen, bSave, bSaveAs, bDelete, bGoto, bRun, bSHL, bQuit})

bNewOpen.hold = true
bSave.hold = true
bSaveAs.hold = true
bDelete.hold = true
bGoto.hold = true
bRun.hold = true
bQuit.hold = true

bFile.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI.KEY_TAB}
bSHL.active = syntax_highlight_enabled

-- Creating elements for loop lInput
local lInputTitle = YAGUI.gui_elements.Label(0, 0, "", text_color)
local mInput      = YAGUI.gui_elements.Memo(0, 0, 0, 0, text_color, lighter_background_color)
local lInputTip   = YAGUI.gui_elements.Label(0, 0, "You can press CONTROL to cancel.", text_color)

mInput.limits = YAGUI.math_utils.Vector2(0, 1)
mInput.cursor.text = cursor_char
mInput.cursor.blink.interval = cursor_blinking_speed
mInput.colors.cursor = cursor_background_color
mInput.colors.cursor_text = cursor_color

mInput.border = memo_borders
mInput.colors.border_color = background_color


-- Creating elements for OverWrite loop
local wOverWrite = YAGUI.gui_elements.Window(0, 0, 0, 0, lighter_background_color, shadows)
local lOW        = YAGUI.gui_elements.Label(0, 0, "Do you want\nto overwrite?", text_color)
local bOWAccept  = YAGUI.gui_elements.Button(0, 0, 0, 0, "Yes", text_color, background_color, lighter_background_color, hover_color)
local bOWReject  = YAGUI.gui_elements.Button(0, 0, 0, 0, "No", text_color, background_color, lighter_background_color, hover_color)

wOverWrite:set_elements({lOW, bOWAccept, bOWReject})

bOWAccept.hold = true
bOWReject.hold = true

bOWAccept.shortcut = {YAGUI.KEY_Y}
bOWReject.shortcut = {YAGUI.KEY_N}

lOW.text_alignment = YAGUI.ALIGN_CENTER

-- Defining functions

local function generate_layout()
    local w, h = term.getSize()
    local templates = {
        [ "all" ] = {
            lLines   = function () return 9, 1; end,
            lCursor  = function () return w - 5, 1, YAGUI.ALIGN_RIGHT; end,
            bCompact = function () return w, 1, 1, 1; end,
            mEditor  = function () return 2, 2, w - 1, h - 2; end,
            lPath    = function () return 1, h; end,

            bFile     = function () return 1, 1, 4, 1; end,
            wFileMenu = function () return 1, 2, 10, 8; end,
            bNewOpen  = function () return 1, 1, 10, 1; end,
            bSave     = function () return 1, 2, 10, 1; end,
            bSaveAs   = function () return 1, 3, 10, 1; end,
            bDelete   = function () return 1, 4, 10, 1; end,
            bGoto     = function () return 1, 5, 10, 1; end,
            bRun      = function () return 1, 6, 10, 1; end,
            bSHL      = function () return 1, 7, 10, 1; end,
            bQuit     = function () return 1, 8, 10, 1; end,

            lInputTitle = function () return 3, math.floor(h / 2 - 1); end,
            mInput      = function () return 2 + (memo_borders and 0 or 1), math.floor(h / 2) + (memo_borders and -1 or 0), w - 2 - (memo_borders and 0 or 2), 3 - (memo_borders and 0 or 2); end,
            lInputTip   = function () return 3, math.floor(h / 2 + 2), "You can press CONTROL to cancel."; end,

            wOverWrite = function () return math.floor(w / 2 - 7), math.floor(h / 2 - 3), 15, 6; end,
            lOW        = function () return 8, 2; end,
            bOWAccept  = function () return 2, 5, 3, 1; end,
            bOWReject  = function () return 13, 5, 2, 1; end,

            stats = function () return w - 1, h - 1; end
        },
        [ YAGUI.COMPUTER ] = {},
        [ YAGUI.TURTLE ] = {},
        [ YAGUI.POCKET ] = {
            lCursor  = function () return 1, h - 1, YAGUI.ALIGN_LEFT; end,
            mEditor  = function () return 2, 2, w - 1, h - 3; end,
            lPath    = function () return 1, h; end,

            lInputTip   = function () return 3, math.floor(h / 2 + 2), "You can press\nCONTROL to cancel."; end,
        },
        [ "this_layout" ] = {}
    }
    
    local computer_type, advanced = YAGUI.generic_utils.get_computer_type()

    templates.this_layout = templates.all

    for key, func in next, templates[computer_type] do
        templates.this_layout[key] = func
    end

    LAYOUT = templates.this_layout
end

local function apply_layout()
    -- Main
    lLines.pos.x  , lLines.pos.y  = LAYOUT.lLines()
    lCursor.pos.x , lCursor.pos.y, lCursor.text_alignment = LAYOUT.lCursor()
    bCompact.pos.x, bCompact.pos.y, bCompact.size.x, bCompact.size.y = LAYOUT.bCompact()
    mEditor.pos.x , mEditor.pos.y , mEditor.size.x , mEditor.size.y  = LAYOUT.mEditor()
    lPath.pos.x   , lPath.pos.y   = LAYOUT.lPath()
    -- wFileMenu
    bFile.pos.x    , bFile.pos.y    , bFile.size.x    , bFile.size.y     = LAYOUT.bFile()
    wFileMenu.pos.x, wFileMenu.pos.y, wFileMenu.size.x, wFileMenu.size.y = LAYOUT.wFileMenu()
    bNewOpen.pos.x , bNewOpen.pos.y , bNewOpen.size.x , bNewOpen.size.y  = LAYOUT.bNewOpen()
    bSave.pos.x    , bSave.pos.y    , bSave.size.x    , bSave.size.y     = LAYOUT.bSave()
    bSaveAs.pos.x  , bSaveAs.pos.y  , bSaveAs.size.x  , bSaveAs.size.y   = LAYOUT.bSaveAs()
    bDelete.pos.x  , bDelete.pos.y  , bDelete.size.x  , bDelete.size.y   = LAYOUT.bDelete()
    bGoto.pos.x    , bGoto.pos.y    , bGoto.size.x    , bGoto.size.y     = LAYOUT.bGoto()
    bRun.pos.x     , bRun.pos.y     , bRun.size.x     , bRun.size.y      = LAYOUT.bRun()
    bSHL.pos.x     , bSHL.pos.y     , bSHL.size.x     , bSHL.size.y      = LAYOUT.bSHL()
    bQuit.pos.x    , bQuit.pos.y    , bQuit.size.x    , bQuit.size.y     = LAYOUT.bQuit()
    -- lInput
    lInputTitle.pos.x, lInputTitle.pos.y                 = LAYOUT.lInputTitle()
    mInput.pos.x     , mInput.pos.y, mInput.size.x, mInput.size.y = LAYOUT.mInput()
    lInputTip.pos.x  , lInputTip.pos.y  , lInputTip.text = LAYOUT.lInputTip()
    -- wOverwrite
    wOverWrite.pos.x, wOverWrite.pos.y, wOverWrite.size.x, wOverWrite.size.y = LAYOUT.wOverWrite()
    wOverWrite.resizing.min_size = wOverWrite.size:duplicate()
    wOverWrite.resizing.max_size = wOverWrite.size:duplicate() * 2
    
    lOW.pos.x       , lOW.pos.y = LAYOUT.lOW()
    bOWAccept.pos.x , bOWAccept.pos.y , bOWAccept.size.x , bOWAccept.size.y  = LAYOUT.bOWAccept()
    bOWReject.pos.x , bOWReject.pos.y , bOWReject.size.x , bOWReject.size.y  = LAYOUT.bOWReject()
    lOW.offset = YAGUI.math_utils.Vector2.new(0, YAGUI.math_utils.round(wOverWrite.size.y / 2) - lOW.pos.y)
    -- Loops
    for key, loop in next, loops do
        loop.stats.pos = YAGUI.math_utils.Vector2(LAYOUT.stats())
        loop.stats:update_pos()
    end
end

local function clear_all()
    for key, monitor in next, lMain.monitors do
        YAGUI.monitor_utils.better_clear(monitor)
        for color, rgb in next, native_palette do
            monitor.setPaletteColor(color, rgb[1], rgb[2], rgb[3])
        end
    end
end

local function remove_highlight()
    mEditor.rich_text = {}
    if mEditor.focussed then
        mEditor.rich_text[mEditor.cursor.pos.y] = {
            ["background"] = background_color
        }
    end
end

local syntax_highlight_cache = {}

local function SH_sub(tbl, from)
    for i=from + 1, #tbl do
        tbl[i] = nil
    end
end
local function SH_rep(tbl, char, times)
    local tbl_len = #tbl
    for i=tbl_len + 1, times + tbl_len do
        tbl[i] = char
    end
end

local function syntax_highlight(from, to)
    local text_paint = YAGUI.color_utils.colors[text_color]
    local comment_paint = YAGUI.color_utils.colors[comment_highlight_color]
    local string_paint = YAGUI.color_utils.colors[string_highlight_color]

    from = from or mEditor.first_visible_line
    to = to or (mEditor.first_visible_line + mEditor.size.y - 1)
    
    local state = "code"
    local nested_state = "none"
    local quote_ignore = false
    local current_quote = ""

    local prev_line_cache = syntax_highlight_cache[from - 1]
    if prev_line_cache then
        state = prev_line_cache.state
        nested_state = prev_line_cache.nested_state
        quote_ignore = prev_line_cache.quote_ignore
        current_quote = prev_line_cache.current_quote
    end

    for y=from, to do
        if not mEditor.rich_text[y] then
            mEditor.rich_text[y] = {}
        end

        local line = mEditor.lines[y]
        if not line then break; end

        local foreground = {}

        local words_in_line = YAGUI.string_utils.split(line, "[^%w_]")
        local x = 0
        for key, word in next, words_in_line do
            local color = words_highlight[word]
            if color then
                SH_rep(foreground, YAGUI.color_utils.colors[text_color], x - #foreground)
                SH_rep(foreground, YAGUI.color_utils.colors[color], #word)
            end
            
            x = x + #word + 1
        end
        foreground[#foreground + 1] = text_paint


        for char_key=1, #line do
            if not foreground[char_key] then foreground[char_key] = text_paint; end
            local char = line:sub(char_key, char_key)
            if state == "code" then
                if char == "\"" then
                    foreground[char_key] = string_paint
                    if char_key ~= #line then
                        state = "string"
                        current_quote = "\""
                    end
                elseif char == "'" then
                    foreground[char_key] = string_paint
                    if char_key ~= #line then
                        state = "string"
                        current_quote = "'"
                    end
                elseif line:sub(char_key, char_key + 1) == "[[" then
                    state = "long-string"
                    foreground[char_key] = string_paint
                elseif line:sub(char_key, char_key + 1) == "--" then
                    if line:sub(char_key, char_key + 3) == "--[[" then
                        state = "closed-comment"
                        foreground[char_key] = comment_paint
                    else
                        state = "comment"
                        foreground[char_key] = comment_paint
                    end
                elseif char_key > #foreground then
                    foreground[char_key] = text_paint
                end
            elseif state == "string" then
                foreground[char_key] = string_paint
                if char == "\\" then
                    if char_key == #line then
                        nested_state = "multi-line"
                    else
                        local next_char = line:sub(char_key + 1, char_key + 1)
                        if next_char == current_quote then
                            quote_ignore = true
                        end
                    end
                elseif nested_state == "none" and (char_key == #line) then
                    quote_ignore = false
                    current_quote = ""
                    state = "code"
                elseif char == current_quote then
                    if quote_ignore then
                        quote_ignore = false
                    else
                        current_quote = ""
                        state = "code"
                        nested_state = "none"
                    end
                else
                    nested_state = "none"
                end
            elseif state == "long-string" then
                foreground[char_key] = string_paint
                if line:sub(char_key, char_key + 1) == "]]" then
                    foreground[char_key + 1] = string_paint
                    state = "code"
                end
            elseif state == "comment" then
                SH_sub(foreground, char_key - 1)
                state = "code"
                break
            elseif state == "closed-comment" then
                foreground[char_key] = comment_paint
                if line:sub(char_key, char_key + 1) == "]]" then
                    foreground[char_key + 1] = comment_paint
                    state = "code"
                end
            end
        end

        syntax_highlight_cache[y] = {
            ["state"] = state,
            ["nested_state"] = nested_state,
            ["quote_ignore"] = quote_ignore,
            ["current_quote"] = current_quote
        }

        mEditor.rich_text[y].foreground = table.concat(foreground)
    end
end

-- This functions opens a file from path, if file doesn't exist then it will create a new file
local function open_notes(path)
    path = shell.resolve(path)
    if #path:gsub(" ", "") == 0 then
        path = default_path
    end
    if YAGUI.string_utils.get_extension(path) == "" then
        path = path..default_extension
    end
    if fs.isDir(path) then return; end
    mEditor:clear()
    current_file_path = path
    if fs.exists(path) then
        local file = fs.open(path, "r")

        local ok = pcall(mEditor.write, mEditor, file.readAll())
        if not ok then
            clear_all()
            WSS:close()
            error("It took too long to open the file")
        end

        file.close()
    end
    mEditor:set_cursor(1, 1)
    
    if syntax_highlight_enabled then
        syntax_highlight(1)
    end
end

-- This functions saves mEditor content to a file
local function save_notes(path)
    path = shell.resolve(path)
    if #path:gsub(" ", "") == 0 then
        path = current_file_path
    end
    if fs.isDir(path) then return; end
    if fs.isReadOnly(path) then return; end

    current_file_path = path

    local file = fs.open(path, "w")

    file.write(table.concat(mEditor.lines, "\n"))

    file.close()
end

-- Setting callbacks

cSHL:set_callback(
    YAGUI.ONCLOCK,
    function (self)
        syntax_highlight(self.starting_line, #mEditor.lines)
        self.starting_line = nil
    end
)

-- Callbacks for wFileMenu
bFile:set_callback(
    YAGUI.ONPRESS,
    function (self)
        wFileMenu.hidden = not self.active
    end
)

wFileMenu:set_callback(
    YAGUI.ONFAILEDPRESS,
    function (self)
        if bFile.active then
            self.hidden = true
            bFile.active = false
        end
    end
)

bNewOpen:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        lInputTitle.text = " New File / Open File "
        mInput.bound = self
        lInput:start()
    end
)
bNewOpen.callbacks.onActionComplete = function (path)
    if path then
        path = shell.resolve(path)
        open_notes(path)
    else
        open_notes(default_path)
    end
end

bSave:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        save_notes(current_file_path)
    end
)

bSaveAs:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        lInputTitle.text = " Save File As "
        mInput.bound = self
        lInput:start()
    end
)
bSaveAs.callbacks.onActionComplete = function (path)
    if not path then path = current_file_path; end
    path = shell.resolve(path)
    if fs.exists(path) then
        bOWAccept.bound = bSaveAs
        bSaveAs.path = path
        lOverWrite:start()
    else
        save_notes(path)
    end
end
bSaveAs.callbacks.onOverWrite = function ()
    save_notes(bSaveAs.path)
    bSaveAs.path = nil
end

bDelete:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        if fs.isReadOnly(current_file_path) then return; end
        fs.delete(current_file_path)
    end
)

bGoto:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        lInputTitle.text = " Go to Line "
        mInput.bound = self
        mInput.whitelist = numbers
        lInput:start()
    end
)
bGoto.callbacks.onActionComplete = function (line)
    mEditor:set_cursor(1, tonumber(line) or mEditor.cursor.pos.y)
end

bRun:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        save_notes(current_file_path)
        local tab = shell.openTab(current_file_path)
        shell.switchTab(tab)
    end
)

bSHL:set_callback(
    YAGUI.ONPRESS,
    function (self)
        syntax_highlight_enabled = self.active
        if syntax_highlight_enabled then
            syntax_highlight(1)
        else
            remove_highlight()
        end
    end
)

bQuit:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        lMain:stop()
    end
)

-- Callbacks for loop lMain
bCompact:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        local lines_to_remove = {}
        for i=1, #mEditor.lines do
            local line = mEditor.lines[i]
            if not line then break; end
            local line_no_spaces = line:gsub(" ", "")
            if #line_no_spaces == 0 then
                table.insert(lines_to_remove, 1, i)
            end
        end

        for key, line_key in next, lines_to_remove do
            table.remove(mEditor.lines, line_key)
        end
        mEditor:set_cursor(1, 1)
        
        if syntax_highlight_enabled then
            syntax_highlight(1)
        end
    end
)

mEditor:set_callback(
    YAGUI.ONFOCUS,
    function (self)
        if not self.focussed then
            local rich_line = self.rich_text[self.cursor.pos.y]
            if rich_line and rich_line.foreground then
                rich_line.background = nil
            else
                self.rich_text[self.cursor.pos.y] = nil
            end
        end
    end
)

mEditor:set_callback(
    YAGUI.ONMOUSESCROLL,
    function (self)
        return true
    end
)

mEditor:set_callback(
    YAGUI.ONCURSORCHANGE,
    function (self, new_x, new_y)
        local old_rich_line = self.rich_text[self.cursor.pos.y]
        if old_rich_line and old_rich_line["foreground"] then
            old_rich_line["background"] = nil
        else
            self.rich_text[self.cursor.pos.y] = nil
        end

        if self.focussed then
            local new_rich_line = self.rich_text[new_y]
            if new_rich_line and new_rich_line["foreground"] then
                new_rich_line["background"] = background_color
            else
                self.rich_text[new_y] = {
                    ["background"] = background_color
                }
            end
        end
    end
)

mEditor:set_callback(
    YAGUI.ONWRITE,
    function (self, text, lines)
        if syntax_highlight_enabled then
            if cSHL.starting_line then
                cSHL.starting_line = math.min(cSHL.starting_line, math.max(1, self.cursor.pos.y - #lines + 1))
            else
                cSHL.starting_line = math.max(1, self.cursor.pos.y - #lines + 1)
            end
            cSHL:start()
        end
    end
)

lMain:set_callback(
    YAGUI.ONDRAW,
    function (self)
        lLines.text = string.format("Lines: %d", #mEditor.lines)
        lCursor.text = table.concat({"Cursor: ", tostring(mEditor.cursor.pos)})
        lPath.text = table.concat({"/", current_file_path})
    end
)

lMain:set_callback(
    YAGUI.ONEVENT,
    function (self, event)
        if YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_LEFTALT, YAGUI.KEY_S) then
            bSaveAs.callbacks.onPress(bSaveAs, event)
        elseif YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_N) then
            bNewOpen.callbacks.onPress(bNewOpen, event)
        elseif YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_S) then
            bSave.callbacks.onTimeout(bSave, event)
        elseif YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_G) then
            bGoto.callbacks.onPress(bGoto, event)
        elseif YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTALT, YAGUI.KEY_R) then
            bRun.callbacks.onTimeout(bRun, event)
        elseif  YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTSHIFT, YAGUI.KEY_B, YAGUI.KEY_S) then
            local screenshot = YAGUI.screen_buffer:frame_to_nft(1, 1, term.getSize())
            local file = fs.open("/Note-Screenshot.nftb", "wb")
            for i=1, #screenshot do
                local char = screenshot:sub(i, i)
                file.write(string.byte(char))
            end
            file.close()
        elseif  YAGUI.input:are_keys_pressed(true, YAGUI.KEY_LEFTSHIFT, YAGUI.KEY_S) then
            local file = fs.open("/Note-Screenshot.nft", "w")
            file.write(YAGUI.screen_buffer:frame_to_nft(1, 1, term.getSize()))
            file.close()
        elseif (not mEditor.focussed) then
            if YAGUI.input:are_keys_pressed(false, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_LEFT) then
                mEditor.first_visible_char = math.max(1, mEditor.first_visible_char - 1)
            elseif YAGUI.input:are_keys_pressed(false, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_RIGHT) then
                mEditor.first_visible_char = mEditor.first_visible_char + 1
            end
            if YAGUI.input:are_keys_pressed(false, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_UP) then
                mEditor.first_visible_line = math.max(1, mEditor.first_visible_line - 1)
            elseif YAGUI.input:are_keys_pressed(false, YAGUI.KEY_LEFTCTRL, YAGUI.KEY_DOWN) then
                mEditor.first_visible_line = math.min(#mEditor.lines, mEditor.first_visible_line + 1)
            end
        end

        if event.name == YAGUI.MOUSESCROLL then
            mEditor.first_visible_line = YAGUI.math_utils.constrain(mEditor.first_visible_line + event.direction, 1, #mEditor.lines)
        elseif event.name == YAGUI.TERMRESIZE then
            generate_layout()
            apply_layout()
        end

        if syntax_highlight_enabled and (mEditor.first_visible_line + mEditor.size.y - 1 > #syntax_highlight_cache) then
            syntax_highlight(#syntax_highlight_cache)
        end
    end
)

-- Callbacks for loop lInput
mInput:set_callback(
    YAGUI.ONKEY,
    function (self, event)
        if event.key == YAGUI.KEY_ENTER then
            self.bound.callbacks.onActionComplete(self.lines[1])
            lInput:stop()
            return true
        end
    end
)

lInput:set_callback(
    YAGUI.ONSTART,
    function (self)
        mInput:focus(true)
    end
)

lInput:set_callback(
    YAGUI.ONEVENT,
    function (self, event)
        if event.name == YAGUI.KEY then
            if event.key == YAGUI.KEY_LEFTCTRL or event.key == YAGUI.KEY_RIGHTCTRL then
                lInput:stop()
                return true
            end
        elseif event.name == YAGUI.TERMRESIZE then
            generate_layout()
            apply_layout()
        end
    end
)

lInput:set_callback(
    YAGUI.ONSTOP,
    function (self)
        mInput.bound = nil
        mInput.whitelist = {}
        mInput:clear()
        mInput:focus(false)
    end
)

-- Callbacks for loop lOverWrite
wOverWrite:set_callback(
    YAGUI.ONRESIZE,
    function (self, old_x, old_y, old_size_x, old_size_y)
        lOW.pos = YAGUI.math_utils.Vector2(self.size.x / 2, self.size.y / 2) - lOW.offset

        bOWAccept.pos.y = self.size.y - 1

        bOWReject.pos.x = self.size.x - 2
        bOWReject.pos.y = self.size.y - 1
    end
)

bOWAccept:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        self.bound.callbacks.onOverWrite()
        self.bound = nil
        lOverWrite:stop()
    end
)

bOWReject:set_callback(
    YAGUI.ONRELEASE,
    function (self)
        lOverWrite:stop()
    end
)

lOverWrite:set_callback(
    YAGUI.ONEVENT,
    function (self, event)
        if event.name == YAGUI.TERMRESIZE then
            generate_layout()
            apply_layout()
        end
    end
)

-- Main program

generate_layout()
apply_layout()

if #tArgs > 0 then

    if tArgs[1]:lower() == "help" then
        local lines = {
            { text = "Note <COMMAND>"                                           , foreground = colors.green , background = nil},
            { text = " - help (shows this list of commands)"                    , foreground = colors.blue  , background = nil},
            { text = " - open <PATH> (opens file at PATH)"                      , foreground = colors.yellow, background = nil},
            { text = " - multi <MONITORS> (sets MONITORS\n   as io for the app)", foreground = colors.green , background = nil},
            { text = " - wss <MODEM_SIDE> [BROADCAST_INTERVAL]\n   (hosts a WSS server using the modem\n   on MODEM_SIDE and updates connected users\n   every BROADCAST_INTERVAL seconds)", foreground = colors.blue  , background = nil}
        }
    
        for key, line in next, lines do
            YAGUI.monitor_utils.better_print(term, line.foreground, line.background, line.text)
        end
        return
    end

    local options = {
        open = {},
        multi = {},
        wss = {}
    }
    local current_option
    for key, value in next, tArgs do
        if current_option then
            table.insert(options[current_option], value)
        end
        local lower_value = value:lower()
        if lower_value ~= current_option and options[lower_value] then
            current_option = lower_value
        end
    end

    if #options.open > 0 then
        current_file_path = options.open[1]
    end
    if #options.multi > 0 then
        table.insert(options.multi, 1, "terminal")
        for key, loop in next, loops do
            loop:set_monitors(options.multi)
        end
    end
    if #options.wss > 0 then
        if options.wss[1] then
            local modem_side = options.wss[1]
            if peripheral.getType(modem_side) ~= "modem" then
                YAGUI.monitor_utils.better_print(term, colors.red, nil, "Modem: ", modem_side, " wasn't found.")
                return
            end
            WSS:use_side(modem_side)
            WSS:host()
            WSS.broadcast_clock.interval = tonumber(options.wss[2]) or WSS.broadcast_clock.interval
        end
    end
end

-- Opening notes
open_notes(current_file_path)

-- Setting up loops
lMain:set_elements({bFile, wFileMenu, lLines, lCursor, bCompact, mEditor, lPath, cSHL, WSS})
lInput:set_elements({lInputTitle, mInput, lInputTip, WSS})
lOverWrite:set_elements({wOverWrite, WSS})

for key, loop in next, loops do
    loop.stats.FPS_label.text_alignment = YAGUI.ALIGN_RIGHT
    loop.stats.EPS_label.text_alignment = YAGUI.ALIGN_RIGHT
    loop.stats:show(loop_stats)
    loop.options.raw_mode = true
    loop.options.stop_on_terminate = false
end
lMain.options.stop_on_terminate = true

-- Setting up palette
for key, monitor in next, lMain.monitors do
    monitor.setPaletteColor(colors.pink, 0.467, 0.467, 0.467)
end

-- Starting main loop
lMain:start()

-- Clearing all monitors
clear_all()

WSS:close()
