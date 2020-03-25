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

-- INFO MODULE
local info = {
    ver = "1.20",
    author = "hds536jhmk",
    website = "https://github.com/hds536jhmk/YAGUI/",
    documentation = "https://hds536jhmk.github.io/YAGUI/",
    copyright = "Copyright (c) 2019, hds536jhmk : https://github.com/hds536jhmk/YAGUI\n\nPermission to use, copy, modify, and/or distribute this software for any\npurpose with or without fee is hereby granted, provided that the above\ncopyright notice and this permission notice appear in all copies.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\" AND THE AUTHOR DISCLAIMS ALL WARRANTIES\nWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF\nMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR\nANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES\nWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN\nACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF\nOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE."
}

-- CONSTANTS MODULE
-- THESE WILL BE TRANSFORMED IN GLOBAL VARIABLES WHEN LIBRARY IS RETURNED
local const = {
    TOUCH = "screen_touch",
    MOUSEUP = "mouse_up",
    MOUSEDRAG = "mouse_drag",
    MOUSESCROLL = "mouse_scroll",
    CHAR = "char",
    KEY = "key",
    KEYUP = "key_up",
    PASTE = "paste",
    DELETED = "DELETED",
    DISCONNECTED = "DISCONNECTED",
    LOW_PRIORITY = 1,
    HIGH_PRIORITY = 2,
    ONSTART = 1,
    ONSTOP = 2,
    ONDRAW = 3,
    ONPRESS = 4,
    ONFAILEDPRESS = 5,
    ONTIMEOUT = 6,
    ONCLOCK = 7,
    ONEVENT = 8,
    ONFOCUS = 9,
    ONKEY = 10,
    ONCHAR = 11,
    ONMOUSESCROLL = 12,
    MOUSE_LEFT = 1,
    MOUSE_RIGHT = 2,
    MOUSE_MIDDLE = 3,
    SCROLL_UP = -1,
    SCROLL_DOWN = 1,
    COMPUTER = "computer",
    TURTLE = "turtle",
    POCKET = "pocket",
    ALIGN_LEFT = 1,
    ALIGN_CENTER = 2
}

for key_name, key in next, keys do
    if type(key) == "number" then
        const["KEY_"..key_name:upper()] = key
    end
end

-- DEFINING ALL UTILITIES HERE TO BE ABLE TO ACCESS THEM EVERYWHERE
local generic_utils = {}
local string_utils = {}
local math_utils = {}
local table_utils = {}
local color_utils = {}
local event_utils = {}
local setting_utils = {}
local monitor_utils = {}

-- GENERIC UTILS MODULE
generic_utils = {
    -- SETS A CALLBACK TO THE SPECIFIED OBJECT
    set_callback = function (gui_element, event, callback)
        if event == const.ONSTART then
            gui_element.callbacks.onStart = callback
        elseif event == const.ONSTOP then
            gui_element.callbacks.onStop = callback
        elseif event == const.ONDRAW then
            gui_element.callbacks.onDraw = callback
        elseif event == const.ONPRESS then
            gui_element.callbacks.onPress = callback
        elseif event == const.ONFAILEDPRESS then
            gui_element.callbacks.onFailedPress = callback
        elseif event == const.ONTIMEOUT then
            gui_element.callbacks.onTimeout = callback
        elseif event == const.ONCLOCK then
            gui_element.callbacks.onClock = callback
        elseif event == const.ONEVENT then
            gui_element.callbacks.onEvent = callback
        elseif event == const.ONFOCUS then
            gui_element.callbacks.onFocus = callback
        elseif event == const.ONKEY then
            gui_element.callbacks.onKey = callback
        elseif event == const.ONCHAR then
            gui_element.callbacks.onChar = callback
        elseif event == const.ONMOUSESCROLL then
            gui_element.callbacks.onMouseScroll = callback
        end
    end,
    -- RETURNS THE TYPE OF COMPUTER (computer, turtle, pocket) THAT IS BEING USED
    get_computer_type = function ()
        local comp_type = const.COMPUTER
        if turtle then
            comp_type = const.TURTLE
        elseif pocket then
            comp_type = const.POCKET
        end
        return comp_type, term.isColor()
    end,
    -- ERRORS IF EVEN ... ARGUMENTS AREN'T OF SPECIFIED TYPE IN PREVIOUS STRING ARGUMENT
    expect = function (context, ...)
        local t = {...}
        local type_separators = "[/%.,]"

        context = context or "unknown"
        context = tostring(context)

        local should_error = false
        local error_msg

        for i=1, #t, 2 do
            local types_string = tostring(t[i])

            local this_should_error = true
            local bad_type

            for k, required_type in next, string_utils.split(types_string, type_separators) do
                local this_value = t[i + 1]
                local this_value_type = type(this_value)

                if this_value_type ~= required_type then
                    bad_type = this_value_type
                else
                    this_should_error = false
                    break
                end
            end

            if this_should_error then
                local error_types = types_string:gsub(type_separators, ", ")
                error_msg = string.format(
                    "\"%s\": Bad argument #%d (expected %s, got %s)",
                    context, (i + 1) / 2, error_types, bad_type
                )
                should_error = true
                break
            end
        end

        if should_error then
            error(error_msg, 3)
            return false
        end

        return true
    end
}

-- STRING UTILS MODULE
string_utils = {
    magic_characters = {"(", ")", ".", "%", "+", "-", "*", "?", "[", "]", "^", "$"},
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
    -- SPLITS STRING EVERY TIME SEPARATOR IS FOUND
    split = function (str, sep)
        if not string.find(str, sep) then
           return {str}
        end
        local return_table = {}
        local pattern = "(.*)"..sep.."()"
        local last_pos
        for this_match, pos in string.gfind(str, pattern) do
           table.insert(return_table, this_match)
           last_pos = pos
        end
        table.insert(return_table, string.sub(str, last_pos))
        return return_table
    end,
    -- COMPARES V1 AND V2 AND IF V1 IS NEWER THAN V2 THEN IT RETURNS 1, IF THEY'RE THE SAME IT RETURNS 0 ELSE IT RETURNS -1
    -- v1 = "0.2"; v2 = "0.1" -> returns 1
    -- v1 = "0.1"; v2 = "0.1" -> returns 0
    -- v1 = "0.1"; v2 = "0.2" -> returns -1
    compare_versions = function (v1, v2)
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
    end,
    -- ESCAPES ALL MAGIC CHARACTERS IN A STRING
    escape_magic_characters = function (str)
        for key, character in next, string_utils.magic_characters do
            str = str:gsub("[%"..character.."]", '%%%'..character)
        end
        return str
    end,
    -- GETS THE EXTENSION OF PATH
    get_extension = function (path)
        local extension, found = path:gsub(".*%.", "")
        if found > 0 then
            return extension
        end
        return ""
    end,
    -- FORMATS A NUMBER SO THAT IT HAS precision DECIMAL DIGITS AND TRUNCATES IT AT THE LAST SIGNIFICANT DIGIT
    format_number = function (number, precision)
        number = tostring(number)
        precision = precision or 0

        local unit = number:gsub("(.*)%..*", "%1")
        if precision <= 0 then
            return unit
        end

        local on_dot = #unit + 1
        local decimal_digits = number:sub(on_dot + 1, on_dot + precision)
        decimal_digits = decimal_digits:reverse():gsub("0*(.*)", "%1"):reverse()

        if #decimal_digits > 0 then
            return unit.."."..decimal_digits
        end

        return unit
    end,
    -- REMOVES EXTRA SPACES BEFORE AND AFTER THE SPECIFIED STRING
    trim = function (str)
        return (str:gsub("^%s*(.*)%s*$", "%1"))
    end
}

