
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- Get tArgs
local tArgs = {...}

if #tArgs == 0 or tArgs[1] == "help" then
    YAGUI.monitor_utils.better_print(term, colors.green, nil, "Usage:\nFT_Receiver <MODEM_SIDE> <FOLDER> [PASSWORD]")
    return
end

local modem_side = tArgs[1]
if peripheral.getType(modem_side) ~= "modem" then
    error("Modem wasn't found on side: "..modem_side)
end

local dir = tArgs[2]
if not dir then
    printError("You must specify a FOLDER")
    return
elseif not fs.isDir(dir) then
    printError("You must specify a valid FOLDER")
    return
end

local w, h = term.getSize()

local mLog = YAGUI.gui_elements.Memo(1, 1, w, h, colors.white, colors.black)
mLog.editable = false

local bQuit = YAGUI.gui_elements.Button(w, h, 1, 1, "X", colors.white, colors.green, colors.red)
bQuit.timed.enabled = true

local FT = YAGUI.FT(tArgs[3])
FT:open(modem_side)
FT.mode = YAGUI.RECEIVE
FT.save_dir = dir

local lMain = YAGUI.Loop(20, 6)

YAGUI.generic_utils.set_callback(
    FT,
    YAGUI.ONCONNECT,
    function (self, event)
        return true
    end
)

YAGUI.generic_utils.set_callback(
    FT,
    YAGUI.ONRECEIVE,
    function (self, event, id, name, path, content)
        mLog:print("Received: "..YAGUI.table_utils.serialise(
            {
                from = id,
                file_name = name,
                file_path = path,
                content = #content > 100 and "TOO LONG TO DISPLAY" or content
            },
            -1, true
        ))
    end
)

YAGUI.generic_utils.set_callback(
    bQuit,
    YAGUI.ONTIMEOUT,
    function (self)
        lMain:stop()
    end
)

lMain:set_elements({bQuit, mLog, FT})
lMain:start()

for key, monitor in next, lMain.monitors do
    YAGUI.monitor_utils.better_clear(monitor)
end

FT:close()

