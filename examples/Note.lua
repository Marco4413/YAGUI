
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
local FPS = 60
local EPS = 6
local loop_stats = true

local button_timeout = 0.5

local cursor_char = string.char(149)
local cursor_blinking_speed = 0.5
local cursor_color = colors.white
local cursor_background_color = nil

local text_color = colors.white
local editor_background = colors.black

local background_color = colors.gray
local lighter_background_color = colors.lightGray

local special_button_active_color = colors.green
local special_button_not_active_color = colors.red

local keywords_highlight_color = colors.yellow
local API_highlight_color = colors.blue
local YAGUI_highlight_color = colors.orange

local comment_highlight_color = colors.green
local string_highlight_color = colors.red

local shadows = true

local syntax_highlight_enabled = true

-- END OF SETTINGS

local default_path = default_name..default_extension
local current_file_path = shell.resolve(default_path)
local numbers = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local tArgs = {...}

YAGUI.screen_buffer.buffer.background = background_color

-- Layout is only used to be able to make this program compatible with all computers (pockets, turtles and normal computers)
--  It has nothing to do with YAGUI
local LAYOUT = {
    init = function (self)
        local computer_type, advanced = YAGUI.generic_utils.get_computer_type()

        self.this_layout = self.all

        for key, func in next, self[computer_type] do
            self.this_layout[key] = func
        end
    end,
    [ "all" ] = {
        lLines   = function () return 9, 1; end,
        lCursor  = function () return 46, 1, YAGUI.ALIGN_RIGHT; end,
        bCompact = function () return 51, 1, 1, 1; end,
        mEditor  = function () return 5, 2, 47, 17; end,
        lPath    = function () return 1, 19; end,

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

        lInputTitle = function () return 2, 9; end,
        mInput      = function () return 2, 10, 49, 1; end,
        lInputTip   = function () return 3, 12, "You can press CONTROL to cancel."; end,

        wOverWrite = function () return 18, 7, 15, 6; end,
        lOW        = function () return 8, 2; end,
        bOWAccept  = function () return 2, 5, 3, 1; end,
        bOWReject  = function () return 13, 5, 2, 1; end,

        stats = function () return 45, 18; end
    },
    [ YAGUI.COMPUTER ] = {},
    [ YAGUI.TURTLE ] = {
        lCursor  = function () return 34, 1, YAGUI.ALIGN_RIGHT; end,
        bCompact = function () return 39, 1, 1, 1; end,
        mEditor  = function () return 5, 2, 35, 11; end,
        lPath    = function () return 1, 13; end,
        
        lInputTitle = function () return 2, 5; end,
        mInput      = function () return 2, 6, 37, 1; end,
        lInputTip   = function () return 3, 8, "You can press CONTROL to cancel."; end,

        wOverWrite = function () return 12, 4, 15, 6; end,

        stats = function () return 33, 12; end
    },
    [ YAGUI.POCKET ] = {
        lCursor  = function () return 1, 19, YAGUI.ALIGN_LEFT; end,
        bCompact = function () return 26, 1, 1, 1; end,
        mEditor  = function () return 3, 2, 24, 17; end,
        lPath    = function () return 1, 20; end,

        mInput   = function () return 2, 10, 24, 1; end,
        lInputTip   = function () return 8, 12, "You can press\nCONTROL to cancel."; end,

        wOverWrite = function () return 6, 7, 15, 6; end,

        stats = function () return 21, 19; end
    },
    [ "this_layout" ] = {}
}

LAYOUT:init()

-- These tables contain words to be highlighted
local words_highlight = {}

local function add_to_highlight(tbl, col)
    if not words_highlight[col] then words_highlight[col] = {}; end
    for word, value in next, tbl do
        words_highlight[col][word] = value
    end
end