-- MATH UTILS MODULE
math_utils = {
    -- A 2D VECTOR
    Vector2 = {
        -- RETURNS NEW VECTOR2
        new = function (x, y)
            local newVector2 = {
                x = x or 0,
                y = y or 0
            }
            setmetatable(newVector2, math_utils.Vector2)
            return newVector2
        end,
        -- RETURNS DUPLICATE OF THE VECTOR
        duplicate = function (self)
            return math_utils.Vector2.new(self.x, self.y)
        end,
        -- RETURNS VECTOR LENGTH SQUARED
        length_sq = function (self)
            return math.pow(self.x, 2) + math.pow(self.y, 2)
        end,
        -- RETURNS VECTOR LENGTH
        length = function (self)
            return math.sqrt(self:length_sq())
        end,
        -- RETURNS UNIT VECTOR
        unit = function (self)
            return self / self:length()
        end,
        -- RETURNS THE DOT PRODUCT BETWEEN TWO VECTORS
        dot = function (self, other)
            return self.x * other.x + self.y * other.y
        end,
        -- RETURNS THE CROSS PRODUCT BETWEEN TWO VECTORS
        cross = function (self, other)
            return self.x * other.y - self.y * other.x
        end,
        -- RETURNS A VECTOR THAT IS ROTATED BY angle
        rotate = function (self, angle)
            local angle_cos = math.cos(angle)
            local angle_sin = math.sin(angle)
            return math_utils.Vector2.new(
                angle_cos * self.x - angle_sin * self.y,
                angle_sin * self.x + angle_cos * self.y
            )
        end,
        -- RETURNS tostring(Vector1) WITH precision DECIMAL NUMBERS
        string = function (self, precision)
            if precision then
                return string.format("(%."..tostring(precision).."f; %."..tostring(precision).."f)", self.x, self.y)
            else
                return string.format("(%f; %f)", self.x, self.y)
            end
        end,
        -- TOSTRING METAMETHOD, handles tostring(Vector1)
        __tostring = function (self)
            return self:string(0)
        end,
        -- ADD METAMETHOD, handles Vector1 + Vector2
        __add = function (self, other)
            return math_utils.Vector2.new(self.x + other.x, self.y + other.y)
        end,
        -- SUB METAMETHOD, handles Vector1 - Vector2
        __sub = function (self, other)
            return math_utils.Vector2.new(self.x - other.x, self.y - other.y)
        end,
        -- MUL METAMETHOD, handles Vector1 * number
        __mul = function (self, number)
            if type(self) == "number" then
                return math_utils.Vector2.new(number.x * self, number.y * self)
            else
                return math_utils.Vector2.new(self.x * number, self.y * number)
            end
        end,
        -- DIV METAMETHOD, handles Vector1 / number
        __div = function (self, number)
            return math_utils.Vector2.new(self.x / number, self.y / number)
        end,
        -- EQUAL METAMETHOD, handles Vector1 == Vector2
        __eq = function (self, other)
            return self.x == other.x and self.y == other.y
        end,
        -- LESS THAN METAMETHOD, handles Vector1 < Vector2; Vector1 > Vector2
        __lt = function (self, other)
            return self:length_sq() < other:length_sq()
        end,
        -- LESS OR EQUAL METAMETHOD, handles Vector1 <= Vector2; Vector1 >= Vector2
        __le = function (self, other)
            return self:length_sq() <= other:length_sq()
        end
    },
    -- A 3D VECTOR
    Vector3 = {
        -- RETURNS NEW VECTOR3
        new = function (x, y, z)
            local newVector3 = {
                x = x or 0,
                y = y or 0,
                z = z or 0
            }
            setmetatable(newVector3, math_utils.Vector3)
            return newVector3
        end,
        -- RETURNS DUPLICATE OF THE VECTOR
        duplicate = function (self)
            return math_utils.Vector3.new(self.x, self.y, self.z)
        end,
        -- RETURNS VECTOR LENGTH SQUARED
        length_sq = function (self)
            return math.pow(self.x, 2) + math.pow(self.y, 2) + math.pow(self.z, 2)
        end,
        -- RETURNS VECTOR LENGTH
        length = function (self)
            return math.sqrt(self:length_sq())
        end,
        -- RETURNS UNIT VECTOR
        unit = function (self)
            return self / self:length()
        end,
        -- RETURNS THE DOT PRODUCT BETWEEN TWO VECTORS
        dot = function (self, other)
            return self.x * other.x + self.y * other.y + self.z * other.z
        end,
        -- RETURNS THE CROSS PRODUCT BETWEEN TWO VECTORS
        cross = function (self, other)
            return math_utils.Vector3.new(
                self.y * other.z - self.z * other.y,
                self.z * other.x - self.x * other.z,
                self.x * other.y - self.y * other.x
            )
        end,
        -- RETURNS A VECTOR THAT IS ROTATED ON axis BY angle
        rotate = function (self, axis, angle)
            local angle_cos = math.cos(angle)
            return angle_cos * self + math.sin(angle) * axis:cross(self) + (1 - angle_cos) * axis:dot(self) * axis
        end,
        -- RETURNS tostring(Vector1) WITH precision DECIMAL NUMBERS
        string = function (self, precision)
            if precision then
                return string.format("(%."..tostring(precision).."f; %."..tostring(precision).."f; %."..tostring(precision).."f)", self.x, self.y, self.z)
            else
                return string.format("(%f; %f; %f)", self.x, self.y, self.z)
            end
        end,
        -- TOSTRING METAMETHOD, handles tostring(Vector1)
        __tostring = function (self)
            return self:string(0)
        end,
        -- ADD METAMETHOD, handles Vector1 + Vector2
        __add = function (self, other)
            return math_utils.Vector3.new(self.x + other.x, self.y + other.y, self.z + other.z)
        end,
        -- SUB METAMETHOD, handles Vector1 - Vector2
        __sub = function (self, other)
            return math_utils.Vector3.new(self.x - other.x, self.y - other.y, self.z - other.z)
        end,
        -- MUL METAMETHOD, handles Vector1 * number
        __mul = function (self, number)
            if type(self) == "number" then
                return math_utils.Vector3.new(number.x * self, number.y * self, number.z * self)
            else
                return math_utils.Vector3.new(self.x * number, self.y * number, self.z * number)
            end
        end,
        -- DIV METAMETHOD, handles Vector1 / number
        __div = function (self, number)
            return math_utils.Vector3.new(self.x / number, self.y / number, self.z / number)
        end,
        -- EQUAL METAMETHOD, handles Vector1 == Vector2
        __eq = function (self, other)
            return self.x == other.x and self.y == other.y and self.z == other.z
        end,
        -- LESS THAN METAMETHOD, handles Vector1 < Vector2; Vector1 > Vector2
        __lt = function (self, other)
            return self:length_sq() < other:length_sq()
        end,
        -- LESS OR EQUAL METAMETHOD, handles Vector1 <= Vector2; Vector1 >= Vector2
        __le = function (self, other)
            return self:length_sq() <= other:length_sq()
        end
    },
    -- MAPS A NUMBER FROM A RANGE TO ANOTHER ONE
    map = function (value, value_start, value_stop, return_start, return_stop, constrained)
        local mapped_value = (value - value_start) / (value_stop - value_start) * (return_stop - return_start) + return_start
        if constrained then return math_utils.constrain(mapped_value, return_start, return_stop); end
        return mapped_value
    end,
    -- CONSTRAINS A NUMBER TO A RANGE
    constrain = function (value, min_value, max_value)
        return math.min(max_value, math.max(min_value, value))
    end,
    -- ROUNDS A NUMBER AND RETURNS IT
    round = function (number)
        return math.floor(number + 0.5)
    end,
    -- ROUNDS ALL SPECIFIED NUMBERS AND RETURNS THEM IN THE SAME ORDER
    round_numbers = function (...)
        local numbers = {...}
        local rounded = {}
        for key, number in next, numbers do
            table.insert(rounded, math_utils.round(number))
        end
        return table.unpack(rounded)
    end,
    -- FLOORS ALL SPECIFIED NUMBERS AND RETURNS THEM IN THE SAME ORDER
    floor_numbers = function (...)
        local numbers = {...}
        local floored = {}
        for key, number in next, numbers do
            table.insert(floored, math.floor(number))
        end
        return table.unpack(floored)
    end,
    -- CEILS ALL SPECIFIED NUMBERS AND RETURNS THEM IN THE SAME ORDER
    ceil_numbers = function (...)
        local numbers = {...}
        local ceiled = {}
        for key, number in next, numbers do
            table.insert(ceiled, math.ceil(number))
        end
        return table.unpack(ceiled)
    end
}

