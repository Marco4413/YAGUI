
local YAGUI = dofile("/YAGUI/YAGUI.lua")

local b = YAGUI.gui_elements.Button.new(
    2, 2,
    10, 3,
    "Press Me", colors.white,
    colors.green, colors.red
)

local b1 = YAGUI.gui_elements.Button.new(
    2, 6,
    10, 3,
    "Quit", colors.white,
    colors.green, colors.red
)


local b2 = YAGUI.gui_elements.Button.new(
    13, 2,
    11, 3,
    "Hold On", colors.blue,
    colors.green, colors.red
)

local loop = YAGUI.Loop.new(60, 20)
YAGUI.gui_elements.setCallback(
    b1,
    YAGUI.ONPRESS,
    function (self, formatted_event)
        if self.active then
            loop:stop()
        end
    end
)

loop:set_elements({b, b1, b2})
loop:start()

YAGUI.screen_buffer:clear()
YAGUI.screen_buffer:draw()
