
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- Creating main loop
local lMain = YAGUI.Loop(60, 20)
-- Creating display label
local lEvent = YAGUI.gui_elements.Label(1, 1, "", colors.white, colors.black)
-- Aligning label text to the left
lEvent.text_alignment = YAGUI.ALIGN_LEFT

-- Adding label to loop
lMain:set_elements({lEvent})

-- Setting callback for loop events
YAGUI.generic_utils.set_callback(
    lMain,
    YAGUI.ONEVENT,
    function (self, event)
        -- Change label text
        lEvent.text = "input.pressed_keys = "..YAGUI.table_utils.serialise(YAGUI.input.pressed_keys, -1, true)
        -- if CTRL + T are pressed then stop loop
        if YAGUI.input:are_keys_pressed(YAGUI.KEY_LEFTCTRL, YAGUI.KEY_T) then
            self:stop();
        end
    end
)

-- Start main loop
lMain:start()
-- Clear terminal when loop ended
YAGUI.monitor_utils.better_clear(term)
