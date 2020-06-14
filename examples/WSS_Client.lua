
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- Get tArgs
local tArgs = {...}

if #tArgs == 0 or tArgs[1] == "help" then
    YAGUI.monitor_utils.better_print(term, colors.green, nil, "Usage:\nWSS_Client <MODEM_SIDE> <HOST_ID> [TIMEOUT] [MAX_ATTEMPTS]")
    return
end

local modem_side = tostring(tArgs[1])
local host_id = tonumber(tArgs[2])
local timeout = tonumber(tArgs[3])
local max_attempts = tonumber(tArgs[4])

if peripheral.getType(modem_side) ~= "modem" then
    error("Modem wasn't found on side: "..modem_side)
end

if not host_id then
    error("Host id must be a number got "..type(host_id))
end

local w, h = term.getSize()

local lStatus = YAGUI.gui_elements.Label(2, 2, "", colors.red)

local bQuit = YAGUI.gui_elements.Button(w, h, 1, 1, "X", colors.white, colors.green, colors.red)
bQuit.timed.enabled = true

local WSS = YAGUI.logic_elements.WSS()
WSS:use_side(modem_side)
WSS:connect(host_id, timeout, max_attempts)

local lMain = YAGUI.Loop(20, 6)

WSS:set_callback(
    YAGUI.ONDISCONNECT,
    function (self)
        YAGUI.screen_buffer.buffer.background = {
            char = " ",
            foreground = colors.black,
            background = colors.black,
            inverted = false
        }
        lStatus.text = "Host Disconnected"
    end
)

bQuit:set_callback(
    YAGUI.ONTIMEOUT,
    function (self)
        lMain:stop()
    end
)

lMain:set_elements({lStatus, bQuit, WSS})
lMain:start()

for key, monitor in next, lMain.monitors do
    YAGUI.monitor_utils.better_clear(monitor)
end

WSS:close()