add_to_highlight(
    {
        ["and"] = true,
        ["break"] = true,
        ["do"] = true,
        ["else"] = true,
        ["elseif"] = true,
        ["end"] = true,
        ["false"] = true,
        ["for"] = true,
        ["function"] = true,
        ["if"] = true,
        ["in"] = true,
        ["local"] = true,
        ["nil"] = true,
        ["not"] = true,
        ["or"] = true,
        ["repeat"] = true,
        ["return"] = true,
        ["then"] = true,
        ["true"] = true,
        ["until"] = true,
        ["while"] = true
    }, keywords_highlight_color
)
add_to_highlight(
    {
        ["bit"] = true,
        ["colors"] = true,
        ["colours"] = true,
        ["commands"] = true,
        ["coroutine"] = true,
        ["disk"] = true,
        ["fs"] = true,
        ["gps"] = true,
        ["help"] = true,
        ["http"] = true,
        ["io"] = true,
        ["keys"] = true,
        ["math"] = true,
        ["multishell"] = true,
        ["os"] = true,
        ["paintutils"] = true,
        ["parallel"] = true,
        ["peripheral"] = true,
        ["rednet"] = true,
        ["redstone"] = true,
        ["rs"] = true,
        ["settings"] = true,
        ["shell"] = true,
        ["string"] = true,
        ["table"] = true,
        ["term"] = true,
        ["textutils"] = true,
        ["turtle"] = true,
        ["pocket"] = true,
        ["vector"] = true,
        ["window"] = true,
        ["YAGUI"] = true
    }, API_highlight_color
)
add_to_highlight(
    {
        ["info"] = true,
        ["generic_utils"] = true,
        ["string_utils"] = true,
        ["math_utils"] = true,
        ["table_utils"] = true,
        ["color_utils"] = true,
        ["event_utils"] = true,
        ["setting_utils"] = true,
        ["monitor_utils"] = true,
        ["screen_buffer"] = true,
        ["input"] = true,
        ["gui_elements"] = true,
        ["WSS"] = true,
        ["wireless_screen_share"] = true,
        ["FT"] = true,
        ["file_transfer"] = true,
        ["Loop"] = true,
        ["self"] = true
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
local bCompact  = YAGUI.gui_elements.Button(0, 0, 0, 0, "C", text_color, special_button_active_color, special_button_not_active_color)
local mEditor   = YAGUI.gui_elements.Memo(0, 0, 0, 0, text_color, editor_background)
local lPath     = YAGUI.gui_elements.Label(0, 0, "/path/", text_color)

-- Applying layout
lLines.pos.x  , lLines.pos.y  = LAYOUT.this_layout.lLines()
lCursor.pos.x , lCursor.pos.y, lCursor.text_alignment = LAYOUT.this_layout.lCursor()
bCompact.pos.x, bCompact.pos.y, bCompact.size.x, bCompact.size.y = LAYOUT.this_layout.bCompact()
mEditor.pos.x , mEditor.pos.y , mEditor.size.x , mEditor.size.y  = LAYOUT.this_layout.mEditor()
lPath.pos.x   , lPath.pos.y   = LAYOUT.this_layout.lPath()

bCompact.timed.enabled = true
bCompact.timed.clock.interval = button_timeout
bCompact.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI.KEY_LEFTSHIFT, YAGUI.KEY_C}

mEditor.cursor.text = cursor_char
mEditor.cursor.blink.interval = cursor_blinking_speed
mEditor.colors.cursor = cursor_background_color
mEditor.colors.cursor_text = cursor_color


-- Creating elements that will make File menu
local bFile     = YAGUI.gui_elements.Button(0, 0, 0, 0, "File", text_color, lighter_background_color, background_color)
local wFileMenu = YAGUI.gui_elements.Window(0, 0, 0, 0, background_color, shadows)
local bNewOpen  = YAGUI.gui_elements.Button(0, 0, 0, 0, "New/Open", text_color, lighter_background_color, background_color)
local bSave     = YAGUI.gui_elements.Button(0, 0, 0, 0, "Save"    , text_color, lighter_background_color, background_color)
local bSaveAs   = YAGUI.gui_elements.Button(0, 0, 0, 0, "SaveAs"  , text_color, lighter_background_color, background_color)
local bDelete   = YAGUI.gui_elements.Button(0, 0, 0, 0, "Delete"  , text_color, lighter_background_color, background_color)
local bGoto     = YAGUI.gui_elements.Button(0, 0, 0, 0, "Goto"    , text_color, lighter_background_color, background_color)
local bRun      = YAGUI.gui_elements.Button(0, 0, 0, 0, "Run"     , text_color, lighter_background_color, background_color)
local bSHL      = YAGUI.gui_elements.Button(0, 0, 0, 0, "SyntaxHL", text_color, lighter_background_color, background_color)
local bQuit     = YAGUI.gui_elements.Button(0, 0, 0, 0, "Exit"    , text_color, special_button_active_color, special_button_not_active_color)

-- Applying layout
bFile.pos.x    , bFile.pos.y    , bFile.size.x    , bFile.size.y     = LAYOUT.this_layout.bFile()
wFileMenu.pos.x, wFileMenu.pos.y, wFileMenu.size.x, wFileMenu.size.y = LAYOUT.this_layout.wFileMenu()
bNewOpen.pos.x , bNewOpen.pos.y , bNewOpen.size.x , bNewOpen.size.y  = LAYOUT.this_layout.bNewOpen()
bSave.pos.x    , bSave.pos.y    , bSave.size.x    , bSave.size.y     = LAYOUT.this_layout.bSave()
bSaveAs.pos.x  , bSaveAs.pos.y  , bSaveAs.size.x  , bSaveAs.size.y   = LAYOUT.this_layout.bSaveAs()
bDelete.pos.x  , bDelete.pos.y  , bDelete.size.x  , bDelete.size.y   = LAYOUT.this_layout.bDelete()
bGoto.pos.x    , bGoto.pos.y    , bGoto.size.x    , bGoto.size.y     = LAYOUT.this_layout.bGoto()
bRun.pos.x     , bRun.pos.y     , bRun.size.x     , bRun.size.y      = LAYOUT.this_layout.bRun()
bSHL.pos.x     , bSHL.pos.y     , bSHL.size.x     , bSHL.size.y      = LAYOUT.this_layout.bSHL()
bQuit.pos.x    , bQuit.pos.y    , bQuit.size.x    , bQuit.size.y     = LAYOUT.this_layout.bQuit()

wFileMenu.draw_priority = YAGUI.LOW_PRIORITY
wFileMenu.hidden = true
wFileMenu:set_elements({bNewOpen, bSave, bSaveAs, bDelete, bGoto, bRun, bSHL, bQuit})

bSave.timed.enabled = true
bSave.timed.clock.interval = button_timeout
bDelete.timed.enabled = true
bDelete.timed.clock.interval = button_timeout
bRun.timed.enabled = true
bRun.timed.clock.interval = button_timeout
bQuit.timed.enabled = true
bQuit.timed.clock.interval = button_timeout

bFile.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI.KEY_TAB}
bSHL.active = syntax_highlight_enabled

