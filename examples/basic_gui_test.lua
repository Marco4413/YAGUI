
-- LOAD LIBRARY
local YAGUI = dofile("/YAGUI/YAGUI.lua")

-- CREATE A BUTTON (THAT WILL DO NOTHING)
local bDummy = YAGUI.gui_elements.Button.new(
    2, 2,
    10, 3,
    "Press Me", colors.white,
    colors.green, colors.red
)

-- CREATE A BUTTON (THAT WILL BE USED TO QUIT THE LOOP)
local bQuit = YAGUI.gui_elements.Button.new(
    2, 6,                    -- X, Y POS
    10, 3,                   -- X, Y SIZE
    "Quit", colors.white,    -- TEXT, TEXT_COLOR
    colors.green, colors.red -- ACTIVE_COLOR, UNACTIVE_COLOR
)

-- CREATE A BUTTON (THAT WILL BE USED TO INCREASE THE PROGRESS ON THE PROGRESSBAR)
local bIncrease = YAGUI.gui_elements.Button.new(
    13, 2,
    11, 3,
    "Increase", colors.white,
    colors.green, colors.red
)

-- CREATE A BUTTON (THAT WILL BE USED TO DECREASE THE PROGRESS ON THE PROGRESSBAR)
local bDecrease = YAGUI.gui_elements.Button.new(
    13, 6,
    11, 3,
    "Decrease", colors.white,
    colors.red, colors.green
)

-- CREATE A PROGRESSBAR
local pbProgress = YAGUI.gui_elements.Progressbar.new(
    2, 10,                          -- X, Y POS
    22, 3,                          -- X, Y SIZE
    0, 0, 100,                      -- CURRENT_PROGRESS, MIN_PROGRESS, MAX_PROGRESS
    colors.white, colors.green, nil -- PERCENTAGE_COLOR, PROGRESS_COLOR, EMPTY_COLOR
)

-- CREATE THE LOOP
local loop = YAGUI.Loop.new(60, 20) -- FPS TARGET, EPS TARGET (EPS stands for Events per Second)

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
    YAGUI.ONPRESS,
    function (self, formatted_event)
        if self.active then
            -- STOP LOOP IF BUTTON IS ACTIVE
            loop:stop()
        end
    end
)

-- SET LOOP ELEMENTS (adds objects to the loop)
loop:set_elements({bDummy, bQuit, bIncrease, bDecrease, pbProgress})
-- START THE LOOP
loop:start()

-- WHEN THE LOOP STOPS CLEAR THE SCREEN BUFFER AND DRAW IT
-- USING THIS TO CLEAR THE SCREEN, WE CAN DO THAT BECAUSE THE BACKGROUND OF THE BUFFER IS SET TO BLACK
-- AND BLACK IS THE DEFAULT COLOR FOR THE TERMINAL, SO WE WON'T NOTICE THE DIFFERENCE
YAGUI.screen_buffer:clear()
YAGUI.screen_buffer:draw()

-- SET TERMINAL CURSOR TO ORIGIN
term.setCursorPos(1, 1)