math_utils.Vector2.__index = math_utils.Vector2
math_utils.Vector3.__index = math_utils.Vector3

math_utils.Vector2.ONE   = math_utils.Vector2.new( 1,  1)
math_utils.Vector2.UP    = math_utils.Vector2.new( 0, -1)
math_utils.Vector2.DOWN  = math_utils.Vector2.new( 0,  1)
math_utils.Vector2.LEFT  = math_utils.Vector2.new(-1,  0)
math_utils.Vector2.RIGHT = math_utils.Vector2.new( 1,  0)
math_utils.Vector2.ZERO  = math_utils.Vector2.new( 0,  0)

math_utils.Vector3.ONE     = math_utils.Vector3.new( 1,  1,  1)
math_utils.Vector3.UP      = math_utils.Vector3.new( 0,  1,  0)
math_utils.Vector3.DOWN    = math_utils.Vector3.new( 0, -1,  0)
math_utils.Vector3.LEFT    = math_utils.Vector3.new(-1,  0,  0)
math_utils.Vector3.RIGHT   = math_utils.Vector3.new( 1,  0,  0)
math_utils.Vector3.FORWARD = math_utils.Vector3.new( 0,  0,  1)
math_utils.Vector3.BACK    = math_utils.Vector3.new( 0,  0, -1)
math_utils.Vector3.ZERO    = math_utils.Vector3.new( 0,  0,  0)

-- TABLE UTILS MODULE
table_utils = {
    -- CHECKS IF THERE'S THE SPECIFIED VALUE IN THE TABLE, IF VALUE WAS FOUND
    --  IT RETURNS TRUE AND THE KEY OF THE TABLE WHERE THE VALUE IS
    has_value = function (tbl, value)
        for tbl_key, tbl_value in next, tbl do
            if tbl_value == value then return true, tbl_key; end
        end
        return false, nil
    end,
    -- CHECKS IF THERE'S THE SPECIFIED KEY IN THE TABLE, IF KEY WAS FOUND
    --  IT RETURNS TRUE AND THE VALUE AT KEY IN THE TABLE
    has_key = function (tbl, key)
        if tbl[key] ~= nil then return true, tbl[key]; end
        return false, nil
    end,
    -- A more advanced table serializer than textutils.serialise
    --  - Doesn't error with functions, it just turns them into tostring(function) (they can't be unserialized correctly).
    --  - Has a depth field which can be used to serialize recursive tables without getting an error.
    serialise = function (tbl, depth, pretty, serialise_metatables, serialise_index, indent, new_line, space)
        local depth = depth or 0
        local indent = indent or "  "
        local current_depth = 0
        
        local new_line = new_line or "\n"
        local space = space or " "
        
        if not pretty then indent, new_line, space = "", "", ""; end
        
        local function i_tbl_serialize(tbl)
            local this_indent = indent:rep(current_depth + 1)
            local str_tbl = "{"..new_line

            local function add_tbl(tbl)
                for key, value in next, tbl do
                    local key_type = type(key)
                    local key_string
                    if key_type == "string" then
                        key_string = string.format("%q", key)
                    else
                        key_string = tostring(key)
                    end

                    if not serialise_index and (key == "__index") then value = {}; end

                    local value_type = type(value)
                    local value_string = tostring(value)
                    
                    str_tbl = str_tbl..string.format("%s[%s]%s=%s", this_indent, key_string, space, space)
                    if value_type == "table" then
                        if current_depth < depth then
                            current_depth = current_depth + 1
                            str_tbl = str_tbl..i_tbl_serialize(value)
                            current_depth = current_depth - 1
                        else
                            str_tbl = str_tbl.."{}"
                        end
                    elseif (value_type == "string") or (value_type == "function") then
                        str_tbl = str_tbl..string.format("%q", value_string)
                    else
                        str_tbl = str_tbl..string.format("%s", value_string)
                    end
                    if next(tbl, key) then
                        str_tbl = str_tbl..","..new_line
                    else
                        str_tbl = str_tbl..new_line
                    end
                end
            end
            local metatable = getmetatable(tbl)
            if serialise_metatables and metatable then
                add_tbl(metatable)
                if next(tbl) then
                    str_tbl = str_tbl:sub(1, #str_tbl - #new_line)..","..str_tbl:sub(#str_tbl - #new_line + 1)
                end
            end
            
            add_tbl(tbl)
            str_tbl = str_tbl..indent:rep(current_depth).."}"
            return str_tbl
        end
        
        return i_tbl_serialize(tbl)
    end,
    -- Just copies of unserialise functions in textutils
    unserialise = textutils.unserialise,
    unserialize = textutils.unserialize
}

table_utils.serialize = table_utils.serialise

-- COLOR UTILS MODULE
color_utils = {
    colors = {
        [ 1 ] = "0",
        [ 2 ] = "1",
        [ 4 ] = "2",
        [ 8 ] = "3",
        [ 16 ] = "4",
        [ 32 ] = "5",
        [ 64 ] = "6",
        [ 128 ] = "7",
        [ 256 ] = "8",
        [ 512 ] = "9",
        [ 1024 ] = "a",
        [ 2048 ] = "b",
        [ 4096 ] = "c",
        [ 8192 ] = "d",
        [ 16384 ] = "e",
        [ 32768 ] = "f"
    },
    -- TAKES A DECIMAL VALUE FROM COLORS API AND RETURNS ITS PAINT VALUE
    color_to_paint = function (color)
        return color_utils.colors[color]
    end,
    -- TAKES A PAINT AND RETURNS ITS DECIMAL VALUE FROM COLORS API
    paint_to_color = function (paint)
        local has, color = table_utils.has_value(color_utils.colors, paint)
        if has then return color; end
    end
}

-- EVENT UTILS MODULE
event_utils = {
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
        elseif event.name == "mouse_drag" then
            event.name = const.MOUSEDRAG
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
            return event
        elseif event.name == "mouse_up" then
            event.name = const.MOUSEUP
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
            return event
        elseif event.name == "mouse_scroll" then
            event.name = const.MOUSESCROLL
            event.direction = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
            return event
        elseif event.name == "char" then
            event.name = const.CHAR
            event.char = event_table[2]
            return event
        elseif event.name == "key" then
            event.name = const.KEY
            event.key = event_table[2]
            return event
        elseif event.name == "key_up" then
            event.name = const.KEYUP
            event.key = event_table[2]
            return event
        elseif event.name == "paste" then
            event.name = const.PASTE
            event.paste = event_table[2]
            return event
        end
        table.remove(event_table, 1)
        event.parameters = event_table
        return event
    end
}

