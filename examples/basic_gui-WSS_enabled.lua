
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- This is used to make WSS Server (Wireless Screen Share Server) broadcast
-- On YAGUI.WSS:open() there's an argument that's the computer's side
--   where the modem is located.
-- On the computer where you want to receive the information
--   you can download YAGUI_WSS_listener.lua from https://github.com/hds536jhmk/YAGUI/tree/master/examples
--   then you launch it with <modem_side> <Computer ID> terminal arguments,
--   Computer ID is the ID of the computer where this example is ran from.
local cWSS = YAGUI.gui_elements.Clock(3)
YAGUI.WSS:open("left")
YAGUI.WSS.server:host()

YAGUI.generic_utils.set_callback(
    cWSS,
    YAGUI.ONCLOCK,
    function (self)
        YAGUI.WSS.server:broadcast()
    end
)

-- CREATE A BUTTON (THAT WILL DO NOTHING)
local bDummy = YAGUI.gui_elements.Button(
    2, 2,
    10, 3,
    "Press Me", colors.white,
    colors.green, colors.red
)

-- CREATE A BUTTON (THAT WILL BE USED TO QUIT THE LOOP)
local bQuit = YAGUI.gui_elements.Button(
    2, 6,                    -- X, Y POS
    10, 3,                   -- X, Y SIZE
    "Quit", colors.white,    -- TEXT, TEXT_COLOR
    colors.green, colors.red -- ACTIVE_COLOR, UNACTIVE_COLOR
)
bQuit.timed.enabled = true
bQuit.timed.clock.interval = 0.25

-- CREATE A BUTTON (THAT WILL BE USED TO INCREASE THE PROGRESS ON THE PROGRESSBAR)
local bIncrease = YAGUI.gui_elements.Button(
    13, 2,
    11, 3,
    "Increase", colors.white,
    colors.green, colors.red
)
bIncrease.timed.enabled = true
bIncrease.timed.clock.interval = 0.25

-- CREATE A BUTTON (THAT WILL BE USED TO DECREASE THE PROGRESS ON THE PROGRESSBAR)
local bDecrease = YAGUI.gui_elements.Button(
    13, 6,
    11, 3,
    "Decrease", colors.white,
    colors.red, colors.green
)
bDecrease.timed.enabled = true
bDecrease.timed.clock.interval = 0.25

-- CREATE A PROGRESSBAR
local pbProgress = YAGUI.gui_elements.Progressbar(
    2, 10,                          -- X, Y POS
    22, 3,                          -- X, Y SIZE
    0, 0, 100,                      -- CURRENT_PROGRESS, MIN_PROGRESS, MAX_PROGRESS
    colors.white, colors.green, nil -- PERCENTAGE_COLOR, PROGRESS_COLOR, EMPTY_COLOR
)

-- CREATE THE LOOP
local loop = YAGUI.Loop(60, 10) -- FPS TARGET, EPS TARGET (EPS stands for Events per Second)

-- SET THE CALLBACK FOR WHEN THE INCREASE PROGRESSBAR BUTTON IS PRESSED
YAGUI.generic_utils.set_callback(
    bIncrease,                       -- BUTTON OBJECT
    YAGUI.ONPRESS,                   -- EVENT THAT WILL TRIGGER THE CALLBACK
    function (self, formatted_event) -- THE CALLBACK FUNCTION
        if self.active then
            -- SET PROGRESSBAR PROGRESS TO ITSELF + 1
            pbProgress:set(pbProgress.value.current + 1)
        end
    end
)

-- SET THE CALLBACK FOR WHEN THE DECREASE PROGRESSBAR BUTTON IS PRESSED
YAGUI.generic_utils.set_callback(
    bDecrease,
    YAGUI.ONPRESS,
    function (self, formatted_event)
        if self.active then
            pbProgress:set(pbProgress.value.current - 1)
        end
    end
)

-- SET THE CALLBACK FOR THE QUIT BUTTON
YAGUI.generic_utils.set_callback(
    bQuit,
    YAGUI.ONTIMEOUT, -- TIMEOUT IS THE EVENT THAT IS CALLED WHEN BUTTON IS TIMED AND ITS CLOCK HAS TIMED OUT
    function (self, formatted_event)
        loop:stop()
    end
)

-- SET LOOP ELEMENTS (adds objects to the loop)
loop:set_elements({cWSS, bDummy, bQuit, bIncrease, bDecrease, pbProgress})
loop:set_monitors({"terminal", "left"})
-- START THE LOOP
loop:start()

-- WHEN THE LOOP STOPS CLEAR THE SCREEN AND SET CURSOR TO 1, 1
YAGUI.monitor_utils.better_clear(term)

-- CLOSES WSS SERVER
YAGUI.WSS.server:unhost()
YAGUI.WSS:close()