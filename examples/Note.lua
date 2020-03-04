
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- SETTINGS

local default_name = "new"
local default_extension = ".txt"

local WSS_broadcast_interval = 3
local FPS = 60
local EPS = 6
local loop_stats = true

local button_timeout = 0.5
local cursor_blinking_speed = 0.5

local text_color = colors.white
local cursor_color = colors.white
local editor_background = colors.black

local background_color = colors.gray
local lighter_background_color = colors.lightGray

local special_button_active_color = colors.green
local special_button_not_active_color = colors.red

local shadows = true

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
        lCursor  = function () return 21, 1; end,
        bCompact = function () return 51, 1, 1, 1; end,
        mEditor  = function () return 5, 2, 47, 17; end,
        lPath    = function () return 1, 19; end,

        bFile     = function () return 1, 1, 4, 1; end,
        wFileMenu = function () return 1, 2, 10, 7; end,
        bNewOpen  = function () return 1, 1, 10, 1; end,
        bSave     = function () return 1, 2, 10, 1; end,
        bSaveAs   = function () return 1, 3, 10, 1; end,
        bDelete   = function () return 1, 4, 10, 1; end,
        bGoto     = function () return 1, 5, 10, 1; end,
        bRun      = function () return 1, 6, 10, 1; end,
        bQuit     = function () return 1, 7, 10, 1; end,

        lInputTitle = function () return 2, 9; end,
        mInput      = function () return 2, 10, 49, 1; end,
        lInputTip   = function () return 3, 12, "You can press CONTROL to cancel."; end,

        wOverWrite = function () return 18, 7, 15, 6; end,
        lOW        = function () return 3, 2; end,
        bOWAccept  = function () return 2, 5, 3, 1; end,
        bOWReject  = function () return 13, 5, 2, 1; end,

        stats = function () return 45, 18; end
    },
    [ YAGUI.COMPUTER ] = {},
    [ YAGUI.TURTLE ] = {
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
        lCursor  = function () return 1, 19; end,
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

-- Creating elements

-- Creating loops
local lMain      = YAGUI.Loop.new(FPS, EPS)
local lInput     = YAGUI.Loop.new(FPS, EPS)
local lOverWrite = YAGUI.Loop.new(FPS, EPS)

local loops = {
    [ "main" ] = lMain,
    [ "input" ] = lInput,
    [ "overwrite" ] = lOverWrite
}

-- Creating WSS Clock
local cWSS = YAGUI.gui_elements.Clock.new(WSS_broadcast_interval)

YAGUI.generic_utils.set_callback(
    cWSS,
    YAGUI.ONCLOCK,
    function (self)
        YAGUI.WSS.server:broadcast()
    end
)
cWSS.enabled = false

-- Creating main loop elements
local lLines    = YAGUI.gui_elements.Label.new(9, 1, "Lines: 0", text_color)
local lCursor   = YAGUI.gui_elements.Label.new(21, 1, "Cursor: (1; 1)", text_color)
local bCompact  = YAGUI.gui_elements.Button.new(51, 1, 1, 1, "C", text_color, special_button_active_color, special_button_not_active_color)
local mEditor   = YAGUI.gui_elements.Memo.new(5, 2, 47, 17, text_color, editor_background)
local lPath     = YAGUI.gui_elements.Label.new(1, 19, "/path/", text_color)

-- Applying layout
lLines.pos.x  , lLines.pos.y  = LAYOUT.this_layout.lLines()
lCursor.pos.x , lCursor.pos.y = LAYOUT.this_layout.lCursor()
bCompact.pos.x, bCompact.pos.y, bCompact.size.x, bCompact.size.y = LAYOUT.this_layout.bCompact()
mEditor.pos.x , mEditor.pos.y , mEditor.size.x , mEditor.size.y  = LAYOUT.this_layout.mEditor()
lPath.pos.x   , lPath.pos.y   = LAYOUT.this_layout.lPath()

bCompact.timed.enabled = true
bCompact.timed.clock.interval = button_timeout
bCompact.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI.KEY_LEFTSHIFT, YAGUI.KEY_C}

mEditor.cursor.blink.interval = cursor_blinking_speed
mEditor.colors.cursor = cursor_color

