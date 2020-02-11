--[[
Copyright (c) 2019, hds536jhmk : https://github.com/hds536jhmk/YAGUI

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--]]

-- INFO TABLE
local info = {
    ver = "1.0",
    author = "hds536jhmk",
    website = "https://github.com/hds536jhmk/YAGUI",
    copyright = "Copyright (c) 2019, hds536jhmk : https://github.com/hds536jhmk/YAGUI\n\nPermission to use, copy, modify, and/or distribute this software for any\npurpose with or without fee is hereby granted, provided that the above\ncopyright notice and this permission notice appear in all copies.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\" AND THE AUTHOR DISCLAIMS ALL WARRANTIES\nWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF\nMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR\nANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES\nWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN\nACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF\nOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE."
}

-- CONSTANTS TABLE
-- THESE WILL BE TRANSFORMED IN GLOBAL VARIABLES WHEN LIBRARY IS RETURNED
local const = {
    TOUCH = "screen_touch",
    MOUSEUP = "mouse_up",
    DELETED = "DELETED",
    DISCONNECTED = "DISCONNECTED",
    LOW_PRIORITY = 1,
    HIGH_PRIORITY = 2,
    ONDRAW = 3,
    ONPRESS = 4,
    ONCLOCK = 5,
    ONEVENT = 6
}

-- GENERIC UTILS TABLE
local generic_utils = {
    -- SETS A CALLBACK TO THE SPECIFIED OBJECT
    set_callback = function (gui_element, event, callback)
        if event == const.ONDRAW then
            gui_element.callbacks.onDraw = callback
        elseif event == const.ONPRESS then
            gui_element.callbacks.onPress = callback
        elseif event == const.ONCLOCK then
            gui_element.callbacks.onClock = callback
        end
    end
}

-- STRING UTILS TABLE
local string_utils = {}
string_utils = {
    -- JOINS A TABLE OF STRINGS INTO A STRING THAT HAS STRINGS SEPARATED BY THE SPECIFIED SEPARATOR
    join = function (tbl, sep)
        if not sep then sep = ""; end
        local str = ""
        for key=1, #tbl do
            local value = tbl[key]
            str = str..tostring(value)
            if key < #tbl then str = str..sep; end
        end
        return str
    end,
    -- SPLITS STRING EVERY TIME SEPARATOR CHARSET IS FOUND
    split = function (str, sep)
        local tbl = {}
        while true do
            local pos = str:find(sep)
            if pos then
                table.insert(tbl, str:sub(1, pos - 1))
                str = str:sub(pos + 1)
            else
                table.insert(tbl, str)
                break
            end
        end

        return tbl
    end,
    -- COMPARES V1 AND V2 AND IF V1 IS NEWER THAN V2 THEN IT RETURNS 1, IF THEY'RE THE SAME IT RETURNS 0 ELSE IT RETURNS -1
    -- v1 = "0.2"; v2 = "0.1" -> returns 1
    -- v1 = "0.1"; v2 = "0.1" -> returns 0
    -- v1 = "0.1"; v2 = "0.2" -> returns -1
    compare_versions = function(v1, v2)
        local v1s = string_utils.split(v1, ".")
        local v2s = string_utils.split(v2, ".")
        local v1l = #v1s
        local v2l = #v2s
        for i=1, math.min(v1l, v2l) do
            if tonumber(v1s[i]) > tonumber(v2s[i]) then
                return 1
            elseif tonumber(v1s[i]) < tonumber(v2s[i]) then
                return -1
            end
        end
        if v1l > v2l then
            return 1
        elseif v1l < v2l then
            return -1
        end
        return 0
    end
}

-- MATH UTILS TABLE
local math_utils = {}
math_utils = {
    -- JUST RETURNS A TABLE WITH X AS X AND Y AS Y (for now)
    vector2 = function (x, y)
        return {x = x, y = y}
    end,
    -- MAPS A NUMBER FROM A RANGE TO ANOTHER ONE
    map = function (value, value_start, value_stop, return_start, return_stop, constrained)
        local mapped_value = (value - value_start) / (value_stop - value_start) * (return_stop - return_start) + return_start
        if constrained then return math_utils.constrain(mapped_value, return_start, return_stop); end
        return mapped_value
    end,
    -- CONSTRAINS A NUMBER TO A RANGE
    constrain = function (value, min_value, max_value)
        return math.min(max_value, math.max(min_value, value))
    end
}