-- SETTING UTILS MODULE
setting_utils = {
    -- PATH WHERE SETTINGS WILL BE SAVED (shouldn't be changed)
    _path = "/.settings",
    -- SETS SETTING AND THEN SAVES ALL SETTINGS
    set = function (name, value)
        settings.set(name, value)
        settings.save(setting_utils._path)
    end,
    -- UNSETS SETTING AND THEN SAVES ALL SETTINGS
    unset = function (name)
        settings.unset(name)
        settings.save(setting_utils._path)
    end,
    -- GETS SETTING AND RETURNS IT
    get = function (name)
        return settings.get(name)
    end
}

-- MONITOR UTILS MODULE
monitor_utils = {
    -- RETURNS A TABLE WHICH CONTAINS ALL VALID MONITORS FROM monitor_names
    get_monitors = function (monitor_names)
        local monitors = {}
        for key, peripheral_name in next, monitor_names do
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
    end,
    -- CLEARS SPECIFIED MONITOR AND SETS CURSOR TO 1, 1
    better_clear = function (monitor)
        monitor.clear()
        monitor.setCursorPos(1, 1)
    end

}

-- SCREEN BUFFER MODULE
local screen_buffer = {
    -- CONTAINS THE LAST DRAWN FRAME
    frame = {
        pixels = {},
        background = nil
    },
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
            if self:is_pixel_custom(x, y) then return self.pixels[x][y]; end
            return {
                char = " ",
                foreground = self.background,
                background = self.background
            }
        end,
        -- SETS PROPERTIES FOR A PIXEL SO IT ISN'T A "DEFAULT PIXEL" ANYMORE
        set_pixel = function (self, x, y, char, foreground, background)
            local pixel = self:get_pixel(x, y)

            if char and #char == 1 then pixel.char = char; end
            pixel.foreground = foreground or pixel.background
            pixel.background = background or pixel.background

            if not self.pixels[x] then self.pixels[x] = {}; end
            self.pixels[x][y] = pixel
        end,
        -- CLEARS PIXELS TABLE
        clear = function (self)
            self.pixels = {}
        end
    },
    -- SETS ALL SCREENS IN screen_names AS SCREENS WHERE THE BUFFER IS GOING TO DRAW TO
    set_screens = function (self, screen_names)
        self.screens = monitor_utils.get_monitors(screen_names)
    end,
    -- DUPLICATE OF set_screens
    set_monitors = function (self, monitor_names)
        self:set_screens(monitor_names)
    end,
    -- CLEARS BUFFER'S PIXELS TABLE
    clear = function (self)
        self.buffer:clear()
    end,
    -- DRAWS SCREEN BUFFER
    draw = function (self)
        local screens = self.screens
        local buffer = self.buffer
        
        for screen_name, screen in next, screens do
            local old_x, old_y = screen.getCursorPos()
            
            local width, height = screen.getSize()
            for y=1, height do
                local row = {text = "", background = "", foreground = ""}
                for x=1, width do
                    local pixel = buffer:get_pixel(x, y)
                    row.text = row.text..pixel.char
                    row.background = row.background..color_utils.colors[pixel.background]
                    row.foreground = row.foreground..color_utils.colors[pixel.foreground]
                end
                screen.setCursorPos(1, y)
                screen.blit(row.text, row.foreground, row.background)
            end
            screen.setCursorPos(old_x, old_y)
        end

        self.frame.pixels = self.buffer.pixels
        self.frame.background = self.buffer.background
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

-- INPUT MODULE
-- Usually managed by loops
local input = {
    -- STORES ALL KEYS THAT ARE PRESSED
    pressed_keys = {},
    -- RESETS pressed_keys TABLE
    reset = function (self)
        self.pressed_keys = {}
    end,
    -- CHECKS IF KEY IS PRESSED
    --  if remove_key is set to true then if the key is pressed it will be removed from the pressed_keys table
    is_key_pressed = function (self, remove_key, key)
        if self.pressed_keys[key] then
            if remove_key then
                self:remove_key(key)
            end
            return true
        end
        return false
    end,
    -- CHECKS IF KEYS ARE PRESSED
    --  if remove_keys is set to true then if the keys are pressed they will be removed from the pressed_keys table
    are_keys_pressed = function (self, remove_keys, ...)
        local keys = {...}
        if not (#keys > 0) then return false; end
        for _, key in next, keys do
            if not self:is_key_pressed(false, key) then return false; end
        end
        if remove_keys then
            self:remove_keys(table.unpack(keys))
        end
        return true
    end,
    -- ADDS A KEY INTO pressed_keys
    add_key = function (self, key)
        self.pressed_keys[key] = true
    end,
    -- REMOVES A KEY FROM pressed_keys
    remove_key = function (self, key)
        self.pressed_keys[key] = nil
    end,
    -- REMOVES KEYS FROM pressed_keys
    remove_keys = function (self, ...)
        local keys = {...}
        for _, key in next, keys do
            self:remove_key(key)
        end
    end,
    -- GETS AN EVENT AND CHECKS IF ANY KEY WAS PRESSED OR RELEASED
    manage_event = function (self, formatted_event)
        if formatted_event.name == const.KEY then
            self:add_key(formatted_event.key)
        elseif formatted_event.name == const.KEYUP then
            self:remove_key(formatted_event.key)
        end
    end
}

-- WSS MODULE
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
            
            if rednet.lookup(servername, hostname) then return false, hostname; end

            rednet.host(servername, hostname)
            self.servername = servername
            self.hostname = hostname
            return true, hostname
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
                screen_buffer.frame,
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
            hostname = tostring(hostname)
            local servername = self.root.protocol..self.root.host_prefix..hostname

            local ID = rednet.lookup(servername, hostname)
            if not ID then return false, hostname; end

            self.servername = servername
            self.host_id = ID

            return true, hostname
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
                screen_buffer.buffer.pixels = buffer.pixels
                return true
            end
            return false
        end
    }
}
WSS.server.root = WSS
WSS.client.root = WSS