-- Creating elements that will make File menu
local bFile     = YAGUI.gui_elements.Button.new(1, 1, 4, 1, "File", text_color, lighter_background_color, background_color)
local wFileMenu = YAGUI.gui_elements.Window.new(1, 2, 10, 7, background_color, shadows)
local bNewOpen  = YAGUI.gui_elements.Button.new(1, 2, 10, 1, "New/Open", text_color, lighter_background_color, background_color)
local bSave     = YAGUI.gui_elements.Button.new(1, 3, 10, 1, "Save"    , text_color, lighter_background_color, background_color)
local bSaveAs   = YAGUI.gui_elements.Button.new(1, 4, 10, 1, "SaveAs"  , text_color, lighter_background_color, background_color)
local bDelete   = YAGUI.gui_elements.Button.new(1, 5, 10, 1, "Delete"  , text_color, lighter_background_color, background_color)
local bGoto     = YAGUI.gui_elements.Button.new(1, 6, 10, 1, "Goto"    , text_color, lighter_background_color, background_color)
local bRun      = YAGUI.gui_elements.Button.new(1, 7, 10, 1, "Run"     , text_color, lighter_background_color, background_color)
local bQuit     = YAGUI.gui_elements.Button.new(1, 8, 10, 1, "Exit"    , text_color, special_button_active_color, special_button_not_active_color)

-- Applying layout
bFile.pos.x    , bFile.pos.y    , bFile.size.x    , bFile.size.y     = LAYOUT.this_layout.bFile()
wFileMenu.pos.x, wFileMenu.pos.y, wFileMenu.size.x, wFileMenu.size.y = LAYOUT.this_layout.wFileMenu()
bNewOpen.pos.x , bNewOpen.pos.y , bNewOpen.size.x , bNewOpen.size.y  = LAYOUT.this_layout.bNewOpen()
bSave.pos.x    , bSave.pos.y    , bSave.size.x    , bSave.size.y     = LAYOUT.this_layout.bSave()
bSaveAs.pos.x  , bSaveAs.pos.y  , bSaveAs.size.x  , bSaveAs.size.y   = LAYOUT.this_layout.bSaveAs()
bDelete.pos.x  , bDelete.pos.y  , bDelete.size.x  , bDelete.size.y   = LAYOUT.this_layout.bDelete()
bGoto.pos.x    , bGoto.pos.y    , bGoto.size.x    , bGoto.size.y     = LAYOUT.this_layout.bGoto()
bRun.pos.x     , bRun.pos.y     , bRun.size.x     , bRun.size.y      = LAYOUT.this_layout.bRun()
bQuit.pos.x    , bQuit.pos.y    , bQuit.size.x    , bQuit.size.y     = LAYOUT.this_layout.bQuit()

wFileMenu.draw_priority = YAGUI.LOW_PRIORITY
wFileMenu.hidden = true
wFileMenu:set_elements({bNewOpen, bSave, bSaveAs, bDelete, bGoto, bRun, bQuit}, true)

bSave.timed.enabled = true
bSave.timed.clock.interval = button_timeout
bDelete.timed.enabled = true
bDelete.timed.clock.interval = button_timeout
bRun.timed.enabled = true
bRun.timed.clock.interval = button_timeout
bQuit.timed.enabled = true
bQuit.timed.clock.interval = button_timeout

bFile.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI.KEY_TAB}

-- Creating elements for loop lInput
local lInputTitle = YAGUI.gui_elements.Label.new(2, 9, "", text_color)
local mInput      = YAGUI.gui_elements.Memo.new(2, 10, 49, 1, text_color, lighter_background_color)
local lInputTip   = YAGUI.gui_elements.Label.new(3, 12, "You can press CONTROL to cancel.", text_color)

-- Applying layout
lInputTitle.pos.x, lInputTitle.pos.y                 = LAYOUT.this_layout.lInputTitle()
mInput.pos.x     , mInput.pos.y, mInput.size.x, mInput.size.y = LAYOUT.this_layout.mInput()
lInputTip.pos.x  , lInputTip.pos.y  , lInputTip.text = LAYOUT.this_layout.lInputTip()

mInput.limits = YAGUI.math_utils.Vector2.new(0, 1)
mInput.cursor.blink.interval = cursor_blinking_speed
mInput.colors.cursor = cursor_color

