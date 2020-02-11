
-- LOAD LIBRARY
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not YAGUI_PATH then YAGUI_PATH = "/YAGUI/YAGUI.lua"; end
local YAGUI = dofile(YAGUI_PATH)

-- Get tArgs
local tArgs = {...}

local modem_side = tArgs[1]
local hostname = tArgs[2]

-- Connect and open rednet
YAGUI.WSS:open(modem_side)
YAGUI.WSS.client:connect(hostname)

-- Make a local variable called response
local response
while response ~= YAGUI.DISCONNECTED do -- If host has disconnected then break
    -- Listen to host and get response
    response = YAGUI.WSS.client:listen(10)
    -- Only if a response has arrived draw screen_buffer
    if response then
        YAGUI.screen_buffer:draw()
    end
end

-- Disconnect and close rednet
YAGUI.WSS.client:disconnect()
YAGUI.WSS:close()