-- Creating elements for loop lInput
local lInputTitle = YAGUI.gui_elements.Label(0, 0, "", text_color)
local mInput      = YAGUI.gui_elements.Memo(0, 0, 0, 0, text_color, lighter_background_color)
local lInputTip   = YAGUI.gui_elements.Label(0, 0, "You can press CONTROL to cancel.", text_color)

-- Applying layout
lInputTitle.pos.x, lInputTitle.pos.y                 = LAYOUT.this_layout.lInputTitle()
mInput.pos.x     , mInput.pos.y, mInput.size.x, mInput.size.y = LAYOUT.this_layout.mInput()
lInputTip.pos.x  , lInputTip.pos.y  , lInputTip.text = LAYOUT.this_layout.lInputTip()

mInput.limits = YAGUI.math_utils.Vector2(0, 1)
mInput.cursor.text = cursor_char
mInput.cursor.blink.interval = cursor_blinking_speed
mInput.colors.cursor = cursor_background_color
mInput.colors.cursor_text = cursor_color


-- Creating elements for OverWrite loop
local wOverWrite = YAGUI.gui_elements.Window(0, 0, 0, 0, lighter_background_color, shadows)
local lOW        = YAGUI.gui_elements.Label(0, 0, "Do you want\nto overwrite?", text_color)
local bOWAccept  = YAGUI.gui_elements.Button(0, 0, 0, 0, "Yes", text_color, background_color, lighter_background_color)
local bOWReject  = YAGUI.gui_elements.Button(0, 0, 0, 0, "No", text_color, background_color, lighter_background_color)

-- Applying layout
wOverWrite.pos.x, wOverWrite.pos.y, wOverWrite.size.x, wOverWrite.size.y = LAYOUT.this_layout.wOverWrite()
wOverWrite.resizing.min_size = wOverWrite.size
wOverWrite.resizing.max_size = wOverWrite.size * 2

lOW.pos.x       , lOW.pos.y = LAYOUT.this_layout.lOW()
bOWAccept.pos.x , bOWAccept.pos.y , bOWAccept.size.x , bOWAccept.size.y  = LAYOUT.this_layout.bOWAccept()
bOWReject.pos.x , bOWReject.pos.y , bOWReject.size.x , bOWReject.size.y  = LAYOUT.this_layout.bOWReject()

wOverWrite:set_elements({lOW, bOWAccept, bOWReject})

bOWAccept.timed.enabled = true
bOWAccept.timed.clock.interval = button_timeout
bOWReject.timed.enabled = true
bOWReject.timed.clock.interval = button_timeout

bOWAccept.shortcut = {YAGUI.KEY_Y}
bOWReject.shortcut = {YAGUI.KEY_N}

lOW.text_alignment = YAGUI.ALIGN_CENTER
lOW.offset = YAGUI.math_utils.Vector2.new(0, YAGUI.math_utils.round(wOverWrite.size.y / 2) - lOW.pos.y)