-- GUI ELEMENTS MODULE
local gui_elements = {}
gui_elements = {
    Clock = {
        -- RETURNS NEW CLOCK
        new = function (interval)
            local newClock = {
                enabled = true,
                oneshot = false,
                clock = os.clock(),
                interval = interval,
                callbacks = {
                    onClock = function() end
                }
            }
            setmetatable(newClock, gui_elements.Clock)
            return newClock
        end,
        -- GIVES EVENT TO CLOCK
        event = function (self, formatted_event)
            if not self.enabled then self:reset_timer(); return; end
            if os.clock() >= self.clock + self.interval then
                self:reset_timer()
                self.callbacks.onClock(self, formatted_event)
                if self.oneshot then self:stop() end
            end
        end,
        -- STARTS CLOCK
        start = function (self)
            self:reset_timer()
            self.enabled = true
        end,
        -- STOPS CLOCK
        stop = function (self)
            self.enabled = false
        end,
        -- RESETS CLOCK TIME
        reset_timer = function (self)
            self.clock = os.clock()
        end
    },
    Label = {
        -- RETURNS NEW LABEL
        new = function (x, y, text, foreground, background)
            local newLabel = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                text_alignment = const.ALIGN_CENTER,
                text = text,
                pos = math_utils.Vector2.new(x, y),
                colors = {
                    foreground = foreground,
                    background = background
                },
                callbacks = {
                    onDraw = function () end
                }
            }
            setmetatable(newLabel, gui_elements.Label)
            return newLabel
        end,
        -- DRAWS LABEL
        draw = function (self)
            if self.hidden then return; end
            self.callbacks.onDraw(self)

            
            local lines = string_utils.split(self.text, "\n")

            if self.text_alignment == const.ALIGN_LEFT then
                for key, line in next, lines do
                    screen_buffer:write(self.pos.x, self.pos.y + key - 1, line, self.colors.foreground, self.colors.background)
                end
            elseif self.text_alignment == const.ALIGN_CENTER then
                local x_center_offset = 0

                for key, line in next, lines do
                    if key == 1 then
                        x_center_offset = math.floor(#line / 2)
                        screen_buffer:write(self.pos.x, self.pos.y, line, self.colors.foreground, self.colors.background)
                    else
                        screen_buffer:write(self.pos.x + x_center_offset - math.floor(#line / 2), self.pos.y + key - 1, line, self.colors.foreground, self.colors.background)
                    end
                end
            end
        end
    },
    Button = {
        -- RETURNS NEW BUTTON
        new = function (x, y, width, height, text, foreground, active_background, unactive_background)
            local newButton = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                active = false,
                shortcut_once = true,
                shortcut = {},
                text_alignment = const.ALIGN_CENTER,
                text = text,
                pos = math_utils.Vector2.new(x, y),
                size = math_utils.Vector2.new(width, height),
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
                    onPress = function () end,
                    onFailedPress = function () end,
                    onTimeout = function () end
                }
            }
            newButton.timed.clock.binded_button = newButton
            newButton.timed.clock.oneshot = true
            newButton.timed.clock:stop()
            generic_utils.set_callback(
                newButton.timed.clock,
                const.ONCLOCK,
                function (self, formatted_event)
                    self.binded_button.active = false
                    self.binded_button.callbacks.onPress(self.binded_button, formatted_event)
                    self.binded_button.callbacks.onTimeout(self.binded_button, formatted_event)
                end
            )
            setmetatable(newButton, gui_elements.Button)
            return newButton
        end,
        -- DRAWS BUTTON
        draw = function (self)
            if self.hidden then return; end
            self.callbacks.onDraw(self)
            if self.active then 
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.active_background)
            else
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.unactive_background)
            end

            local lines = string_utils.split(self.text, "\n")
            local text_y = math.floor((self.size.y - #lines) / 2) + self.pos.y

            for rel_y=0, #lines - 1 do
                local line = lines[rel_y + 1]
                local line_x
                if self.text_alignment == const.ALIGN_LEFT then
                    line_x = self.pos.x
                elseif self.text_alignment == const.ALIGN_CENTER then
                    line_x = math.floor((self.size.x - #line) / 2) + self.pos.x
                end
                screen_buffer:write(line_x, text_y + rel_y, line, self.colors.foreground)
            end
        end,
        -- GIVES EVENT TO BUTTON
        event = function (self, formatted_event)
            if self.hidden then return false; end
            if formatted_event.name == const.TOUCH then
                if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    self:press(formatted_event)
                    return true -- RETURNING TRUE DELETES THE EVENT
                else
                    self.callbacks.onFailedPress(self, formatted_event)
                end
            elseif input:are_keys_pressed(self.shortcut_once, table.unpack(self.shortcut)) then
                self:press(formatted_event)
            end
            if self.timed.enabled then self.timed.clock:event(formatted_event); end
        end,
        press = function (self, formatted_event)
            if self.timed.enabled then
                self.timed.clock:start()
                if not self.active then
                    self.active = true
                    self.callbacks.onPress(self, formatted_event)
                end
            else
                self.active = not self.active
                self.callbacks.onPress(self, formatted_event)
            end
        end
    },
    Progressbar = {
        -- RETURNS NEW PROGRESSBAR
        new = function (x, y, width, height, current_value, min_value, max_value, foreground, filled_background, unfilled_background)
            local newProgressbar = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                active = false,
                pos = math_utils.Vector2.new(x, y),
                size = math_utils.Vector2.new(width, height),
                value = {
                    max = max_value,
                    min = min_value,
                    current = current_value,
                    draw_percentage = true,
                    percentage_precision = 2
                },
                colors = {
                    foreground = foreground,
                    filled_background = filled_background,
                    unfilled_background = unfilled_background
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end,
                    onFailedPress = function () end
                }
            }
            setmetatable(newProgressbar, gui_elements.Progressbar)
            return newProgressbar
        end,
        -- DRAWS PROGRESSBAR
        draw = function (self)
            if self.hidden then return; end
            self.callbacks.onDraw(self)
            local value_percentage = math_utils.map(self.value.current, self.value.min, self.value.max, 0, 1, true)
            
            local filled_progress_width = math.floor(self.size.x * value_percentage)
            screen_buffer:rectangle(self.pos.x, self.pos.y, filled_progress_width, self.size.y, self.colors.filled_background)
            screen_buffer:rectangle(self.pos.x + filled_progress_width, self.pos.y, self.size.x - filled_progress_width, self.size.y, self.colors.unfilled_background)

            if self.value.draw_percentage then
                local percentage_text = string_utils.format_number(value_percentage * 100, self.value.percentage_precision).."%"
                local text_x = math.floor((self.size.x - #percentage_text) / 2) + self.pos.x
                local text_y = math.floor((self.size.y - 1) / 2) + self.pos.y
                screen_buffer:write(text_x, text_y, percentage_text, self.colors.foreground)
            end
        end,
        -- GIVES EVENT TO PROGRESSBAR
        event = function (self, formatted_event)
            if self.hidden then return false; end
            if formatted_event.name == const.TOUCH then
                if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    self.callbacks.onPress(self, formatted_event)
                end
            end
        end,
        -- SETS PROGRESSBAR'S VALUE
        set = function (self, value)
            local ranged_value = math_utils.constrain(value, self.value.min, self.value.max)
            self.value.current = ranged_value
        end
    },
    Memo = {
        -- RETURNS NEW MEMO
        new = function (x, y, width, height, foreground, background)
            local newMemo = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                pos = math_utils.Vector2.new(x, y),
                size = math_utils.Vector2.new(width, height),
                editable = true,
                tab_spaces = "  ",
                lines = {},
                first_visible_line = 1,
                first_visible_char = 1,
                cursor = {
                    visible = false,
                    text = " ",
                    blink = gui_elements.Clock.new(0.5),
                    pos = math_utils.Vector2.new(1, 1)
                },
                limits = math_utils.Vector2.new(0, 0),
                whitelist = {},
                blacklist = {},
                colors = {
                    foreground = foreground,
                    background = background,
                    cursor = colors.white,
                    cursor_text = colors.black,
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end,
                    onFailedPress = function () end,
                    onFocus = function () end,
                    onKey = function () end,
                    onChar = function () end,
                    onMouseScroll = function () end
                }
            }
            newMemo.cursor.blink.binded_cursor = newMemo.cursor
            generic_utils.set_callback(
                newMemo.cursor.blink,
                const.ONCLOCK,
                function (self, formatted_event)
                    self.binded_cursor.visible = not self.binded_cursor.visible
                end
            )
            setmetatable(newMemo, gui_elements.Memo)
            return newMemo
        end,
        -- DRAWS MEMO
        draw = function (self)
            if self.hidden then return; end
            screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.background)

            local rel_cursor_x = self.cursor.pos.x - self.first_visible_char
            local rel_cursor_y = self.cursor.pos.y - self.first_visible_line

            for y=1, self.size.y do
                local line = self.lines[y + self.first_visible_line - 1] or ""
                local visible_line = line:sub(self.first_visible_char, self.first_visible_char + self.size.x - 1)
                screen_buffer:write(self.pos.x, self.pos.y + y - 1, visible_line, self.colors.foreground)
            end

            if self.cursor.visible and (rel_cursor_x >= 0) and (rel_cursor_x < self.size.x) and (rel_cursor_y >= 0) and (rel_cursor_y < self.size.y) then
                screen_buffer:write(
                    rel_cursor_x + self.pos.x,
                    rel_cursor_y + self.pos.y,
                    self.cursor.text,
                    self.colors.cursor_text, self.colors.cursor
                )
            end
        end,
        -- GIVES EVENT TO MEMO
        event = function (self, formatted_event)
            if self.hidden then return false; end
            if not self.editable then return false; end
            if formatted_event.name == const.TOUCH then
                if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    local x = formatted_event.x - self.pos.x
                    local y = formatted_event.y - self.pos.y
                    self:set_cursor(x + self.first_visible_char, y + self.first_visible_line)
                    self:focus(true, formatted_event)
                    self.callbacks.onPress(self, formatted_event)
                    
                    return true -- RETURNING TRUE DELETES THE EVENT
                else
                    self:focus(false, formatted_event)
                    self.callbacks.onFailedPress(self, formatted_event)
                    return false
                end
            elseif formatted_event.name == const.DELETED then
                self:focus(false, formatted_event)
                return false
            end
            if self.focussed then
                self.cursor.blink:event(self.cursor.blink, formatted_event)
                if formatted_event.name == const.PASTE then
                    self:write(formatted_event.paste)
                elseif formatted_event.name == const.CHAR then
                    if self.callbacks.onChar(self, formatted_event) then return true; end
                    self:write(formatted_event.char)
                elseif formatted_event.name == const.KEY then
                    if self.callbacks.onKey(self, formatted_event) then return true; end
                    if input:are_keys_pressed(false, const.KEY_LEFTALT, const.KEY_UP) then
                        if self.cursor.pos.y > 1 then
                            local prev_line = self.lines[self.cursor.pos.y - 1]
                            local this_line = self.lines[self.cursor.pos.y]

                            self.lines[self.cursor.pos.y - 1] = ""
                            table.remove(self.lines, self.cursor.pos.y)

                            local old_x = self.cursor.pos.x

                            self:set_cursor(1, self.cursor.pos.y - 1)
                            self:write(this_line.."\n"..prev_line)
                            self:set_cursor(old_x, self.cursor.pos.y - 1)
                        end
                    
                    
                    elseif input:are_keys_pressed(false, const.KEY_LEFTALT, const.KEY_DOWN) then
                        local this_line = self.lines[self.cursor.pos.y]
                        local next_line = self.lines[self.cursor.pos.y + 1]

                        if not next_line then return false; end

                        self.lines[self.cursor.pos.y] = ""
                        table.remove(self.lines, self.cursor.pos.y + 1)

                        local old_x = self.cursor.pos.x

                        self:set_cursor(1, self.cursor.pos.y)
                        self:write(next_line.."\n"..this_line)
                        self:set_cursor(old_x, self.cursor.pos.y)


                    elseif formatted_event.key == const.KEY_UP then
                        self:set_cursor(self.cursor.pos.x, self.cursor.pos.y - 1)
                        
                        
                    elseif formatted_event.key == const.KEY_DOWN then
                        self:set_cursor(self.cursor.pos.x, self.cursor.pos.y + 1)
                        
                        
                    elseif formatted_event.key == const.KEY_RIGHT then
                        local line = self.lines[self.cursor.pos.y]
                        if self.lines[self.cursor.pos.y + 1] and self.cursor.pos.x >= #line + 1 then
                            self:set_cursor(1, self.cursor.pos.y + 1)
                        else
                            self:set_cursor(self.cursor.pos.x + 1, self.cursor.pos.y)
                        end


                    elseif formatted_event.key == const.KEY_LEFT then
                        if self.cursor.pos.x <= 1 and self.cursor.pos.y > 1 then
                            local previous_line = self.lines[self.cursor.pos.y - 1]
                            self:set_cursor(#previous_line + 1, self.cursor.pos.y - 1)
                        else
                            self:set_cursor(self.cursor.pos.x - 1, self.cursor.pos.y)
                        end


                    elseif formatted_event.key == const.KEY_BACKSPACE then
                        local line = self.lines[self.cursor.pos.y]
                        if self.cursor.pos.x <= 1 then
                            if self.cursor.pos.y > 1 then
                                table.remove(self.lines, self.cursor.pos.y)

                                local cursor_x = #self.lines[self.cursor.pos.y - 1] + 1
                                local cursor_y = self.cursor.pos.y - 1

                                self:set_cursor(cursor_x, cursor_y)
                                self:write(line)
                                self:set_cursor(cursor_x, cursor_y)
                            end
                        else
                            self.lines[self.cursor.pos.y] = line:sub(1, self.cursor.pos.x - 2)..line:sub(self.cursor.pos.x)
                            self:set_cursor(self.cursor.pos.x - 1, self.cursor.pos.y)
                        end


                    elseif formatted_event.key == const.KEY_DELETE then
                        local line = self.lines[self.cursor.pos.y]
                        local line_end = line:sub(self.cursor.pos.x)

                        if #line_end > 0 then
                            self.lines[self.cursor.pos.y] = line:sub(1, self.cursor.pos.x - 1)..line:sub(self.cursor.pos.x + 1)
                        else
                            local next_line = self.lines[self.cursor.pos.y + 1]
                            if next_line then
                                local cursor_x = self.cursor.pos.x
                                local cursor_y = self.cursor.pos.y
                                table.remove(self.lines, self.cursor.pos.y + 1)
                                self:write(next_line)
                                self:set_cursor(cursor_x, cursor_y)
                            end
                        end
                        

                    elseif formatted_event.key == const.KEY_ENTER then
                        local current_line_to_cursor = self.lines[self.cursor.pos.y]:sub(0, self.cursor.pos.x - 1)
                        local spaces = current_line_to_cursor:gsub("(%s*).*", "%1")
                        self:write("\n"..spaces)


                    elseif input:are_keys_pressed(false, const.KEY_LEFTSHIFT, const.KEY_TAB) then
                        local current_line = self.lines[self.cursor.pos.y]
                        local spaces = current_line:gsub("^(%s*).*$", "%1")
                        local total_spaces = math.min(#self.tab_spaces, #spaces)
                        
                        self.lines[self.cursor.pos.y] = current_line:sub(total_spaces + 1)
                        self:set_cursor(self.cursor.pos.x - total_spaces, self.cursor.pos.y)


                    elseif formatted_event.key == const.KEY_TAB then
                        local old_x = self.cursor.pos.x
                        local line_len = #self.lines[self.cursor.pos.y]
                        self:set_cursor(1, self.cursor.pos.y)
                        self:write(self.tab_spaces)
                        local delta_x = #self.lines[self.cursor.pos.y] - line_len
                        self:set_cursor(old_x + delta_x, self.cursor.pos.y)


                    end
                elseif formatted_event.name == const.MOUSESCROLL then
                    if self.callbacks.onMouseScroll(self, formatted_event) then return true; end
                    self.first_visible_line = math_utils.constrain(self.first_visible_line + formatted_event.direction, 1, #self.lines)
                end
                return true
            end
        end,
        focus = function (self, active, formatted_event)
            if active then
                self.focussed = true
                self.callbacks.onFocus(self, formatted_event)
            else
                self.focussed = false
                self.cursor.visible = false
                self.callbacks.onFocus(self, formatted_event)
            end
        end,
        -- SETS THE CURSOR TO A POSITION
        --  (if create_lines is true, it will create all the lines that
        --   are missing between cursor_y and the last line)
        set_cursor = function (self, cursor_x, cursor_y, create_lines)
            if not self.lines[1] then self.lines[1] = ""; end
            if self.limits.y > 0 then cursor_y = math_utils.constrain(cursor_y, 1, self.limits.y); end
            if create_lines then
                for y=#self.lines + 1, cursor_y do
                    if not self.lines[y] then
                        self.lines[y] = ""
                    end
                end
            else
                cursor_y = math_utils.constrain(cursor_y, 1, #self.lines)
            end

            cursor_x = math_utils.constrain(cursor_x, 1, #self.lines[cursor_y] + 1)
            self.cursor.pos = math_utils.Vector2.new(cursor_x, cursor_y)
            
            local rel_cursor_x = self.cursor.pos.x - self.first_visible_char
            local rel_cursor_y = self.cursor.pos.y - self.first_visible_line

            if rel_cursor_x >= self.size.x then
                self.first_visible_char = self.first_visible_char + rel_cursor_x - self.size.x + 1
            elseif rel_cursor_x < 0 then
                self.first_visible_char = self.first_visible_char + rel_cursor_x
            end

            if rel_cursor_y >= self.size.y then
                self.first_visible_line = self.first_visible_line + rel_cursor_y - self.size.y + 1
            elseif rel_cursor_y < 0 then
                self.first_visible_line = self.first_visible_line + rel_cursor_y
            end
        end,
        -- WRITES TEXT WHERE THE CURSOR IS
        write = function (self, ...)
            local text = string_utils.join({...}, "")
            local lines = string_utils.split(text, "\n")
            self:set_cursor(self.cursor.pos.x, self.cursor.pos.y, true)

            if #self.whitelist > 0 then
                local pattern = "[^"..string_utils.escape_magic_characters(string_utils.join(self.whitelist, "")).."]"
                for key, line in next, lines do
                    lines[key] = line:gsub(pattern, "")
                end
            elseif #self.blacklist > 0 then
                local pattern = "["..string_utils.escape_magic_characters(string_utils.join(self.blacklist, "")).."]"
                for key, line in next, lines do
                    lines[key] = line:gsub(pattern, "")
                end
            end

            if self.limits.y > 0 then
                for y=1, #self.lines + (#lines - 1) - self.limits.y do
                    table.remove(lines)
                end
                if #lines == 0 then return; end
            end

            if #lines > 1 then
                for line_key, line in next, lines do
                    if line_key == 1 then
                        local cursor_line = self.lines[self.cursor.pos.y]
                        local line_start = cursor_line:sub(1, self.cursor.pos.x - 1)
                        local line_end = cursor_line:sub(self.cursor.pos.x)

                        local last_line = lines[#lines]
                        if self.limits.x > 0 then
                            line = line:sub(1, self.limits.x - #line_start)
                            last_line = last_line:sub(1, self.limits.x - #line_end)
                        end

                        self.lines[self.cursor.pos.y] = line_start..line

                        table.insert(self.lines, self.cursor.pos.y + 1, last_line..line_end)

                        self:set_cursor(#last_line + 1, self.cursor.pos.y + 1)
                    elseif line_key == #lines then
                        break
                    else
                        if self.limits.x > 0 then line = line:sub(1, self.limits.x); end
                        table.insert(self.lines, self.cursor.pos.y, line)
                        self:set_cursor(self.cursor.pos.x, self.cursor.pos.y + 1)
                    end
                end
            else
                -- Get the line at cursor
                local cursor_line = self.lines[self.cursor.pos.y]
                -- Get the part of the line that's behind the cursor
                local line_start = cursor_line:sub(1, self.cursor.pos.x - 1)
                -- Get the part of the line that's in front of the cursor
                local line_end = cursor_line:sub(self.cursor.pos.x)

                if self.limits.x > 0 then
                    lines[1] = lines[1]:sub(1, self.limits.x - (#line_start + #line_end))
                end
                self.lines[self.cursor.pos.y] = line_start..lines[1]..line_end
                self:set_cursor(self.cursor.pos.x + #lines[1], self.cursor.pos.y)
            end
        end,
        print = function (self, ...)
            local text = string_utils.join({...}, "\n").."\n"
            self:write(text)
        end,
        clear = function (self)
            self.lines = {""}
            self:set_cursor(1, 1)
        end
    },
    Window = {
        -- RETURNS NEW WINDOW
        new = function (x, y, width, height, background, shadow)
            local newWindow = {
                draw_priority = const.HIGH_PRIORITY,
                focussed = false,
                hidden = false,
                pos = math_utils.Vector2.new(x, y),
                size = math_utils.Vector2.new(width, height),
                drag_options = {
                    enabled = true,
                    from = math_utils.Vector2.new(1, 1)
                },
                shadow = {
                    enabled = shadow,
                    offset = math_utils.Vector2.new(1, 1)
                },
                elements = {},
                colors = {
                    background = background,
                    shadow = colors.black
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end,
                    onFailedPress = function () end,
                    onFocus = function () end
                }
            }
            setmetatable(newWindow, gui_elements.Window)
            return newWindow
        end,
        -- DRAWS THE WINDOW
        draw = function (self)
            if self.hidden then return; end
            self.callbacks.onDraw(self)
            if self.shadow.enabled then
                screen_buffer:rectangle(
                    self.pos.x + self.shadow.offset.x,
                    self.pos.y + self.shadow.offset.y,
                    self.size.x,
                    self.size.y,
                    self.colors.shadow
                )
            end

            screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.background)

            self:draw_elements()
        end,
        -- GIVES EVENT TO WINDOW
        event = function (self, formatted_event)
            if self.hidden then return false; end
            local delete_event = self:event_elements(formatted_event)
            if not delete_event then
                if formatted_event.name == const.TOUCH then
                    if event_utils.is_area_pressed(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                        self.drag_options.from = math_utils.Vector2.new(formatted_event.x, formatted_event.y)
                        self.focussed = true
                        self.callbacks.onPress(self, formatted_event)
                        self.callbacks.onFocus(self, formatted_event)
                        return true
                    else
                        self.focussed = false
                        self.callbacks.onFailedPress(self, formatted_event)
                        self.callbacks.onFocus(self, formatted_event)
                    end
                elseif formatted_event.name == const.MOUSEDRAG and self.focussed then
                    self:drag(formatted_event.x, formatted_event.y)
                    return true
                elseif formatted_event.name == const.DELETED then
                    self.focussed = false
                    self.callbacks.onFocus(self, formatted_event)
                end
            else
                self.focussed = false
                self.callbacks.onFocus(self, formatted_event)
            end
            return delete_event
        end,
        -- DRAGS WINDOW TO POS BASED ON drag_options.from
        drag = function (self, x, y)
            if self.drag_options.enabled then
                local delta_drag = math_utils.Vector2.new(
                    x - self.drag_options.from.x,
                    y - self.drag_options.from.y
                )
                self.pos = self.pos + delta_drag
                for key, element in next, self.elements do
                    if element.pos then
                        element.pos = element.pos + delta_drag
                    end
                end
                self.drag_options.from = math_utils.Vector2.new(x, y)
            end
        end,
        -- SETS WINDOW'S ELEMENTS
        set_elements = function (self, elements_table, relative)
            self.elements = {}
            for key, element in next, elements_table do
                if relative then
                    element.pos = self.pos + element.pos - math_utils.Vector2.ONE
                end
                table.insert(self.elements, element)
            end
        end,
        -- DRAWS ALL WINDOW'S ELEMENTS
        draw_elements = function (self)
            for key=#self.elements, 1, -1 do
                local element = self.elements[key]
                if element.draw then
                    element:draw()
                end
            end
        end,
        -- GIVES EVENT TO ALL WINDOW'S ELEMENTS
        event_elements = function (self, formatted_event)
            local delete_event = false
            
            for key, element in next, self.elements do
                if element.event then
                    local this_delete_event = element:event(formatted_event)
                    delete_event = delete_event or this_delete_event
                    if this_delete_event then
                        formatted_event = {name = const.DELETED}
                    end
                end
            end

            return delete_event
        end
    }
}

gui_elements.Clock.__index = gui_elements.Clock
gui_elements.Label.__index = gui_elements.Label
gui_elements.Button.__index = gui_elements.Button
gui_elements.Progressbar.__index = gui_elements.Progressbar
gui_elements.Memo.__index = gui_elements.Memo
gui_elements.Window.__index = gui_elements.Window

-- LOOP MODULE
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
                    clock = gui_elements.Clock.new(1 / FPS_target),
                    stats_clock = gui_elements.Clock.new(1),
                    FPS_label = gui_elements.Label.new(1, 1, "1 FPS", colors.white),
                    EPS_label = gui_elements.Label.new(1, 2, "1 EPS", colors.white)
                }
            },
            stats = {
                pos = math_utils.Vector2.new(1, 1),
                elements = nil,
                enabled = true,
                enable = function (self, state)
                    self.enabled = state
                    self.elements.stats_clock.enabled = state
                    self.elements.FPS_label.hidden = not state
                    self.elements.EPS_label.hidden = not state
                end,
                update_pos = function (self)
                    self.elements.FPS_label.pos = self.pos
                    self.elements.EPS_label.pos = self.pos + math_utils.Vector2.DOWN
                end,
                FPS = 0,
                EPS = 0
            },
            callbacks = {
                onStart = function () end,
                onStop = function () end,
                onDraw = function () end,
                onClock = function () end,
                onEvent = function () end
            }
        }
        -- Set references to stats in clock
        newLoop.elements.loop.stats_clock.stats = newLoop.stats
        -- Set a reference to loop elements in stats table
        newLoop.stats.elements = newLoop.elements.loop
        -- Set stats_clock callback
        generic_utils.set_callback(
            newLoop.elements.loop.stats_clock,
            const.ONCLOCK,
            function (self, formatted_event)
                self.stats:update_pos()
                self.stats.elements.FPS_label.text = tostring(self.stats.FPS).." FPS"
                self.stats.elements.EPS_label.text = tostring(self.stats.EPS).." EPS"
                self.stats.FPS = 0
                self.stats.EPS = 0
            end
        )
        newLoop.stats:enable(false)
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
        for key, value in next, elements_table do
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
        for key, element in next, self.elements.loop do
            if element.draw then
                element:draw()
            end
        end

        screen_buffer:draw()
        screen_buffer.screens = old_screens
        if self.stats.enabled then
            self.stats.FPS = self.stats.FPS + 1
        end
    end,
    -- GIVES AN EVENT TO ALL LOOP ELEMENTS
    event_elements = function (self, formatted_event)
        local function event_table(tbl)
            for key, element in next, tbl do
                if element.event then
                    if element:event(formatted_event) then formatted_event = {name = const.DELETED}; end
                end
            end
        end
        
        if self.callbacks.onEvent(self, formatted_event) then
            formatted_event = {name = const.DELETED}
        end

        if formatted_event.name == const.TOUCH then
            local is_monitor_whitelisted = false
            for monitor_name, monitor in next, self.monitors do
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

        local high_focussed = {}
        for key, element in next, self.elements.high_priority do
            if element.event then
                local focus = element:event(formatted_event)
                if focus then
                    formatted_event = {name = const.DELETED}
                    if self.elements.high_priority ~= element then
                        table.insert(high_focussed, {element = element, key = key})
                    end
                end
            end
        end
        if #high_focussed > 0 then
            for key, value in next, high_focussed do
                table.insert(self.elements.high_priority, 1, value.element)
                table.remove(self.elements.high_priority, value.key + #high_focussed)
            end
        end

        event_table(self.elements.low_priority)

        if self.stats.enabled then
            self.stats.EPS = self.stats.EPS + 1
        end
    end,
    -- STARTS THE LOOP
    start = function (self)
        self.enabled = true
        input:reset()
        generic_utils.set_callback(
            self.elements.loop.clock,
            const.ONCLOCK,
            function (CLOCK, formatted_event)
                self.callbacks.onClock(self, formatted_event)
                self:draw_elements()
                CLOCK.interval = 1 / self.options.FPS_target
            end
        )
        self.stats:update_pos()
        self.callbacks.onStart(self)
        while self.enabled do
            local timer = os.startTimer(1 / self.options.EPS_target)
            local raw_event = {os.pullEvent()}
            local formatted_event = event_utils.format_event_table(raw_event)

            input:manage_event(formatted_event)
            self:event_elements(formatted_event)

            os.cancelTimer(timer)
        end
        input:reset()
        self.callbacks.onStop(self)
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
        { text = " - setup (adds YAGUI_PATH to computer's settings)", foreground = colors.yellow, background = nil},
        { text = " - create <PATH> (creates a new YAGUI project)"   , foreground = colors.green , background = nil}
    }

    for key, line in next, lines do
        monitor_utils.better_print(term, line.foreground, line.background, line.text)
    end
elseif tArgs[1] == "info" then
    monitor_utils.better_print(term, colors.red, nil, "Library Version: ", info.ver)
    monitor_utils.better_print(term, colors.yellow, nil, "Library Author: ", info.author)
    monitor_utils.better_print(term, colors.green, nil, "Library Website: ", info.website)
    monitor_utils.better_print(term, colors.blue, nil, "Library Documentation: ", info.documentation)
elseif tArgs[1] == "ver" then
    monitor_utils.better_print(term, colors.red, nil, "Library Version: ", info.ver)
elseif tArgs[1] == "copyright" then
    local paragraph_colors = {
        colors.red,
        colors.yellow,
        colors.green
    }
    local paragraphs = string_utils.split(info.copyright, "\n\n")

    for key, paragraph in next, paragraphs do
        monitor_utils.better_print(term, paragraph_colors[key], nil, paragraph)
        if key < #paragraphs then read(""); end
    end
elseif tArgs[1] == "setup" then
    if shell then
        local settings_entry = "YAGUI_PATH"
        local path = "/"..shell.getRunningProgram()
        setting_utils.set(settings_entry, path)

        monitor_utils.better_print(term, colors.green, nil, "Lib path was set to \"", setting_utils.get(settings_entry), "\".")
    else
        monitor_utils.better_print(term, colors.red, nil, "SHELL API ISN'T AVAILABLE!")
    end
elseif tArgs[1] == "create" then
    if tArgs[2] then
        local path = shell.resolve(tArgs[2])
        if string_utils.get_extension(path) ~= "lua" then path = path..".lua"; end
        if fs.exists(path) then
            monitor_utils.better_print(term, colors.red, nil, "PATH: \"/", path, "\" already exists, please use another path or delete it.")
        else
            local file = fs.open(path, "w")
            file.write("\n-- AUTO-GENERATED with \"YAGUI create\"\nlocal YAGUI_PATH = settings.get(\"YAGUI_PATH\")\nif not (type(YAGUI_PATH) == \"string\") then printError(\"YAGUI is not installed, please install it by opening it with argument \\\"setup\\\".\"); return; end\nif not fs.exists(YAGUI_PATH) then printError(\"Couldn't find YAGUI in path: \\\"\"..YAGUI_PATH..\"\\\", Please reinstall it by opening it with argument \\\"setup\\\".\"); return; end\nlocal YAGUI = dofile(YAGUI_PATH)\n-- End of AUTO-GENERATED code\n\n")
            file.close()
            monitor_utils.better_print(term, colors.green, nil, "New project was created at \"/", path, "\".")
        end
    else
        monitor_utils.better_print(term, colors.red, nil, "You must specify a path to create a new project.")
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
    table_utils = table_utils,
    color_utils = color_utils,
    event_utils = event_utils,
    setting_utils = setting_utils,
    monitor_utils = monitor_utils,
    screen_buffer = screen_buffer,
    input = input,
    WSS = WSS,
    wireless_screen_share = WSS,
    gui_elements = gui_elements,
    Loop = Loop
}

-- MAKE CONSTANTS BE GLOBAL VARIABLES OF THE LIBRARY
for key, value in next, const do
    lib[key] = value
end

return lib
