
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

-- CREATING OBJECTS FOR THE FIRST WINDOW
-- CREATE A BUTTON (THAT WILL DO NOTHING)
local wbDummy = YAGUI.gui_elements.Button(
    2, 2,
    10, 3,
    "Press Me", colors.white,
    colors.green, colors.red
)

-- CREATE A BUTTON (THAT WILL BE USED TO QUIT THE LOOP)
local wbQuit = YAGUI.gui_elements.Button(
    2, 6,                    -- X, Y POS
    10, 3,                   -- X, Y SIZE
    "Quit", colors.white,    -- TEXT, TEXT_COLOR
    colors.green, colors.red -- ACTIVE_COLOR, UNACTIVE_COLOR
)
wbQuit.timed.enabled = true
wbQuit.timed.clock.interval = 0.25

-- NOTE: WINDOW ELEMENTS' POSITION IS RELATIVE TO THE WINDOW (e.g. TOP LEFT CORNER OF THE WINDOW IS 1,1)
-- CREATE A BUTTON (THAT WILL BE USED TO INCREASE THE PROGRESS ON THE PROGRESSBAR)
local wbIncrease = YAGUI.gui_elements.Button(
    13, 2,
    11, 3,
    "Increase", colors.white,
    colors.green, colors.red
)
wbIncrease.timed.enabled = true
wbIncrease.timed.clock.interval = 0.25

-- CREATE A BUTTON (THAT WILL BE USED TO DECREASE THE PROGRESS ON THE PROGRESSBAR)
local wbDecrease = YAGUI.gui_elements.Button(
    13, 6,
    11, 3,
    "Decrease", colors.white,
    colors.red, colors.green
)
wbDecrease.timed.enabled = true
wbDecrease.timed.clock.interval = 0.25

-- CREATE A PROGRESSBAR
local wpbProgress = YAGUI.gui_elements.Progressbar(
    2, 10,                          -- X, Y POS
    22, 3,                          -- X, Y SIZE
    0, 0, 100,                      -- CURRENT_PROGRESS, MIN_PROGRESS, MAX_PROGRESS
    colors.white, colors.green, nil -- PERCENTAGE_COLOR, PROGRESS_COLOR, EMPTY_COLOR
)

-- CREATING FIRST WINDOW
local wWindow = YAGUI.gui_elements.Window(
    1, 1,             -- X, Y POS
    24, 13,           -- X, Y SIZE
    colors.blue, true -- BACKGROUND, SHADOW
)

-- MAKING THE WINDOW NOT RESIZEABLE
wWindow.resizing.enabled = false

-- ADDING OBJECTS THAT WE WANT ON THE WINDOW TO IT
wWindow:set_elements({wbDummy, wbQuit, wbIncrease, wbDecrease, wpbProgress})


-- CREATING A MEMO
local wmMemo = YAGUI.gui_elements.Memo(
    2, 3,                    -- X, Y POS
    22, 6,                    -- X, Y, SIZE
    colors.white, colors.blue -- FOREGROUND, BACKGROUND
)
-- WRITING ON MEMO WITH ITS FUNCTION
wmMemo:write("This was written\nBy using Memo's\nWrite function!")

-- CREATING ANOTHER MEMO
local wmMemo1 = YAGUI.gui_elements.Memo(
    2, 10,
    21, 4,
    colors.white, colors.green
)
-- SETTING MEMO LIMITS TO ITS SIZE
wmMemo1.limits = YAGUI.math_utils.Vector2(21, 4)

-- CREATING SECOND WINDOW
local wWindow1 = YAGUI.gui_elements.Window(
    27, 1,
    24, 14,
    colors.red, true
)

-- BLOCKING WINDOW'S RESIZE FROM THE TOP ROW
wWindow1.resizing.enabled_directions[-1][-1] = false -- [X][Y] = BOOLEAN
wWindow1.resizing.enabled_directions[ 0][-1] = false
wWindow1.resizing.enabled_directions[ 1][-1] = false

-- ADDING OBJECTS THAT WE WANT ON THE WINDOW TO IT
wWindow1:set_elements({
    -- CREATING A FAKE OBJECT TO DRAW A BAR ON THE TOP OF THE WINDOW
    {
        -- POS MUST BE A PROPERTY OF THE OBJECT IF DRAW METHOD IS PRESENT
        pos = YAGUI.math_utils.Vector2.new(1, 1),
        draw = function (self)
            YAGUI.screen_buffer:rectangle(self.pos.x, self.pos.y, wWindow1.size.x, 1, colors.yellow)
        end
    },
    wmMemo, wmMemo1
})

local loop = YAGUI.Loop(60, 10) -- FPS TARGET, EPS TARGET (EPS stands for Events per Second)
-- MOVING LOOP STATS AT THE BOTTOM OF THE SCREEN
loop.stats.pos.y = 18
-- ENABLING LOOP STATS
loop.stats:enable(true)

-- SET THE CALLBACK FOR WHEN THE INCREASE PROGRESSBAR BUTTON IS PRESSED
YAGUI.generic_utils.set_callback(
    wbIncrease,                       -- BUTTON OBJECT
    YAGUI.ONPRESS,                   -- EVENT THAT WILL TRIGGER THE CALLBACK
    function (self, formatted_event) -- THE CALLBACK FUNCTION
        if self.active then
            -- SET PROGRESSBAR PROGRESS TO ITSELF + 1
            wpbProgress:set(wpbProgress.value.current + 1)
        end
    end
)

-- SET THE CALLBACK FOR WHEN THE DECREASE PROGRESSBAR BUTTON IS PRESSED
YAGUI.generic_utils.set_callback(
    wbDecrease,
    YAGUI.ONPRESS,
    function (self, formatted_event)
        if self.active then
            wpbProgress:set(wpbProgress.value.current - 1)
        end
    end
)

-- SET THE CALLBACK FOR THE QUIT BUTTON
YAGUI.generic_utils.set_callback(
    wbQuit,
    YAGUI.ONTIMEOUT, -- TIMEOUT IS THE EVENT THAT IS CALLED WHEN BUTTON IS TIMED AND ITS CLOCK HAS TIMED OUT
    function (self, formatted_event)
        loop:stop()
    end
)

-- SET THE CALLBACK FOR WINDOW 1'S RESIZE
YAGUI.generic_utils.set_callback(
    wWindow1,
    YAGUI.ONRESIZE,
    function (self, old_x, old_y, old_size_x, old_size_y)
        -- CALCULATING HOW SIZE CHANGED
        local delta_size = self.size - YAGUI.math_utils.Vector2.new(old_size_x, old_size_y)
        -- RESIZING wmMemo
        wmMemo.size.x = wmMemo.size.x + delta_size.x
        -- RESIZING wmMemo1 AND SETTING ITS LIMITS EQUAL TO ITS SIZE
        wmMemo1.size = wmMemo1.size + delta_size
        wmMemo1.limits = wmMemo1.size
    end
)

-- SET LOOP ELEMENTS (adds objects to the loop)
loop:set_elements({wWindow, wWindow1})
loop:set_monitors({"terminal", "left"})
-- START THE LOOP
loop:start()

-- WHEN THE LOOP STOPS CLEAR THE SCREEN AND SET CURSOR TO 1, 1
YAGUI.monitor_utils.better_clear(term)
