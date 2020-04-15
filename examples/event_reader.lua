
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

local tArgs = {...}

local event_filter

if tArgs[1] then event_filter = tArgs[1]; end

while true do
    local event = {os.pullEventRaw()}
    event = YAGUI.event_utils.format_event_table(event)
    
    local event_serialised = YAGUI.table_utils.serialise(event, -1, true)

    YAGUI.monitor_utils.better_clear(term)
    if event_filter then
        if event.name == event_filter then
            print(event_serialised)
        end
    else
        print(event_serialised)
    end
    if event.name == "terminate" then break; end
end

YAGUI.monitor_utils.better_clear(term)