-- EVENT UTILS TABLE
local event_utils = {
    -- USED TO CHECK IF AN AREA OF THE SCREEN WAS PRESSED
    is_area_pressed = function (press_x, press_y, x, y, width, height)
        if press_x >= x and press_x < x + width then
            if press_y >= y and press_y < y + height then
                return true
            end
        end
        return false
    end,
    -- USED TO FORMAT "RAW_EVENTS"
    -- RAW_EVENTS = {os.pullEvent()}
    format_event_table = function (event_table)
        local event = {}
        event.name = event_table[1]
        if event.name == "mouse_click" then
            event.name = const.TOUCH
            event.from = "terminal"
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
            return event
        elseif event.name == "monitor_touch" then
            event.name = const.TOUCH
            event.from = event_table[2]
            event.button = 1
            event.x = event_table[3]
            event.y = event_table[4]
            return event
        end
        table.remove(event_table, 1)
        event.parameters = event_table
        return event
    end
}

-- SETTING UTILS TABLE
local setting_utils = {
    -- PATH WHERE SETTINGS WILL BE SAVED (shouldn't be changed)
    _path = "/.settings",
    -- SETS SETTING AND THEN SAVES ALL SETTINGS
    set = function (self, name, value)
        settings.set(name, value)
        settings.save(self._path)
    end,
    -- UNSETS SETTING AND THEN SAVES ALL SETTINGS
    unset = function (self, name)
        settings.unset(name)
        settings.save(self._path)
    end,
    -- GETS SETTING AND RETURNS IT
    get = function (name)
        return settings.get(name)
    end
}

-- MONITOR UTILS TABLE
local monitor_utils = {
    -- RETURNS A TABLE WHICH CONTAINS ALL VALID MONITORS FROM monitor_names
    get_monitors = function (monitor_names)
        local monitors = {}
        for key, peripheral_name in pairs(monitor_names) do
            if peripheral_name == "terminal" then
                monitors[peripheral_name] = term
            else
                if peripheral.getType(peripheral_name) == "monitor" then
                    monitors[peripheral_name] = peripheral.wrap(peripheral_name)
                end
            end
        end
        return monitors
    end,
    -- PRINTS STRINGS ON SPECIFIED MONITOR WITH SPECIFIED FOREGROUND AND BACKGROUND
    better_print = function (monitor, foreground, background, ...)
        local strings = string_utils.join({...}, "")
        local old_foreground = monitor.getTextColor()
        local old_background = monitor.getBackgroundColor()

        if foreground then monitor.setTextColor(foreground); end
        if background then monitor.setBackgroundColor(background); end

        print(strings)

        monitor.setTextColor(old_foreground)
        monitor.setBackgroundColor(old_background)
    end
}

-- SCREEN BUFFER TABLE
local screen_buffer = {
    -- CONTAINS THE LAST DRAWN FRAME
    frame = {},
    -- TABLE THAT CONTAINS ALL SCREENS THAT THE BUFFER SHOULD DRAW TO
    screens = {
        terminal = term
    },
    -- BUFFER WILL BE CLEARED AFTER HAVING CALLED THE DRAW FUNCTION
    clear_after_draw = true,
    -- BUFFER STORES ALL PIXELS
    buffer = {
        pixels = {},
        background = colors.black,
        -- CHECKS IF SPECIFIED PIXEL WAS CREATED WITH "set_pixel" FUNCTION
        is_pixel_custom = function (self, x, y)
            x = tostring(x)
            y = tostring(y)
            if self.pixels[x] then
                if self.pixels[x][y] then
                    return true
                end
            end
            return false
        end,
        -- RETURNS PIXEL AT X, Y IF CUSTOM ELSE IT WILL RETURN THE DEFAULT PIXEL
        -- "DEFAULT PIXEL" IS THE BACKGROUND PIXEL
        get_pixel = function (self, x, y)
            x = tostring(x)
            y = tostring(y)
            if self:is_pixel_custom(x, y) then return self.pixels[x][y]; end
            return {
                char = " ",
                foreground = self.background,
                background = self.background
            }
        end,
        -- SETS PROPERTIES FOR A PIXEL SO IT ISN'T A "DEFAULT PIXEL" ANYMORE
        set_pixel = function (self, x, y, char, foreground, background)
            x = tostring(x)
            y = tostring(y)

            local pixel = self:get_pixel(x, y)

            if char and #char == 1 then pixel.char = char; end
            if foreground then pixel.foreground = foreground; end
            if background then pixel.background = background; end

            if not self.pixels[x] then self.pixels[x] = {}; end
            self.pixels[x][y] = pixel
        end,
        -- CLEARS PIXELS TABLE
        clear = function (self)
            self.pixels = {}
        end
    },
    set_screens = function (self, screen_names)
        self.screens = monitor_utils.get_monitors(screen_names)
    end,
    -- CLEARS BUFFER'S PIXELS TABLE
    clear = function (self)
        self.buffer:clear()
    end,
    -- DRAWS SCREEN BUFFER
    draw = function (self)
        local screens = self.screens
        local buffer = self.buffer
        
        for screen_name, screen in pairs(screens) do
            local old_bg = screen.getBackgroundColor()
            local old_fg = screen.getTextColor()
            local old_x, old_y = screen.getCursorPos()
            
            local width, height = screen.getSize()
            for x=1, width do
                for y=1, height do
                    screen.setCursorPos(x, y)
                    local pixel = buffer:get_pixel(x, y)
                    screen.setBackgroundColor(pixel.background)
                    screen.setTextColor(pixel.foreground)
                    screen.write(pixel.char)
                end
            end
            
            screen.setBackgroundColor(old_bg)
            screen.setTextColor(old_fg)
            screen.setCursorPos(old_x, old_y)
        end

        self.frame = self.buffer.pixels
        if self.clear_after_draw then self:clear(); end
    end,
    -- DRAWS A POINT ON THE SCREEN
    point = function (self, x, y, color)
        self.buffer:set_pixel(x, y, " ", color, color)
    end,
    -- WRITES A TEXT ON THE SCREEN
    write = function (self, x, y, text, foreground, background)
        for rel_x=0, #text - 1 do
            char = text:sub(rel_x + 1, rel_x + 1)
            self.buffer:set_pixel(x + rel_x, y, char, foreground, background)
        end
    end,
    -- DRAWS A RECTANGLE ON THE SCREEN
    rectangle = function (self, x, y, width, height, color)
        for rel_x=0, width - 1 do
            for rel_y=0, height - 1 do
                self:point(x + rel_x, y + rel_y, color)
            end
        end
    end,
    -- DRAWS A LINE ON THE SCREEN
    line = function (self, x1, y1, x2, y2, color) -- SOURCE: https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
        local function lineLow(x1, y1, x2, y2)
            local dir = 1
            if x1 > x2 then dir = -1; end
    
            local dx = x2 - x1
            local dy = y2 - y1
            local yi = 1
    
            if dy < 0 then
                yi = -1
                dy = -dy
            end
    
            local D = 2 * dy - dx
            local y = y1
    
            for x=x1, x2, dir do
                self:point(x, y, color) 
                if D > 0 then
                    y = y + yi
                    D = D - 2 * dx
                end
                D = D + 2 * dy
            end
        end
    
        local function lineHigh(x1, y1, x2, y2)
            local dir = 1
            if y1 > y2 then dir = -1; end
    
            local dx = x2 - x1
            local dy = y2 - y1
            local xi = 1
    
            if dx < 0 then
                xi = -1
                dx = -dx
            end
    
            local D = 2 * dx - dy
            local x = x1
    
            for y=y1, y2, dir do
                self:point(x, y, color)
                if D > 0 then
                    x = x + xi
                    D = D - 2 * dy
                end
                D = D + 2 * dx
            end
        end
    
        if math.abs(y2 - y1) < math.abs(x2 - x1) then
            if x1 > x2 then
                lineLow(x2, y2, x1, y1)
            else
                lineLow(x1, y1, x2, y2)
            end
        else
            if y1 > y2 then
                lineHigh(x2, y2, x1, y1)
            else
                lineHigh(x1, y1, x2, y2)
            end
        end
    end,
    -- DRAWS A CIRCLE ON THE SCREEN
    circle = function (self, xCenter, yCenter, radius, color) -- SOURCE: http://groups.csail.mit.edu/graphics/classes/6.837/F98/Lecture6/circle.html
    
        local r2 = radius * radius
    
        self:point(xCenter         , yCenter + radius, color)
        self:point(xCenter         , yCenter - radius, color)
        self:point(xCenter + radius, yCenter         , color)
        self:point(xCenter - radius, yCenter         , color)
    
        local x = 1
        local y = math.floor(math.sqrt(r2 - 1) + 0.5)
    
        while x < y do
            self:point(xCenter + x, yCenter + y, color)
            self:point(xCenter + x, yCenter - y, color)
            self:point(xCenter - x, yCenter + y, color)
            self:point(xCenter - x, yCenter - y, color)
            self:point(xCenter + y, yCenter + x, color)
            self:point(xCenter + y, yCenter - x, color)
            self:point(xCenter - y, yCenter + x, color)
            self:point(xCenter - y, yCenter - x, color)
    
            x = x + 1
            y = math.floor(math.sqrt(r2 - x * x) + 0.5)
        end
    
        if x == y then
            self:point(xCenter + x, yCenter + y, color)
            self:point(xCenter + x, yCenter - y, color)
            self:point(xCenter - x, yCenter + y, color)
            self:point(xCenter - x, yCenter - y, color)
        end
    end
}

-- SCREEN BUFFER TABLE
-- NOTE THAT NO VARIABLE FROM THIS TABLE SHOULD BE CHANGED MANUALLY
-- YOU CAN ONLY USE FUNCTIONS FROM THIS TABLE OR GET VARIABLES,
-- DON'T CHANGE THEM IF YOU WANT IT TO WORK
local WSS = {}
WSS = {
    -- SIDE WHERE THE MODEM IS
    side = nil,
    -- PROTOCOL WHERE THE HOST WILL BE CREATED OR SEARCHED IN
    protocol = "YAGUI-"..info.ver.."_WSS",
    -- PREFIX FOR HOST COMPUTERS
    host_prefix = "_Host:",
    -- DEFAULT TIMEOUT FOR client:listen()
    default_timeout = 0.5,
    -- OPENS REDNET ON SIDE
    open = function (self, side)
        rednet.open(side)
        self.side = side
    end,
    -- CLOSES REDNET ON SIDE
    close = function (self)
        rednet.close(self.side)
        self.side = nil
    end,
    -- FUNCTIONS TO MAKE AND MANAGE A WSS SERVER
    server = {
        -- LINK TO WSS TABLE
        root = {},
        -- NAME OF THE HOSTED SERVER
        servername = nil,
        -- HOSTNAME ON THE SERVER
        hostname = nil,
        -- HOSTS A WSS SERVER ON CURRENT COMPUTER AS hostname
        host = function (self, hostname)
            if not hostname then hostname = os.getComputerID(); end
            hostname = tostring(hostname)
            local servername = self.root.protocol..self.root.host_prefix..hostname
            
            if rednet.lookup(servername, hostname) then return false; end

            rednet.host(servername, hostname)
            self.servername = servername
            self.hostname = hostname
            return true
        end,
        -- UNHOSTS CURRENTLY RUNNING SERVER
        unhost = function (self)
            rednet.broadcast(
                const.DISCONNECTED,
                self.servername
            )
            rednet.unhost(self.servername, self.hostname)
            self.servername = nil
            self.hostname = nil
        end,
        -- BROADCASTS SCREEN_BUFFER TO ALL CONNECTED COMPUTERS
        broadcast = function (self)
            rednet.broadcast(
                {
                    background = screen_buffer.buffer.background,
                    frame = screen_buffer.frame
                },
                self.servername
            )
        end
    },
    -- FUNCTIONS TO CONNECT AND RECEIVE FROM A WSS SERVER
    client = {
        -- LINK TO WSS TABLE
        root = {},
        -- NAME OF THE SERVER WHERE THIS COMPUTER IS CONNECTED
        servername = nil,
        -- ID OF SERVER HOST
        host_id = nil,
        -- CONNECTS TO SERVER HOSTED BY hostname
        connect = function (self, hostname)
            local servername = self.root.protocol..self.root.host_prefix..hostname
            hostname = tostring(hostname)

            local ID = rednet.lookup(servername, hostname)
            if not ID then return false; end

            self.servername = servername
            self.host_id = ID

            return true
        end,
        -- DISCONNECTS FROM SERVER
        disconnect = function (self)
            self.servername = nil
            self.host_id = nil
        end,
        -- LISTENS FOR MESSAGES FROM THE SERVER
        listen = function (self, timeout)
            if not timeout then timeout = self.root.default_timeout; end
            local message = {rednet.receive(self.servername, timeout)}
            if message[1] == self.host_id then
                local buffer = message[2]
                if not buffer then return false; end
                if buffer == const.DISCONNECTED then return buffer; end
                screen_buffer.buffer.background = buffer.background
                screen_buffer.buffer.pixels = buffer.frame
                return true
            end
            return false
        end
    }
}
WSS.server.root = WSS
WSS.client.root = WSS

-- GUI ELEMENTS
local gui_elements = {}
gui_elements = {
    Clock = {
        new = function (interval)
            local newClock = {
                enabled = true,
                clock = os.clock(),
                interval = interval,
                callbacks = {
                    onClock = function() end
                }
            }
            setmetatable(newClock, gui_elements.Clock)
            return newClock
        end,
        event = function (self, formatted_event)
            if not self.enabled then self:reset_timer(); return; end
            if os.clock() >= self.clock + self.interval then
                self:reset_timer()
                self.callbacks.onClock(self, formatted_event)
            end
        end,
        reset_timer = function (self)
            self.clock = os.clock()
        end
    },
    Label = {
        new = function (x, y, text, foreground, background)
            local newLabel = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                text = text,
                pos = math_utils.vector2(x, y),
                colors = {
                    foreground = foreground,
                    background = background
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end
                }
            }
            setmetatable(newLabel, gui_elements.Label)
            return newLabel
        end,
        draw = function (self)
            self.callbacks.onDraw(self)
            screen_buffer:write(self.pos.x, self.pos.y, self.text, self.colors.foreground, self.colors.background)
        end,
        event = function (self, formatted_event)
            if formatted_event.name == const.TOUCH then
                if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, #self.text, 1) then
                    self.callbacks.onPress(self, formatted_event)
                end
            end
        end
    },
    Button = {
        new = function (x, y, width, height, text, foreground, active_background, unactive_background)
            local newButton = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                active = false,
                text = text,
                pos = math_utils.vector2(x, y),
                size = math_utils.vector2(width, height),
                timed = {
                    enabled = false,
                    clock = gui_elements.Clock.new(0.5)
                },
                colors = {
                    foreground = foreground,
                    active_background = active_background,
                    unactive_background = unactive_background
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end
                }
            }
            newButton.timed.clock.binded_button = newButton
            generic_utils.set_callback(
                newButton.timed.clock,
                const.ONCLOCK,
                function (self, formatted_event)
                    self.binded_button.active = false
                    self.binded_button.callbacks.onPress(self.binded_button, formatted_event)
                    self.enabled = false
                end
            )
            setmetatable(newButton, gui_elements.Button)
            return newButton
        end,
        draw = function (self)
            self.callbacks.onDraw(self)
            if self.active then 
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.active_background)
            else
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.unactive_background)
            end

            local text_lines = string_utils.split(self.text, "\n")
            local text_y = math.floor((self.size.y - #text_lines) / 2) + self.pos.y

            for rel_y=0, #text_lines - 1 do
                local value = text_lines[rel_y + 1]
                local line_x = math.floor((self.size.x - #value) / 2) + self.pos.x
                screen_buffer:write(line_x, text_y + rel_y, value, self.colors.foreground)
            end
        end,
        event = function (self, formatted_event)
            if formatted_event.name == const.TOUCH then
                if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    if self.timed.enabled then
                        self.timed.clock:reset_timer()
                        self.timed.clock.enabled = true
                        if not self.active then
                            self.active = true
                            self.callbacks.onPress(self, formatted_event)
                        end
                    else
                        self:press()
                        self.callbacks.onPress(self, formatted_event)
                    end
                    return true -- RETURNING TRUE DELETES THE EVENT
                end
            end
            if self.timed.enabled then self.timed.clock:event(formatted_event); end
        end,
        press = function (self)
            self.active = not self.active
        end
    },
    Progressbar = {
        new = function (x, y, width, height, current_value, min_value, max_value, foreground, filled_background, unfilled_background)
            local newProgressbar = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                active = false,
                pos = math_utils.vector2(x, y),
                size = math_utils.vector2(width, height),
                value = {
                    max = max_value,
                    min = min_value,
                    current = current_value,
                    draw_percentage = true
                },
                colors = {
                    foreground = foreground,
                    filled_background = filled_background,
                    unfilled_background = unfilled_background
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end
                }
            }
            setmetatable(newProgressbar, gui_elements.Progressbar)
            return newProgressbar
        end,
        draw = function (self)
            self.callbacks.onDraw(self)
            local value_percentage = math_utils.map(self.value.current, self.value.min, self.value.max, 0, 1, true)
            
            local filled_progress_width = math.floor(self.size.x * value_percentage)
            screen_buffer:rectangle(self.pos.x, self.pos.y, filled_progress_width, self.size.y, self.colors.filled_background)
            screen_buffer:rectangle(self.pos.x + filled_progress_width, self.pos.y, self.size.x - filled_progress_width, self.size.y, self.colors.unfilled_background)

            if self.value.draw_percentage then
                local percentage_text = tostring(value_percentage * 100).."%"
                local text_x = math.floor((self.size.x - #percentage_text) / 2) + self.pos.x
                local text_y = math.floor((self.size.y - 1) / 2) + self.pos.y
                screen_buffer:write(text_x, text_y, percentage_text, self.colors.foreground)
            end
        end,
        event = function (self, formatted_event)
            if formatted_event.name == const.TOUCH then
                if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    self.callbacks.onPress(self, formatted_event)
                end
            end
        end,
        set = function (self, value)
            local ranged_value = math_utils.constrain(value, self.value.min, self.value.max)
            self.value.current = ranged_value
        end
    }
}

gui_elements.Clock.__index = gui_elements.Clock
gui_elements.Label.__index = gui_elements.Label
gui_elements.Button.__index = gui_elements.Button
gui_elements.Progressbar.__index = gui_elements.Progressbar

-- LOOP TABLE
local Loop = {}
Loop = {
    -- CREATES A NEW LOOP
    new = function (FPS_target, EPS_target)
        local newLoop = {
            options = {
                enabled = false,
                FPS_target = FPS_target,
                EPS_target = EPS_target
            },
            monitors = {
                terminal = term
            },
            elements = {
                high_priority = {},
                low_priority = {},
                loop = {
                    clock = gui_elements.Clock.new(1 / FPS_target)
                }
            },
            callbacks = {
                onDraw = function () end,
                onClock = function () end,
                onEvent = function () end
            }
        }
        setmetatable(newLoop, Loop)
        return newLoop
    end,
    -- SETS THE MONITORS WHERE EVENTS CAN BE TAKEN FROM
    set_monitors = function (self, monitor_names)
        self.monitors = monitor_utils.get_monitors(monitor_names)
    end,
    -- SETS THE ELEMENTS THAT ARE GOING TO GET LOOP EVENTS
    set_elements = function (self, elements_table)
        self.elements.high_priority = {}
        self.elements.low_priority = {}
        for key, value in pairs(elements_table) do
            if value.draw_priority == const.HIGH_PRIORITY then
                table.insert(self.elements.high_priority, value)
            else
                table.insert(self.elements.low_priority, value)
            end
        end
    end,
    -- DRAWS ALL ELEMENTS ON SCREEN BUFFER AND DRAWS IT
    draw_elements = function (self)
        local function draw_table(tbl)
            for key=#tbl, 1, -1 do
                local element = tbl[key]
                if element.draw then
                    element:draw()
                end
            end
        end

        self.callbacks.onDraw(self)
        local old_screens = screen_buffer.screens
        screen_buffer.screens = self.monitors

        draw_table(self.elements.low_priority)
        draw_table(self.elements.high_priority)
        draw_table(self.elements.loop)

        screen_buffer:draw()
        screen_buffer.screens = old_screens
    end,
    -- GIVES AN EVENT TO ALL LOOP ELEMENTS
    event_elements = function (self, raw_event)
        local formatted_event = event_utils.format_event_table(raw_event)
        local function event_table(tbl)
            for key, element in pairs(tbl) do
                if element:event(formatted_event) then formatted_event = {name = const.DELETED}; end
            end
        end
        
        self.callbacks.onEvent(self, formatted_event)
        if formatted_event.name == const.TOUCH then
            local is_monitor_whitelisted = false
            for monitor_name, monitor in pairs(self.monitors) do
                if formatted_event.from == monitor_name then
                    is_monitor_whitelisted = true
                    break
                end
            end
            if not is_monitor_whitelisted then
                formatted_event = {name = const.DELETED}
            end
        end
        
        event_table(self.elements.loop)
        event_table(self.elements.high_priority)
        event_table(self.elements.low_priority)
    end,
    -- STARTS THE LOOP
    start = function (self)
        self.enabled = true
        generic_utils.set_callback(
            self.elements.loop.clock,
            const.ONCLOCK,
            function (CLOCK, formatted_event)
                self.callbacks.onClock(self, formatted_event)
                self:draw_elements()
            end
        )
        while self.enabled do
            local timer = os.startTimer(1 / self.options.EPS_target)
            local raw_event = {os.pullEvent()}

            self:event_elements(raw_event)

            os.cancelTimer(timer)
        end
    end,
    -- STOPS THE LOOP
    stop = function (self)
        self.enabled = false
    end
}

Loop.__index = Loop

-- TARGS
local tArgs = {...}
if tArgs[1] == "help" then
    local lines = {
        { text = "LIBFILE <COMMAND>"                                , foreground = colors.green , background = nil},
        { text = " - help (shows this list of commands)"            , foreground = colors.blue  , background = nil},
        { text = " - info (prints info about the lib)"              , foreground = colors.yellow, background = nil},
        { text = " - ver (prints version of the lib)"               , foreground = colors.green , background = nil},
        { text = " - copyright (prints copyright of the lib)"       , foreground = colors.blue  , background = nil},
        { text = " - setup (adds YAGUI_PATH to computer's settings)", foreground = colors.yellow, background = nil}
    }

    for key, line in pairs(lines) do
        monitor_utils.better_print(term, line.foreground, line.background, line.text)
    end
elseif tArgs[1] == "info" then
    monitor_utils.better_print(term, colors.red, nil, "Library Version: ", info.ver)
    monitor_utils.better_print(term, colors.yellow, nil, "Library Author: ", info.author)
    monitor_utils.better_print(term, colors.green, nil, "Library Website: ", info.website)
elseif tArgs[1] == "ver" then
    monitor_utils.better_print(term, colors.red, nil, "Library Version: ", info.ver)
elseif tArgs[1] == "copyright" then
    local paragraph_colors = {
        colors.red,
        colors.yellow,
        colors.green
    }
    local paragraphs = string_utils.split(info.copyright, "\n\n")

    for key, paragraph in pairs(paragraphs) do
        monitor_utils.better_print(term, paragraph_colors[key], nil, paragraph)
        if key < #paragraphs then read(""); end
    end
elseif tArgs[1] == "setup" then
    if shell then
        local settings_entry = "YAGUI_PATH"
        local path = "/"..shell.getRunningProgram()
        setting_utils:set(settings_entry, path)

        monitor_utils.better_print(term, colors.green, nil, "Lib path was set to ", setting_utils.get(settings_entry))
    else
        monitor_utils.better_print(term, colors.red, nil, "SHELL API ISN'T AVAILABLE")
    end
elseif tArgs[1] then
    monitor_utils.better_print(term, colors.red, nil, "UNKNOWN COMMAND: \"", tArgs[1], "\"")
    monitor_utils.better_print(term, colors.green, nil, "Use \"help\" to get a list of available commands!")
end

-- RETURNS LIB TO MAKE REQUIRE OR DOFILE WORK
local lib = {
    info = info,
    generic_utils = generic_utils,
    string_utils = string_utils,
    math_utils = math_utils,
    event_utils = event_utils,
    setting_utils = setting_utils,
    monitor_utils = monitor_utils,
    screen_buffer = screen_buffer,
    WSS = WSS,
    wireless_screen_share = WSS,
    gui_elements = gui_elements,
    Loop = Loop
}

-- MAKE CONSTANTS BE GLOBAL VARIABLES OF THE LIBRARY
for key, value in pairs(const) do
    lib[key] = value
end

return lib
