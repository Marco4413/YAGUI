
-- AUTO-GENERATED with "YAGUI create"
local YAGUI_PATH = settings.get("YAGUI_PATH")
if not (type(YAGUI_PATH) == "string") then printError("YAGUI is not installed, please install it by opening it with argument \"setup\"."); return; end
if not fs.exists(YAGUI_PATH) then printError("Couldn't find YAGUI in path: \""..YAGUI_PATH.."\", Please reinstall it by opening it with argument \"setup\"."); return; end
local YAGUI = dofile(YAGUI_PATH)
-- End of AUTO-GENERATED code

local main_monitor = term

local tArgs = {...}
local path = table.remove(tArgs, 1)
if (not path) or fs.isDir(shell.resolve(path)) then
    YAGUI.monitor_utils.better_print(term, colors.green, nil, "HPainter <PATH> [MONITORS]")
    return
end

path = shell.resolve(path)

local function open_binary(path)
    local file = fs.open(path, "rb")
    local rows = {}
    local row = {}

    while true do
        local byte = file.read()
        if not byte then
            rows[#rows + 1] = table.concat(row)
            break
        end
        
        local char = string.char(byte)
        if char == "\n" then
            rows[#rows + 1] = table.concat(row)
            row = {}
        elseif char ~= "\r" then
            row[#row + 1] = char
        end
    end
    file.close()

    return table.concat(rows, "\n")
end

local function save_binary(path, content)
    local file = fs.open(path, "wb")
    for i=1, #content do
        local char = content:sub(i, i)
        file.write(string.byte(char))
    end
    file.close()
end

local Vector2 = YAGUI.math_utils.Vector2
local w, h = main_monitor.getSize()

local function get_sorted_xy(v1, v2)
    return v1.x < v2.x and v1.x or v2.x, v1.y < v2.y and v1.y or v2.y, v1.x > v2.x and v1.x or v2.x, v1.y > v2.y and v1.y or v2.y
end

local function format_button_text(text)
    return table.concat({text:sub(1, 1):upper(), text:sub(2)})
end

-- Setting up background
local backgroundCanvas = YAGUI.gui_elements.Canvas(1, 1, w, h)

backgroundCanvas.init = function (self)
    for y=1, h do
        self:write(1, y, string.rep("\127", w), colors.gray)
    end
end
backgroundCanvas.hidden = true

backgroundCanvas:init()

-- Setting up the Canvas
local paintCanvas = YAGUI.gui_elements.Canvas(1, 1, w, h)
if fs.exists(path) then paintCanvas:nfp_image(1, 1, open_binary(path)); end
paintCanvas.transparent = true

paintCanvas.scroll_horizontal = function (self, ammount)
    if ammount ~= 0 then
        local min, max
        for k in next, self.buffer.pixels do
            min, max = math.min(min or k, k), math.max(max or k, k)
        end

        if min and max then
            local is_high = ammount > 0
            for x=is_high and max or min, is_high and min or max, is_high and -1 or 1 do
                self.buffer.pixels[x + ammount], self.buffer.pixels[x] = self.buffer.pixels[x]
            end
        end
    end
end

paintCanvas.scroll_vertical = function (self, ammount)
    if ammount ~= 0 then
        local min, max
        for _, col in next, self.buffer.pixels do
            for k in next, col do
                min, max = math.min(min or k, k), math.max(max or k, k)
            end
        end

        if min and max then
            local is_high = ammount > 0
            for x, col in next, self.buffer.pixels do
                for y=is_high and max or min, is_high and min or max, is_high and -1 or 1 do
                    col[y + ammount], col[y] = col[y]
                end
            end
        end
    end
end

-- Setting up the brush
local brush = {
    Canvas = YAGUI.gui_elements.Canvas(1, 1, w, h),
    type = "point",
    color = colors.blue,
    filled = false,
    erasing = false,
    center = false,
    temp = false,
    origin = Vector2(),
    end_pos = Vector2(),
    extra = nil
}

brush.reset_pos = function (self)
    self.origin = Vector2()
    self.end_pos = Vector2()
end

brush.Canvas.transparent = true
brush.Canvas.buffer.background = "nil"

brush.Canvas.change_color = function (self, color)
    for key, col in next, self.buffer.pixels do
        for key, pixel in next, col do
            pixel.background, pixel.foreground = color, color
        end
    end
end

brush.Canvas.erase = function (self, other)
    for x in next, self.buffer.pixels do
        for y in next, self.buffer.pixels[x] do
            other.buffer:remove_pixel(x, y)
        end
    end
end

brush.Canvas.fill = function (self, target_canvas, x, y, replacement_color)
    if not YAGUI.event_utils.in_area(x, y, self.pos.x, self.pos.y, self.size.x, self.size.y) then return; end
    
    local pixel = target_canvas.buffer:get_pixel(x, y)
    local target_color = target_canvas.buffer:is_pixel_custom(x, y) and pixel.background or "nil"
    replacement_color = replacement_color or "nil"

    --if pixel.background ~= target_color then return; end
    if target_color == replacement_color then return; end
    
    target_canvas:cast(self)
    local changed = {}
    self.buffer:set_pixel(x, y, " ", replacement_color, replacement_color)
    changed[x] = {}; changed[x][y] = replacement_color

    local Q = {}
    pixel.x, pixel.y = x, y
    Q[#Q + 1] = pixel


    while #Q > 0 do
        local n = Q[#Q]
        Q[#Q] = nil

        local west = self.buffer:get_pixel(n.x + 1, n.y)
        west.x, west.y = n.x + 1, n.y
        local east = self.buffer:get_pixel(n.x - 1, n.y)
        east.x, east.y = n.x - 1, n.y
        local north = self.buffer:get_pixel(n.x, n.y + 1)
        north.x, north.y = n.x, n.y + 1
        local south = self.buffer:get_pixel(n.x, n.y - 1)
        south.x, south.y = n.x, n.y - 1

        local nodes = {
            west,
            east,
            north,
            south
        }

        for i=1, #nodes do
            local node = nodes[i]
            if node.background == target_color and YAGUI.event_utils.in_area(node.x, node.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                self.buffer:set_pixel(node.x, node.y, " ", replacement_color, replacement_color)
                if not changed[node.x] then
                    changed[node.x] = {}; changed[node.x][node.y] = replacement_color
                else
                    changed[node.x][node.y] = replacement_color
                end

                Q[#Q + 1] = node
            end
        end
    end

    self.buffer.pixels = {}

    for x, col in next, changed do
        for y, color in next, col do
            self.buffer:set_pixel(
                x, y, " ",
                color == "nil" and target_canvas.buffer.background or color,
                color == "nil" and target_canvas.buffer.background or color
            )
        end
    end
end

brush.Canvas.event = function (self, event)
    if event.name == YAGUI.TOUCH then
        self:clear()
        brush.temp = event.button == YAGUI.MOUSE_RIGHT and true or false
        brush.origin.x, brush.origin.y = event.x, event.y
        brush.end_pos.x, brush.end_pos.y = event.x, event.y
        brush.extra = nil
        return true
    elseif event.name == YAGUI.MOUSEDRAG then
        brush.end_pos.x, brush.end_pos.y = event.x, event.y
        return true
    elseif (event.name == YAGUI.MOUSEUP and (not brush.temp)) or (event.name == YAGUI.KEY and event.key == YAGUI.KEY_ENTER) then
        if brush.erasing then
            self:erase(paintCanvas)
        else
            self:cast(paintCanvas)
        end
        self:clear()
        brush:reset_pos()
        brush.extra = nil
        return true
    end
end

brush.Canvas:set_callback(
    YAGUI.ONDRAW,
    function (self)
        local pos1, pos2 = brush.origin - brush.Canvas.pos + Vector2.ONE, brush.end_pos - brush.Canvas.pos + Vector2.ONE
        if brush.type == "point" then
            if brush.center then
                self:clear()
                local x_off, y_off = (pos1.x - pos2.x) / 2, (pos1.y - pos2.y) / 2
                self:point(pos2.x + x_off, pos2.y + y_off, brush.erasing and paintCanvas.buffer.background or brush.color)
            else
                if brush.extra then
                    pos1 = brush.extra - brush.Canvas.pos + Vector2.ONE
                end
                self:line(pos1.x, pos1.y, pos2.x, pos2.y, brush.erasing and paintCanvas.buffer.background or brush.color)
                brush.extra = brush.end_pos:duplicate()
            end
        elseif brush.type == "rectangle" then
            self:clear()
            if brush.center then
                local distance = pos2 - pos1
                distance.x, distance.y = math.abs(distance.x), math.abs(distance.y)
                self:rectangle(pos1.x - distance.x, pos1.y - distance.y, distance.x * 2 + 1, distance.y * 2 + 1, brush.erasing and paintCanvas.buffer.background or brush.color, false, nil, not brush.filled)
            else
                local x1, y1, x2, y2 = get_sorted_xy(pos1, pos2)
                self:rectangle(x1, y1, x2 - x1 + 1, y2 - y1 + 1, brush.erasing and paintCanvas.buffer.background or brush.color, false, nil, not brush.filled)
            end
        elseif brush.type == "line" then
            self:clear()
            self:line(pos1.x, pos1.y, pos2.x, pos2.y, brush.erasing and paintCanvas.buffer.background or brush.color)
        elseif brush.type == "circle" then
            self:clear()
            local distance = pos2 - pos1
            local x_off, y_off, radius = 0, 0, 0
            if brush.center then
                radius = math.floor(distance:length() + 0.5)
            else
                radius = math.floor(distance:length() / 2 + 0.5)
                x_off, y_off = (pos1.x - pos2.x) / -2, (pos1.y - pos2.y) / -2
            end
            self:circle(pos1.x + x_off, pos1.y + y_off, radius, brush.erasing and paintCanvas.buffer.background or brush.color, not brush.filled)
        elseif brush.type == "fill" then
            if brush.extra ~= pos1 then
                self:clear()
                if brush.erasing then
                    self:fill(paintCanvas, pos1.x, pos1.y, nil)
                else
                    self:fill(paintCanvas, pos1.x, pos1.y, brush.color)
                end
                brush.extra = pos1:duplicate()
            end
        end
    end
)

-- Setting up palette
local palette_button_width = 4
local palette = {}
do
    for _, color in next, colors do
        if type(color) == "number" then
            local button = YAGUI.gui_elements.Button(color == brush.color and 3 or 2, #palette + 2, palette_button_width, 1, "", color, color, color)
            button:set_callback(
                YAGUI.ONPRESS,
                function (self)
                    self.active = false
                    for key, button in next, palette do
                        button.pos.x = 2
                    end
                    self.pos.x = 3
                    brush.color = self.colors.foreground
                    if not brush.erasing then brush.Canvas:change_color(self.colors.foreground); end
                end
            )
            palette[#palette + 1] = button
        end
    end
end

local paletteWindow = YAGUI.gui_elements.Window(2, 2, palette_button_width + 2, #palette + 2, colors.lightGray)
paletteWindow.resizing.enabled = false
paletteWindow.border, paletteWindow.colors.border_color = true, colors.red
paletteWindow:set_elements(palette)

-- Setting up brush settings
brush.elements = {}
local brush_button_width = 1
do
    local brushes = {
        "point",
        "rectangle",
        "line",
        "circle",
        "fill"
    }
    for _, brush_type in next, brushes do
        brush_button_width = math.max(brush_button_width, #brush_type + 2)
        local button = YAGUI.gui_elements.Button(2, #brush.elements + 2, brush_button_width, 1, format_button_text(brush_type), colors.white, colors.green, colors.red)
        if brush_type == brush.type then button.active = true; end
        button:set_callback(
            YAGUI.ONPRESS,
            function (self)
                if self.active then
                    for _, other in next, brush.elements do
                        other.active = false
                    end
                    self.active = true
                    brush.type = self.text:lower()
                    brush.Canvas:clear()
                    brush.extra = nil
                else
                    self.active = true
                end
            end
        )
        button.shortcut = {YAGUI.KEY_LEFTCTRL, YAGUI["KEY_" .. brush_type:sub(1,1):upper()]}
        brush.elements[#brush.elements + 1] = button
    end

    for _, button in next, brush.elements do
        button.size.x = brush_button_width
    end
end

local brushesWindow = YAGUI.gui_elements.Window(1, 1, brush_button_width + 2, #brush.elements + 2, colors.lightGray)
brushesWindow.pos.x, brushesWindow.pos.y = w - brushesWindow.size.x, h - brushesWindow.size.y
brushesWindow.resizing.enabled = false
brushesWindow.border, brushesWindow.colors.border_color = true, colors.red
brushesWindow:set_elements(brush.elements)

-- Setting up Brush Settings Window
local brush_settings = {}
local brush_settings_width = 1
do
    local booleans = {
        "filled",
        "erasing",
        "center"
    }

    for _, bool in next, booleans do
        brush_settings_width = math.max(brush_settings_width, #bool + 2)
        local button = YAGUI.gui_elements.Button(2, #brush_settings + 2, brush_settings_width, 1, format_button_text(bool), colors.white, colors.green, colors.red)
        button:set_callback(
            YAGUI.ONPRESS,
            function (self)
                brush[self.text:lower()] = self.active
                if brush.erasing then
                    brush.Canvas:change_color(paintCanvas.buffer.background)
                else
                    brush.Canvas:change_color(brush.color)
                end
            end
        )
        button.shortcut = {YAGUI.KEY_LEFTSHIFT, YAGUI["KEY_" .. bool:sub(1,1):upper()]}
        button.active = brush[bool]
        brush_settings[#brush_settings + 1] = button
    end

    for _, button in next, brush_settings do
        button.size.x = brush_settings_width
    end
end

local brushSettingsWindow = YAGUI.gui_elements.Window(1, 1, brush_settings_width + 2, #brush_settings + 2, colors.lightGray)
brushSettingsWindow.pos.x, brushSettingsWindow.pos.y = w - brushSettingsWindow.size.x, 2
brushSettingsWindow.resizing.enabled = false
brushSettingsWindow.border, brushSettingsWindow.colors.border_color = true, colors.red
brushSettingsWindow:set_elements(brush_settings)

-- Eliminating artifacts that could occur when dragging buttons that are on windows
local function eliminate_drag_artifacts(self, event)
    if (not self.focussed) and event.name == YAGUI.MOUSEDRAG then
        if YAGUI.event_utils.in_area(event.x, event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
            return true
        end
    end
end
paletteWindow:set_callback(YAGUI.ONEVENT, eliminate_drag_artifacts)
brushesWindow:set_callback(YAGUI.ONEVENT, eliminate_drag_artifacts)
brushSettingsWindow:set_callback(YAGUI.ONEVENT, eliminate_drag_artifacts)

-- Setting up Label
local lGrid = YAGUI.gui_elements.Label(1, h - 1, "Press G to toggle GRID", colors.white)
local lSave = YAGUI.gui_elements.Label(1, h, "Press S to save: \"" .. path .. "\"", colors.white)
local clSaveSaving = YAGUI.gui_elements.Clock(1)
clSaveSaving.oneshot = true

clSaveSaving:set_callback(
    YAGUI.ONCLOCK,
    function (self)
        lSave.colors.foreground = colors.white
    end
)

local function toggle_GUI()
    local state = paletteWindow.hidden
    paletteWindow.hidden = not state
    brushesWindow.hidden = not state
    brushSettingsWindow.hidden = not state
    lSave.hidden = not state
end

-- Setting uo main loop
local loop = YAGUI.Loop(20, 6)
loop.options.raw_mode = true
loop:set_monitors({"terminal", table.unpack(tArgs)})
loop:set_elements({brushSettingsWindow, brushesWindow, paletteWindow, lGrid, lSave, brush.Canvas, paintCanvas, backgroundCanvas, clSaveSaving})

loop:set_callback(
    YAGUI.ONEVENT,
    function (self, event)
        if event.name == YAGUI.TERMRESIZE then
            w, h = main_monitor.getSize()
            paletteWindow.pos.x, paletteWindow.pos.y = 2, 2
            brushesWindow.pos.x, brushesWindow.pos.y = w - brushesWindow.size.x, h - brushesWindow.size.y
            brushSettingsWindow.pos.x, brushSettingsWindow.pos.y = w - brushSettingsWindow.size.x, 2

            brush.Canvas.size.x, paintCanvas.size.x, backgroundCanvas.size.x = w, w, w
            brush.Canvas.size.y, paintCanvas.size.y, backgroundCanvas.size.y = h, h, h
            lGrid.pos.y = h - 1
            lSave.pos.y = h
            backgroundCanvas:init()
        elseif event.name == YAGUI.KEY then
            if event.key == YAGUI.KEY_S then
                save_binary(path, paintCanvas:to_nfp(true))
                lSave.colors.foreground = colors.green
                clSaveSaving:reset_timer()
                clSaveSaving:start()
            elseif event.key == YAGUI.KEY_H then
                toggle_GUI()
            elseif event.key == YAGUI.KEY_G then
                backgroundCanvas.hidden = not backgroundCanvas.hidden
            elseif event.key == YAGUI.KEY_RIGHT then
                paintCanvas:scroll_horizontal(1)
            elseif event.key == YAGUI.KEY_LEFT then
                paintCanvas:scroll_horizontal(-1)
            elseif event.key == YAGUI.KEY_UP then
                paintCanvas:scroll_vertical(-1)
            elseif event.key == YAGUI.KEY_DOWN then
                paintCanvas:scroll_vertical(1)
            end
        end
    end
)

loop:start()

for key, monitor in next, loop.monitors do
    YAGUI.monitor_utils.better_clear(monitor)
end