-- Creating elements for OverWrite loop
local wOverWrite = YAGUI.gui_elements.Window.new(18, 7, 15, 6, lighter_background_color, shadows)
local lOW        = YAGUI.gui_elements.Label.new(20, 8, "Do you want\nto overwrite?", text_color)
local bOWAccept  = YAGUI.gui_elements.Button.new(19, 11, 3, 1, "Yes", text_color, background_color, lighter_background_color)
local bOWReject  = YAGUI.gui_elements.Button.new(30, 11, 2, 1, "No", text_color, background_color, lighter_background_color)

-- Applying layout
wOverWrite.pos.x, wOverWrite.pos.y, wOverWrite.size.x, wOverWrite.size.y = LAYOUT.this_layout.wOverWrite()
lOW.pos.x       , lOW.pos.y = LAYOUT.this_layout.lOW()
bOWAccept.pos.x , bOWAccept.pos.y , bOWAccept.size.x , bOWAccept.size.y  = LAYOUT.this_layout.bOWAccept()
bOWReject.pos.x , bOWReject.pos.y , bOWReject.size.x , bOWReject.size.y  = LAYOUT.this_layout.bOWReject()

wOverWrite:set_elements({lOW, bOWAccept, bOWReject}, true)

bOWAccept.timed.enabled = true
bOWAccept.timed.clock.interval = button_timeout
bOWReject.timed.enabled = true
bOWReject.timed.clock.interval = button_timeout

bOWAccept.shortcut = {YAGUI.KEY_Y}
bOWReject.shortcut = {YAGUI.KEY_N}

-- Defining functions

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
        
        mEditor:write(file.readAll())

        file.close()
    else
        local file = fs.open(path, "w")

        file.write("")

        file.close()
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
            { text = "Note <COMMAND>"                                                                                       , foreground = colors.green , background = nil},
            { text = " - help (shows this list of commands)"                                                                , foreground = colors.blue  , background = nil},
            { text = " - open <PATH> (opens file at PATH)"                                                                  , foreground = colors.yellow, background = nil},
            { text = " - multi <MONITORS> (sets MONITORS\n   as io for the app)"                                            , foreground = colors.green , background = nil},
            { text = " - wss <MODEM_SIDE> [HOSTNAME]\n   (hosts a WSS server using the modem\n   on MODEM_SIDE as HOSTNAME)", foreground = colors.blue  , background = nil}
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
            YAGUI.WSS:open(modem_side)
            local host
            if options.wss[2] and not options.wss[2]:gsub(" ", "") == 0 then host = options.wss[2]; end
            local success, name = YAGUI.WSS.server:host(host)
            if not success then
                YAGUI.monitor_utils.better_print(term, colors.red, nil, "Couldn't host WSS server as ", tostring(name), ".")
                return
            end
            cWSS.enabled = true
            YAGUI.monitor_utils.better_print(term, colors.green, nil, "WSS server was hosted as ", YAGUI.WSS.server.hostname, ".")
            sleep(2)
        end
    end
end

-- Opening notes
open_notes(current_file_path)

-- Setting up loops
lMain.stats.pos = YAGUI.math_utils.Vector2.new(LAYOUT.this_layout.stats())
lMain.stats:enable(loop_stats)
lMain:set_elements({cWSS, bFile, wFileMenu, lLines, lCursor, bCompact, mEditor, lPath})

lInput.stats.pos = YAGUI.math_utils.Vector2.new(LAYOUT.this_layout.stats())
lInput.stats:enable(loop_stats)
lInput:set_elements({cWSS, lInputTitle, mInput, lInputTip})

lOverWrite.stats.pos = YAGUI.math_utils.Vector2.new(LAYOUT.this_layout.stats())
lOverWrite.stats:enable(loop_stats)
lOverWrite:set_elements({cWSS, wOverWrite})

-- Starting main loop
lMain:start()

-- Clearing all monitors
for key, monitor in next, lMain.monitors do
    YAGUI.monitor_utils.better_clear(monitor)
end

-- If WSS was enabled we should probably unhost the server before quitting
if cWSS.enabled then
    YAGUI.WSS.server:unhost()
    YAGUI.WSS:close()
end