-- Defining functions

local function clear_all()
    for key, monitor in next, lMain.monitors do
        YAGUI.monitor_utils.better_clear(monitor)
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

local function syntax_highlight(from, to)
    local text_paint = YAGUI.color_utils.colors[text_color]
    local comment_paint = YAGUI.color_utils.colors[comment_highlight_color]
    local string_paint = YAGUI.color_utils.colors[string_highlight_color]

    local function replace_char(str, x, char)
        return str:sub(0, x - 1)..char..str:sub(x + 1)
    end

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

        local foreground = ""

        local words_in_line = YAGUI.string_utils.split(line, "[^%w_]")
        local x = 0
        for key, word in next, words_in_line do
            for color, dictionary in next, words_highlight do
                if dictionary[word] then
                    foreground = foreground..string.rep(YAGUI.color_utils.colors[text_color], x - #foreground)..string.rep(YAGUI.color_utils.colors[color], #word)
                end
            end
            
            x = x + #word + 1
        end
        foreground = foreground..YAGUI.color_utils.colors[text_color]


        for char_key=1, #line do
            local char = line:sub(char_key, char_key)
            if state == "code" then
                if char == "\"" then
                    foreground = replace_char(foreground, char_key, string_paint)
                    if char_key ~= #line then
                        state = "string"
                        current_quote = "\""
                    end
                elseif char == "'" then
                    foreground = replace_char(foreground, char_key, string_paint)
                    if char_key ~= #line then
                        state = "string"
                        current_quote = "'"
                    end
                elseif line:sub(char_key, char_key + 1) == "[[" then
                    state = "long-string"
                    foreground = replace_char(foreground, char_key, string_paint)
                elseif line:sub(char_key, char_key + 1) == "--" then
                    if line:sub(char_key, char_key + 3) == "--[[" then
                        state = "closed-comment"
                        foreground = replace_char(foreground, char_key, comment_paint)
                    else
                        state = "comment"
                        foreground = replace_char(foreground, char_key, comment_paint)
                    end
                elseif char_key > #foreground then
                    foreground = replace_char(foreground, char_key, text_paint)
                end
            elseif state == "string" then
                foreground = replace_char(foreground, char_key, string_paint)
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
                foreground = replace_char(foreground, char_key, string_paint)
                if line:sub(char_key, char_key + 1) == "]]" then
                    foreground = replace_char(foreground, char_key + 1, string_paint)
                    state = "code"
                end
            elseif state == "comment" then
                foreground = foreground:sub(0, char_key - 1)
                state = "code"
                break
            elseif state == "closed-comment" then
                foreground = replace_char(foreground, char_key, comment_paint)
                if line:sub(char_key, char_key + 1) == "]]" then
                    foreground = replace_char(foreground, char_key + 1, comment_paint)
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

        mEditor.rich_text[y].foreground = foreground
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
    else
        local file = fs.open(path, "w")

        file.write("")

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

    file.write(YAGUI.string_utils.join(mEditor.lines, "\n"))

    file.close()
end

-- Setting callbacks

-- Callbacks for wFileMenu
YAGUI.generic_utils.set_callback(
    bFile,
    YAGUI.ONPRESS,
    function (self)
        wFileMenu.hidden = not self.active
    end
)

YAGUI.generic_utils.set_callback(
    wFileMenu,
    YAGUI.ONFAILEDPRESS,
    function (self)
        if bFile.active then
            self.hidden = true
            bFile.active = false
        end
    end
)

YAGUI.generic_utils.set_callback(
    bNewOpen,
    YAGUI.ONPRESS,
    function (self)
        self.active = false
        lInputTitle.text = "New File / Open File"
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

YAGUI.generic_utils.set_callback(
    bSave,
    YAGUI.ONTIMEOUT,
    function (self)
        save_notes(current_file_path)
    end
)

YAGUI.generic_utils.set_callback(
    bSaveAs,
    YAGUI.ONPRESS,
    function (self)
        self.active = false
        lInputTitle.text = "Save File As"
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

YAGUI.generic_utils.set_callback(
    bDelete,
    YAGUI.ONTIMEOUT,
    function (self)
        if fs.isReadOnly(current_file_path) then return; end
        fs.delete(current_file_path)
    end
)

YAGUI.generic_utils.set_callback(
    bGoto,
    YAGUI.ONPRESS,
    function (self)
        self.active = false
        lInputTitle.text = "Line"
        mInput.bound = self
        mInput.whitelist = numbers
        lInput:start()
    end
)
bGoto.callbacks.onActionComplete = function (line)
    mEditor:set_cursor(1, tonumber(line) or mEditor.cursor.pos.y)
end

YAGUI.generic_utils.set_callback(
    bRun,
    YAGUI.ONTIMEOUT,
    function (self)
        save_notes(current_file_path)
        local tab = shell.openTab(current_file_path)
        shell.switchTab(tab)
    end
)

YAGUI.generic_utils.set_callback(
    bSHL,
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

YAGUI.generic_utils.set_callback(
    bQuit,
    YAGUI.ONTIMEOUT,
    function (self)
        lMain:stop()
    end
)

-- Callbacks for loop lMain
YAGUI.generic_utils.set_callback(
    bCompact,
    YAGUI.ONTIMEOUT,
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

YAGUI.generic_utils.set_callback(
    mEditor,
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

YAGUI.generic_utils.set_callback(
    mEditor,
    YAGUI.ONMOUSESCROLL,
    function (self)
        return true
    end
)

YAGUI.generic_utils.set_callback(
    mEditor,
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

YAGUI.generic_utils.set_callback(
    mEditor,
    YAGUI.ONWRITE,
    function (self)
        if syntax_highlight_enabled then
            syntax_highlight(math.max(1, self.cursor.pos.y - 2), #self.lines)
        end
    end
)

YAGUI.generic_utils.set_callback(
    lMain,
    YAGUI.ONCLOCK,
    function (self)
        lLines.text = string.format("Lines: %d", #mEditor.lines)
        lCursor.text = "Cursor: "..tostring(mEditor.cursor.pos)
        lPath.text = "/"..current_file_path
    end
)

YAGUI.generic_utils.set_callback(
    lMain,
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
        end

        if syntax_highlight_enabled and (mEditor.first_visible_line + mEditor.size.y - 1 > #syntax_highlight_cache) then
            syntax_highlight(#syntax_highlight_cache)
        end
    end
)

-- Callbacks for loop lInput
YAGUI.generic_utils.set_callback(
    mInput,
    YAGUI.ONKEY,
    function (self, event)
        if event.key == YAGUI.KEY_ENTER then
            self.bound.callbacks.onActionComplete(self.lines[1])
            lInput:stop()
            return true
        end
    end
)

YAGUI.generic_utils.set_callback(
    lInput,
    YAGUI.ONSTART,
    function (self)
        mInput:focus(true)
    end
)

YAGUI.generic_utils.set_callback(
    lInput,
    YAGUI.ONEVENT,
    function (self, event)
        if event.name == YAGUI.KEY then
            if event.key == YAGUI.KEY_LEFTCTRL or event.key == YAGUI.KEY_RIGHTCTRL then
                lInput:stop()
                return true
            end
        end
    end
)

YAGUI.generic_utils.set_callback(
    lInput,
    YAGUI.ONSTOP,
    function (self)
        mInput.bound = nil
        mInput.whitelist = {}
        mInput:clear()
        mInput:focus(false)
    end
)

-- Callbacks for loop lOverWrite
YAGUI.generic_utils.set_callback(
    wOverWrite,
    YAGUI.ONRESIZE,
    function (self, old_x, old_y, old_size_x, old_size_y)
        lOW.pos = YAGUI.math_utils.Vector2.new(YAGUI.math_utils.round_numbers(self.size.x / 2, self.size.y / 2)) - lOW.offset

        bOWAccept.pos.y = self.size.y - 1

        bOWReject.pos.x = self.size.x - 2
        bOWReject.pos.y = self.size.y - 1
    end
)

YAGUI.generic_utils.set_callback(
    bOWAccept,
    YAGUI.ONTIMEOUT,
    function (self)
        self.bound.callbacks.onOverWrite()
        self.bound = nil
        lOverWrite:stop()
    end
)

YAGUI.generic_utils.set_callback(
    bOWReject,
    YAGUI.ONTIMEOUT,
    function (self)
        lOverWrite:stop()
    end
)

-- Main program

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
lMain:set_elements({bFile, wFileMenu, lLines, lCursor, bCompact, mEditor, lPath, WSS})
lInput:set_elements({lInputTitle, mInput, lInputTip, WSS})
lOverWrite:set_elements({wOverWrite, WSS})

for key, loop in next, loops do
    loop.stats.pos = YAGUI.math_utils.Vector2(LAYOUT.this_layout.stats())
    loop.stats:enable(loop_stats)
    loop.options.raw_mode = true
    loop.options.stop_on_terminate = false
end
lMain.options.stop_on_terminate = true

-- Starting main loop
lMain:start()

-- Clearing all monitors
clear_all()

WSS:close()
