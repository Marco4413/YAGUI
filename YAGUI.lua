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
    ver = "1.39",
    author = "hds536jhmk",
    website = "https://github.com/hds536jhmk/YAGUI/",
    documentation = "https://hds536jhmk.github.io/YAGUI/",
    copyright = "Copyright (c) 2019, hds536jhmk : https://github.com/hds536jhmk/YAGUI\n\nPermission to use, copy, modify, and/or distribute this software for any\npurpose with or without fee is hereby granted, provided that the above\ncopyright notice and this permission notice appear in all copies.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\" AND THE AUTHOR DISCLAIMS ALL WARRANTIES\nWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF\nMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR\nANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES\nWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN\nACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF\nOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.",
    nfp = "1.0.0",
    nft = "1.0.0"
}

-- CONSTANTS MODULE
-- THESE WILL BE TRANSFORMED IN GLOBAL VARIABLES WHEN LIBRARY IS RETURNED
local const = {
    TIMER = "timer",
    TOUCH = "screen_touch",
    MOUSEUP = "mouse_up",
    MOUSEDRAG = "mouse_drag",
    MOUSEMOVE = "mouse_move",
    MOUSESCROLL = "mouse_scroll",
    CHAR = "char",
    KEY = "key",
    KEYUP = "key_up",
    PASTE = "paste",
    REDNET = "rednet_message",
    MODEM = "modem_message",
    TERMINATE = "terminate",
    TERMRESIZE = "term_resize",
    COROUTINE = "coroutine",
    DELETED = "DELETED",
    NONE = "NONE",
    ALL = "ALL",
    SEND = "SEND",
    RECEIVE = "RECEIVE",
    HOST = "HOST",
    USER = "USER",
    DISCONNECTED = "DISCONNECTED",
    CONNECTION_REQUEST = "CONNECTION_REQUEST",
    OK = "OK",
    NO = "NO",
    ERROR = "ERROR",
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
    ONCURSORCHANGE = 13,
    ONWRITE = 14,
    ONCONNECT = 15,
    ONDISCONNECT = 16,
    ONSEND = 17,
    ONRECEIVE = 18,
    ONDRAG = 19,
    ONRESIZE = 20,
    ONPASTE = 21,
    ONHOVER = 22,
    MOUSE_LEFT = 1,
    MOUSE_RIGHT = 2,
    MOUSE_MIDDLE = 3,
    SCROLL_UP = -1,
    SCROLL_DOWN = 1,
    COMPUTER = "computer",
    TURTLE = "turtle",
    POCKET = "pocket",
    ALIGN_LEFT = 1,
    ALIGN_CENTER = 2,
    ALIGN_RIGHT = 3
}

for key_name, key in next, keys do
    if type(key) == "number" then
        const["KEY_"..key_name:upper()] = key
    end
end

-- This is used by the library to draw rectangles with borders
local drawing_characters = {
    TOP         = string.char(131),
    BOTTOM      = string.char(143),
    LEFT        = string.char(149),
    RIGHT       = string.char(149),
    MIDDLE      = string.char(140),
    TOPLEFT     = string.char(151),
    TOPRIGHT    = string.char(148),
    BOTTOMLEFT  = string.char(138),
    BOTTOMRIGHT = string.char(133),
    MIDDLELEFT  = string.char(132),
    MIDDLERIGHT = string.char(136)
}

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
    --  Note: It was deprecated in v1.29 You should now be using element.set_callback instead
    set_callback = function (gui_element, event, callback)
        gui_element:set_callback(event, callback)
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
    -- CONCATENATES STRINGS IN A TABLE
    join = table.concat,
    -- SPLITS STRING EVERY TIME SEPARATOR (PATTERN) IS FOUND
    split = function (str, sep)
        if not string.find(str, sep) then
            return {str}
        end
        local return_table = {}
        local pattern = table.concat({"(.-)", sep, "()"})
        local last_pos
        for this_match, pos in string.gfind(str, pattern) do
            table.insert(return_table, this_match)
            last_pos = pos
        end
        table.insert(return_table, string.sub(str, last_pos))
        return return_table
    end,
    -- SPLITS STRING EVERY TIME CHAR IS FOUND
    split_by_char = function (str, char)
        local lines = {}
        local lp = 1
        for i=1, #str do
            if str:sub(i, i) == char then
                table.insert(lines, i == lp and "" or str:sub(lp, i - 1))
                lp = i + 1
            end
        end
        table.insert(lines, str:sub(lp, #str))
        return lines
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
            str = str:gsub(table.concat({"[%", character, "]"}), table.concat({"%%%", character}))
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
            return table.concat({unit, ".", decimal_digits})
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
            return self.x * self.x + self.y * self.y
        end,
        -- RETURNS VECTOR LENGTH
        length = function (self)
            return math.sqrt(self.x * self.x + self.y * self.y)
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
                return string.format(table.concat({"(%.", precision, "f; %.", precision, "f)"}), self.x, self.y)
            else
                return string.format("(%f; %f)", self.x, self.y)
            end
        end,
        -- TOSTRING METAMETHOD, handles tostring(Vector1)
        __tostring = function (self)
            return self:string(0)
        end,
        -- LEN METAMETHOD, handles #Vector1
        __len = function (self)
            return self:length()
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
            return self.x * self.x + self.y * self.y + self.z * self.z
        end,
        -- RETURNS VECTOR LENGTH
        length = function (self)
            return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
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
                return string.format(table.concat({"(%.", precision, "f; %.", precision, "f; %.", precision, "f)"}), self.x, self.y, self.z)
            else
                return string.format("(%f; %f; %f)", self.x, self.y, self.z)
            end
        end,
        -- TOSTRING METAMETHOD, handles tostring(Vector1)
        __tostring = function (self)
            return self:string(0)
        end,
        -- LEN METAMETHOD, handles #Vector1
        __len = function (self)
            return self:length()
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
    serialise = function (tbl, depth, pretty, recursion, serialise_metatables, serialise_index, indent, new_line, space)
        local depth = depth or 0
        local indent = indent or "  "
        local current_depth = 0
        
        local new_line = new_line or "\n"
        local space = space or " "
        
        if not pretty then indent, new_line, space = "", "", ""; end
        
        local root = "root"
        local found_tables = {
            [tbl] = root
        }

        local function i_tbl_serialize(tbl, path)
            local this_indent = indent:rep(current_depth + 1)
            local str_tbl = table.concat({"{", new_line})

            local function add_tbl(tbl)
                local tbl_length = #tbl
                local last_i = 0
                for key, value in next, tbl do
                    local key_type = type(key)
                    local key_string
                    if (key_type == "number") or (key_type == "boolean") or (key_type == "nil") then
                        key_string = tostring(key)
                    else
                        key_string = string.format("%q", tostring(key))
                    end

                    if not serialise_index and (key == "__index") then value = {}; end
                    local value_type = type(value)
                    
                    if key_type == "number" and key <= tbl_length and key == last_i + 1 then
                        last_i = key
                        str_tbl = table.concat({str_tbl, this_indent})
                    else
                        str_tbl = table.concat({str_tbl, string.format("%s[%s]%s=%s", this_indent, key_string, space, space)})
                    end

                    if value_type == "table" then
                        if not next(value) then
                            str_tbl = table.concat({str_tbl, "{}"})
                        elseif (depth <= -1) or (current_depth < depth) then
                            if found_tables[value] and not recursion then
                                str_tbl = table.concat({str_tbl, string.format("%q", found_tables[value])})
                            else
                                local this_path = table.concat({path, "[", key_string, "]"})
                                found_tables[value] = this_path
                                current_depth = current_depth + 1
                                str_tbl = table.concat({str_tbl, i_tbl_serialize(value, this_path)})
                                current_depth = current_depth - 1
                            end
                        else
                            str_tbl = table.concat({str_tbl, "{}"})
                        end
                    elseif (value_type == "number") or (value_type == "boolean") or (value_type == "nil") then
                        str_tbl = table.concat({str_tbl, string.format("%s", tostring(value))})
                    else
                        str_tbl = table.concat({str_tbl, string.format("%q", tostring(value))})
                    end

                    if next(tbl, key) then
                        str_tbl = table.concat({str_tbl, ",", new_line})
                    else
                        str_tbl = table.concat({str_tbl, new_line})
                    end
                end
            end

            local metatable = getmetatable(tbl)
            if serialise_metatables and metatable then
                add_tbl(metatable)
                if next(tbl) then
                    str_tbl = table.concat({str_tbl:sub(1, #str_tbl - #new_line), ",", str_tbl:sub(#str_tbl - #new_line + 1)})
                end
            end
            
            add_tbl(tbl)
            str_tbl = table.concat({str_tbl, indent:rep(current_depth), "}"})
            return str_tbl
        end
        
        return i_tbl_serialize(tbl, root)
    end,
    -- Just copies of unserialise functions in textutils
    unserialise = textutils.unserialise,
    unserialize = textutils.unserialize,
    better_unpack = function (tbl, i, max_i)
        i = i or 1
        max_i = max_i or #tbl
        if i <= max_i then
            return tbl[i], table_utils.better_unpack(tbl, i + 1, max_i)
        end
    end,
    get = function (tbl, ...)
        local path = {...}
        local current_value = tbl
        for i=1, #path do
            current_value = current_value[path[i]]
        end
        return current_value
    end,
    set = function (value, tbl, ...)
        local path = {...}
        local key_to_change = table.remove(path)
        local table_with_key = table_utils.get(tbl, table.unpack(path))

        local old_value = table_with_key[key_to_change]
        table_with_key[key_to_change] = value
        return old_value
    end,
    better_remove = function (tbl, ...)
        local indices = {...}
        local removed = #indices
        for i=1, #indices do
            tbl[indices[i]] = nil
        end
        local j, nils = 1, {}
        for i=1, #tbl + removed do
            if tbl[i] == nil then
                nils[#nils + 1] = i
            elseif #nils > 0 then
                tbl[nils[j]], nils[#nils + 1], tbl[i] = tbl[i], i
                j = j + 1
            end
        end
    end
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
    paint = {},
    -- TAKES A DECIMAL VALUE FROM COLORS API AND RETURNS ITS PAINT VALUE
    color_to_paint = function (color)
        return color_utils.colors[color]
    end,
    -- TAKES A PAINT AND RETURNS ITS DECIMAL VALUE FROM COLORS API
    paint_to_color = function (paint)
        return color_utils.paint[paint]
    end
}

for key, value in next, color_utils.colors do
    color_utils.paint[value] = key
end

-- EVENT UTILS MODULE
event_utils = {
    -- USED TO CHECK IF AN AREA OF THE SCREEN WAS PRESSED
    in_area = function (press_x, press_y, x, y, width, height)
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
        if event.name == "timer" then
            event.name = const.TIMER
            event.id = event[2]
        elseif event.name == "mouse_click" then
            event.name = const.TOUCH
            event.from = "terminal"
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
        elseif event.name == "monitor_touch" then
            event.name = const.TOUCH
            event.from = event_table[2]
            event.button = 1
            event.x = event_table[3]
            event.y = event_table[4]
        elseif event.name == "mouse_drag" then
            event.name = const.MOUSEDRAG
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
        elseif event.name == "mouse_move" then
            event.name = const.MOUSEMOVE
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
        elseif event.name == "mouse_up" then
            event.name = const.MOUSEUP
            event.button = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
        elseif event.name == "mouse_scroll" then
            event.name = const.MOUSESCROLL
            event.direction = event_table[2]
            event.x = event_table[3]
            event.y = event_table[4]
        elseif event.name == "char" then
            event.name = const.CHAR
            event.char = event_table[2]
        elseif event.name == "key" then
            event.name = const.KEY
            event.key = event_table[2]
        elseif event.name == "key_up" then
            event.name = const.KEYUP
            event.key = event_table[2]
        elseif event.name == "paste" then
            event.name = const.PASTE
            event.paste = event_table[2]
        elseif event.name == "rednet_message" then
            event.name = const.REDNET
            event.from = event_table[2]
            event.message = event_table[3]
            local dp = event_table[4]
            if type(dp) == "number" then
                event.distance = dp
            else
                event.protocol = tostring(dp)
            end
        elseif event.name == "modem_message" then
            local msg = event_table[5]
            event.name = const.MODEM
            event.side = event_table[2]
            event.from = event_table[4]
            event.protocol = msg.sProtocol or ""
            event.message = msg.message
        elseif event.name == "terminate" then
            event.name = const.TERMINATE
        elseif event.name == "term_resize" then
            event.name = const.TERMRESIZE
        elseif event.name == "coroutine" then
            event.name = const.COROUTINE
            event.thread = event_table[2]
            event.status = event_table[3]
            event.ok = event_table[4]
            local i = 5
            if not event.ok then
                event.error = event_table[5]
                i = i + 1
            end
            event.returned = {}
            for i=i, #event_table do
                event.returned[#event.returned + 1] = event_table[i]
            end
        else
            event.parameters = {}
            for key=2, #event_table do
                table.insert(event.parameters, event_table[key])
            end
        end
        event.raw = event_table
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
        local strings = table.concat({...})
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

-- Used by screen_buffer functions to draw stuff on the screen
local internal_draw = {
    lineLow = function (sb, x1, y1, x2, y2, color)
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
            sb.buffer:set_pixel(x, y, " ", color, color)
            if D > 0 then
                y = y + yi
                D = D - 2 * dx
            end
            D = D + 2 * dy
        end
    end,
    lineHigh = function (sb, x1, y1, x2, y2, color)
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
            sb.buffer:set_pixel(x, y, " ", color, color)
            if D > 0 then
                x = x + xi
                D = D - 2 * dy
            end
            D = D + 2 * dx
        end
    end,
    get_rect_char = function (x, y, w, h)
        if h == 1 then
            if w == 1 then
                return drawing_characters.MIDDLE, true
            else
                if x == 1 then
                    return drawing_characters.MIDDLERIGHT, true
                elseif x == w then
                    return drawing_characters.MIDDLELEFT, true
                else
                    return drawing_characters.MIDDLE, true
                end
            end
        elseif y == 1 then
            if x == 1 then
                return drawing_characters.TOPLEFT, false
            elseif x == w then
                return drawing_characters.TOPRIGHT, true
            else
                return drawing_characters.TOP, false
            end
        elseif y == h then
            if x == 1 then
                return drawing_characters.BOTTOMLEFT, true
            elseif x == w then
                return drawing_characters.BOTTOMRIGHT, true
            else
                return drawing_characters.BOTTOM, true
            end
        elseif x == 1 then
            return drawing_characters.LEFT, false
        elseif x == w then
            return drawing_characters.RIGHT, true
        else
            return " ", false
        end
    end,
    buffer = {
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
                char = self.background.char,
                foreground = self.background.foreground,
                background = self.background.background,
                inverted = self.background.inverted
            }
        end,
        -- SETS PROPERTIES FOR A PIXEL SO IT ISN'T A "DEFAULT PIXEL" ANYMORE
        set_pixel = function (self, x, y, char, foreground, background, inverted)
            x, y = math.floor(x), math.floor(y)
            local pixel = self:get_pixel(x, y)

            if char then pixel.char = char:sub(1, 1); end

            if inverted then
                pixel.foreground, pixel.background = background or pixel.foreground, foreground or pixel.background
            else
                if pixel.inverted then
                    pixel.foreground, pixel.background = foreground or pixel.background, background or pixel.foreground
                else
                    pixel.foreground, pixel.background = foreground or pixel.foreground, background or pixel.background
                end
            end
            pixel.inverted = inverted
            
            if not self.pixels[x] then self.pixels[x] = {}; end
            self.pixels[x][y] = pixel
        end,
        remove_pixel = function (self, x, y)
            if self:is_pixel_custom(x, y) then self.pixels[x][y] = nil; end
        end,
        -- CLEARS PIXELS TABLE
        clear = function (self)
            self.pixels = {}
        end
    }
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
    -- BUFFER WILL BE CLEARED AFTER CALLING DRAW FUNCTION
    clear_after_draw = true,
    -- BUFFER STORES ALL PIXELS
    buffer = {
        pixels = {},
        background = {
            char = " ",
            foreground = colors.black,
            background = colors.black,
            inverted = false
        }
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
        local rows = {}
        for screen_name, screen in next, self.screens do
            local old_x, old_y = screen.getCursorPos()
            
            local width, height = screen.getSize()
            for y=1, height do
                local row_text, row_foreground, row_background = {}, {}, {}
                for x=rows[y] and #rows[y].text + 1 or 1, width do
                    local pixel = self.buffer:get_pixel(x, y)
                    row_text[#row_text + 1] = pixel.char
                    row_foreground[#row_foreground + 1] = color_utils.colors[pixel.foreground]
                    row_background[#row_background + 1] = color_utils.colors[pixel.background]
                end
                
                rows[y] = {
                    text = table.concat({rows[y] and rows[y].text or "", table.concat(row_text)}),
                    fg = table.concat({rows[y] and rows[y].fg or "", table.concat(row_foreground)}),
                    bg = table.concat({rows[y] and rows[y].bg or "", table.concat(row_background)})
                }
                screen.setCursorPos(1, y)
                screen.blit(rows[y].text:sub(0, width), rows[y].fg:sub(0, width), rows[y].bg:sub(0, width))
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
    -- WRITES TEXT ON THE SCREEN
    write = function (self, x, y, text, foreground, background)
        for rel_x=0, #text - 1 do
            local char = text:sub(rel_x + 1, rel_x + 1)
            self.buffer:set_pixel(x + rel_x, y, char, foreground, background)
        end
    end,
    -- WRITES TEXT ON THE SCREEN USING PAINT
    blit = function (self, x, y, text, foreground, background)
        local last_fg = ""
        local last_bg = ""
        foreground = foreground or ""
        background = background or ""
        for rel_x=0, #text - 1 do
            local char = text:sub(rel_x + 1, rel_x + 1)
            
            local this_fg = foreground:sub(rel_x + 1, rel_x + 1)
            this_fg = #this_fg > 0 and this_fg or last_fg

            local this_bg = background:sub(rel_x + 1, rel_x + 1)
            this_bg = #this_bg > 0 and this_bg or last_bg
            
            self.buffer:set_pixel(
                x + rel_x, y, char,
                color_utils.paint[this_fg],
                color_utils.paint[this_bg]
            )

            last_fg = this_fg
            last_bg = this_bg
        end
    end,
    -- DRAWS A RECTANGLE ON THE SCREEN
    rectangle = function (self, x, y, width, height, color, border, border_color, hollow)
        if hollow then
            for x_off=1, width do
                if border then
                    local char, inverted = internal_draw.get_rect_char(x_off, 1, width, height)
                    self.buffer:set_pixel(x + x_off - 1, y, char, border_color, color, inverted)
                    char, inverted = internal_draw.get_rect_char(x_off, height, width, height)
                    self.buffer:set_pixel(x + x_off - 1, y + height - 1, char, border_color, color, inverted)
                else
                    self.buffer:set_pixel(x + x_off - 1, y, " ", color, color)
                    self.buffer:set_pixel(x + x_off - 1, y + height - 1, " ", color, color)
                end
            end
            
            for y_off=2, height - 1 do
                if border then
                    local char, inverted = internal_draw.get_rect_char(1, y_off, width, height)
                    self.buffer:set_pixel(x, y + y_off - 1, char, border_color, color, inverted)
                    char, inverted = internal_draw.get_rect_char(width, y_off, width, height)
                    self.buffer:set_pixel(x + width - 1, y + y_off - 1, char, border_color, color, inverted)
                else
                    self.buffer:set_pixel(x, y + y_off - 1, " ", color, color)
                    self.buffer:set_pixel(x + width - 1, y + y_off - 1, " ", color, color)
                end
            end
        else
            for x_off=1, width do
                for y_off=1, height do
                    if border then
                        local char, inverted = internal_draw.get_rect_char(x_off, y_off, width, height)
                        self.buffer:set_pixel(x + x_off - 1, y + y_off - 1, char, border_color, color, inverted)
                    else
                        self.buffer:set_pixel(x + x_off - 1, y + y_off - 1, " ", color, color)
                    end
                end
            end
        end
    end,
    -- Draws a nfp image on the screen buffer (Learn more about a nfp image here https://github.com/oeed/CraftOS-Standards/blob/master/standards/4-paint.md):
    --  x is the x pos on the screen where you want to draw it
    --  y is the y pos on the screen where you want to draw it
    --  img is the string that you get by reading the image file
    --  CROP ARGUMENTS (NOT NECESSARY):
    --    img_x is the starting x pos in img (default: 1)
    --    img_y is the starting y pos in img (default: 1)
    --    img_width is the width of the rectangle that is going to be taken starting from img_x,img_y in img   (default: the length of the current row)
    --    img_height is the height of the rectangle that is going to be taken starting from img_x,img_y in img (default: the height of the image)
    nfp_image = function (self, x, y, img, img_x, img_y, img_width, img_height)
        img_x, img_y = img_x or 1, img_y or 1
        local rel_x, rel_y = 1, 1
        for i=1, #img do
            if img_height and rel_y >= img_height + img_y then break; end
            local char = img:sub(i, i)
            if char == "\n" then
                rel_x, rel_y = 1, rel_y + 1
            else
                if rel_y >= img_y and rel_x >= img_x and ((not img_width) or rel_x < img_width + img_x) then
                    local color = color_utils.paint[char]
                    if color then
                        self.buffer:set_pixel(x + rel_x - img_x, y + rel_y - img_y, " ", color, color)
                    end
                end
                rel_x = rel_x + 1
            end
        end
    end,
    -- Draws a nft image on the screen buffer (Learn more about a nft image here https://github.com/oeed/CraftOS-Standards/blob/master/standards/6-nft.md):
    --  x is the x pos on the screen where you want to draw it
    --  y is the y pos on the screen where you want to draw it
    --  img is the string that you get by reading the image file
    --  CROP ARGUMENTS (NOT NECESSARY):
    --    img_x is the starting x pos in img (default: 1)
    --    img_y is the starting y pos in img (default: 1)
    --    img_width is the width of the rectangle that is going to be taken starting from img_x,img_y in img   (default: the length of the current row)
    --    img_height is the height of the rectangle that is going to be taken starting from img_x,img_y in img (default: the height of the image)
    nft_image = function (self, x, y, img, img_x, img_y, img_width, img_height)
        img_x, img_y = img_x or 1, img_y or 1
        local rel_x, rel_y, get_bg, get_fg, bg, fg = 1, 1
        for i=1, #img do
            if img_height and rel_y >= img_height + img_y then break; end
            local char = img:sub(i, i)
            if get_bg then
                bg = color_utils.paint[char]
                get_bg = false
            elseif get_fg then
                fg = color_utils.paint[char]
                get_fg = false
            elseif char == "\30" then
                get_bg = true
            elseif char == "\31" then
                get_fg = true
            elseif char == "\n" then
                rel_x, rel_y, get_bg, get_fg, bg, fg = 1, rel_y + 1
            else
                if rel_y >= img_y and rel_x >= img_x and ((not img_width) or rel_x < img_width + img_x) then
                    self.buffer:set_pixel(x + rel_x - img_x, y + rel_y - img_y, char, fg, bg)
                end
                rel_x = rel_x + 1
            end
        end
    end,
    -- NOTE: TO MAKE SCREENSHOTS CONSIDER USING THE NFT FORMAT (It supports text)
    -- Returns a string which is screen_buffer.frame converted into nfp format (https://github.com/oeed/CraftOS-Standards/blob/master/standards/4-paint.md):
    --  transparent is whether or not transparency should count
    --  CROP ARGUMENTS (NOT NECESSARY):
    --    x is the starting x pos in the screen buffer (default: The first x in the frame)
    --    y is the starting y pos in the screen buffer (default: The first y in the frame)
    --    width is the width of the rectangle that is going to be taken starting from x,y in the screen buffer   (default: The width of the frame)
    --    height is the height of the rectangle that is going to be taken starting from x,y in the screen buffer (default: The height of the frame)
    frame_to_nfp = function (self, transparent, x, y, width, height)
        local image = {}

        local real_x1, real_y1, real_x2, real_y2 = 1, 1, 1, 1
        if not (x and y and width and height) then
            for x in next, self.frame.pixels do
                real_x1 = math.min(real_x1, x)
                real_x2 = math.max(real_x2, x)
                for y in next, self.frame.pixels[x] do
                    real_y1 = math.min(real_y1, y)
                    real_y2 = math.max(real_y2, y)
                end
            end
        end

        x, y = x or real_x1, y or real_y1

        for y=y, height and y + height - 1 or real_y2 do
            local row = {}

            local i, last_color_at = 1, 0
            for x=x, width and x + width - 1 or real_x2 do
                local pixel = transparent and (not self.frame:is_pixel_custom(x, y)) and {} or self.frame:get_pixel(x, y)

                local color = color_utils.colors[pixel.background] or " "
                row[#row + 1] = color
                
                if color ~= " " then last_color_at = i; end
                i = i + 1
            end

            image[#image + 1] = table.concat(row):sub(0, last_color_at)
        end
        return table.concat(image, "\n")
    end,
    -- Returns a string which is screen_buffer.frame converted into nft format (https://github.com/oeed/CraftOS-Standards/blob/master/standards/6-nft.md):
    --  x is the starting x pos in the screen buffer
    --  y is the starting y pos in the screen buffer
    --  width is the width of the rectangle that is going to be taken starting from x,y in the screen buffer
    --  height is the height of the rectangle that is going to be taken starting from x,y in the screen buffer
    frame_to_nft = function (self, x, y, width, height)
        local image = {}
        for rel_y=1, height do
            local row = {}
            local last_bg, last_fg
            for rel_x=1, width do
                local pixel = self.frame.pixels[x + rel_x - 1] and self.frame.pixels[x + rel_x - 1][y + rel_y - 1] or {
                    char = " ",
                    foreground = self.frame.background,
                    background = self.frame.background
                }

                if pixel.background ~= last_bg then
                    row[#row + 1] = "\30"
                    row[#row + 1] = color_utils.colors[pixel.background]
                    last_bg = pixel.background
                end

                if pixel.foreground ~= last_fg then
                    row[#row + 1] = "\31"
                    row[#row + 1] = color_utils.colors[pixel.foreground]
                    last_fg = pixel.foreground
                end

                row[#row + 1] = pixel.char == "\30" and "\24" or pixel.char == "\31" and "\25" or pixel.char
            end
            image[#image + 1] = table.concat(row)
        end
        return table.concat(image, "\n")
    end,
    -- DRAWS A LINE ON THE SCREEN
    line = function (self, x1, y1, x2, y2, color) -- SOURCE: https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
        if math.abs(y2 - y1) < math.abs(x2 - x1) then
            if x1 > x2 then
                internal_draw.lineLow(self, x2, y2, x1, y1, color)
            else
                internal_draw.lineLow(self, x1, y1, x2, y2, color)
            end
        else
            if y1 > y2 then
                internal_draw.lineHigh(self, x2, y2, x1, y1, color)
            else
                internal_draw.lineHigh(self, x1, y1, x2, y2, color)
            end
        end
    end,
    -- DRAWS A CIRCLE ON THE SCREEN
    circle = function (self, xCenter, yCenter, radius, color, hollow) -- SOURCE: http://groups.csail.mit.edu/graphics/classes/6.837/F98/Lecture6/circle.html
    
        local r2 = radius * radius
        
        if hollow then
            self.buffer:set_pixel(xCenter         , yCenter + radius, " ", color, color)
            self.buffer:set_pixel(xCenter         , yCenter - radius, " ", color, color)
            self.buffer:set_pixel(xCenter + radius, yCenter         , " ", color, color)
            self.buffer:set_pixel(xCenter - radius, yCenter         , " ", color, color)
        else
            self:line(xCenter, yCenter + radius, xCenter, yCenter - radius, color)
            self:line(xCenter + radius, yCenter, xCenter - radius, yCenter, color)
        end
    
        local x = 1
        local y = math.floor(math.sqrt(r2 - 1) + 0.5)
    
        while x < y do
            if hollow then
                self.buffer:set_pixel(xCenter + x, yCenter + y, " ", color, color)
                self.buffer:set_pixel(xCenter + x, yCenter - y, " ", color, color)
                self.buffer:set_pixel(xCenter - x, yCenter + y, " ", color, color)
                self.buffer:set_pixel(xCenter - x, yCenter - y, " ", color, color)
                self.buffer:set_pixel(xCenter + y, yCenter + x, " ", color, color)
                self.buffer:set_pixel(xCenter + y, yCenter - x, " ", color, color)
                self.buffer:set_pixel(xCenter - y, yCenter + x, " ", color, color)
                self.buffer:set_pixel(xCenter - y, yCenter - x, " ", color, color)
            else
                self:line(xCenter + x, yCenter + y, xCenter + x, yCenter - y, color)
                self:line(xCenter - x, yCenter + y, xCenter - x, yCenter - y, color)
                self:line(xCenter + y, yCenter + x, xCenter + y, yCenter - x, color)
                self:line(xCenter - y, yCenter + x, xCenter - y, yCenter - x, color)
            end
    
            x = x + 1
            y = math.floor(math.sqrt(r2 - x * x) + 0.5)
        end
    
        if x == y then
            if hollow then
                self.buffer:set_pixel(xCenter + x, yCenter + y, " ", color, color)
                self.buffer:set_pixel(xCenter + x, yCenter - y, " ", color, color)
                self.buffer:set_pixel(xCenter - x, yCenter + y, " ", color, color)
                self.buffer:set_pixel(xCenter - x, yCenter - y, " ", color, color)
            else
                self:line(xCenter + x, yCenter + y, xCenter + x, yCenter - y, color)
                self:line(xCenter - x, yCenter + y, xCenter - x, yCenter - y, color)
            end
        end
    end
}
-- Making the buffer of screen_buffer usable as a metatable
screen_buffer.buffer.__index = internal_draw.buffer
setmetatable(screen_buffer.buffer, screen_buffer.buffer)
setmetatable(screen_buffer.frame, screen_buffer.buffer)

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
            local this_time = os.clock()
            if this_time >= self.clock + self.interval then
                local delta_time = this_time - self.clock
                self:reset_timer()
                self.callbacks.onClock(self, formatted_event, delta_time)
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
                text_alignment = const.ALIGN_LEFT,
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
        draw = function (self, delta_time)
            if self.hidden then return; end
            if self.callbacks.onDraw(self, delta_time) then return; end

            
            local lines = string_utils.split_by_char(self.text, "\n")

            if self.text_alignment == const.ALIGN_LEFT then
                for key, line in next, lines do
                    screen_buffer:write(self.pos.x, self.pos.y + key - 1, line, self.colors.foreground, self.colors.background)
                end
            elseif self.text_alignment == const.ALIGN_CENTER then
                for key, line in next, lines do
                    screen_buffer:write(self.pos.x - #line / 2 + 1, self.pos.y + key - 1, line, self.colors.foreground, self.colors.background)
                end
            elseif self.text_alignment == const.ALIGN_RIGHT then
                for key, line in next, lines do
                    screen_buffer:write(self.pos.x - #line + 1, self.pos.y + key - 1, line, self.colors.foreground, self.colors.background)
                end
            end
        end
    },
    Button = {
        -- RETURNS NEW BUTTON
        new = function (x, y, width, height, text, foreground, active_background, unactive_background, hover_background)
            local newButton = {
                draw_priority = const.LOW_PRIORITY,
                focussed = false,
                hidden = false,
                hoverable = hover_background and true or false,
                active = false,
                hovered = false,
                shortcut_once = true,
                shortcut = {},
                text_alignment = const.ALIGN_CENTER,
                text = text,
                pos = math_utils.Vector2.new(x, y),
                size = math_utils.Vector2.new(width, height),
                border = false,
                timed = {
                    enabled = false,
                    clock = gui_elements.Clock.new(0.5)
                },
                colors = {
                    foreground = foreground,
                    hover_background = hover_background,
                    active_background = active_background,
                    unactive_background = unactive_background,
                    border_color = colors.white
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end,
                    onFailedPress = function () end,
                    onTimeout = function () end,
                    onHover = function () end
                }
            }
            newButton.timed.clock.binded_button = newButton
            newButton.timed.clock.oneshot = true
            newButton.timed.clock:stop()
            newButton.timed.clock:set_callback(
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
        draw = function (self, delta_time)
            if self.hidden then return; end
            if self.callbacks.onDraw(self, delta_time) then return; end
            if self.active then 
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.active_background, self.border, self.colors.border_color)
            elseif self.hovered then
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.hover_background, self.border, self.colors.border_color)
            else
                screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.unactive_background, self.border, self.colors.border_color)
            end

            local lines = string_utils.split_by_char(self.text, "\n")
            local text_y = (self.size.y - #lines) / 2 + self.pos.y

            for rel_y=0, #lines - 1 do
                local line = lines[rel_y + 1]
                local line_x
                if self.text_alignment == const.ALIGN_LEFT then
                    line_x = self.pos.x
                elseif self.text_alignment == const.ALIGN_CENTER then
                    line_x = (self.size.x - #line) / 2 + self.pos.x
                elseif self.text_alignment == const.ALIGN_RIGHT then
                    line_x = self.pos.x + self.size.x - #line
                end
                screen_buffer:write(line_x, text_y + rel_y, line, self.colors.foreground)
            end
        end,
        -- GIVES EVENT TO BUTTON
        event = function (self, formatted_event)
            if self.hidden then return false; end
            if formatted_event.name == const.TOUCH then
                if event_utils.in_area(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    self:press(formatted_event)
                    return true -- RETURNING TRUE DELETES THE EVENT
                else
                    self.callbacks.onFailedPress(self, formatted_event)
                end
            elseif event.name == const.KEY then
                if input:are_keys_pressed(self.shortcut_once, table.unpack(self.shortcut)) then
                    self:press(formatted_event)
                end
            elseif self.hoverable then
                if formatted_event.name == const.MOUSEMOVE or formatted_event.name == const.MOUSEDRAG then
                    if ((not formatted_event.x) or not formatted_event.y) then
                        if self.hovered then
                            self.hovered = false
                            self.callbacks.onHover(self, formatted_event)
                        end
                    elseif event_utils.in_area(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                        if not self.hovered then
                            self.hovered = true
                            self.callbacks.onHover(self, formatted_event)
                        end
                        return true
                    elseif self.hovered then
                        self.hovered = false
                        self.callbacks.onHover(self, formatted_event)
                    end
                elseif self.hovered and formatted_event.name == const.DELETED then
                    self.hovered = false
                    self.callbacks.onHover(self, formatted_event)
                end
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
        draw = function (self, delta_time)
            if self.hidden then return; end
            if self.callbacks.onDraw(self, delta_time) then return; end
            local value_percentage = math_utils.map(self.value.current, self.value.min, self.value.max, 0, 1, true)
            
            local filled_progress_width = self.size.x * value_percentage
            screen_buffer:rectangle(self.pos.x, self.pos.y, filled_progress_width, self.size.y, self.colors.filled_background)
            screen_buffer:rectangle(self.pos.x + filled_progress_width, self.pos.y, self.size.x - filled_progress_width, self.size.y, self.colors.unfilled_background)

            if self.value.draw_percentage then
                local percentage_text = table.concat({string_utils.format_number(value_percentage * 100, self.value.percentage_precision), "%"})
                local text_x = (self.size.x - #percentage_text) / 2 + self.pos.x
                local text_y = (self.size.y - 1) / 2 + self.pos.y
                screen_buffer:write(text_x, text_y, percentage_text, self.colors.foreground)
            end
        end,
        -- GIVES EVENT TO PROGRESSBAR
        event = function (self, formatted_event)
            if self.hidden then return false; end
            if formatted_event.name == const.TOUCH then
                if event_utils.in_area(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
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
                rich_text = {},
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
                border = false,
                colors = {
                    foreground = foreground,
                    background = background,
                    cursor = colors.white,
                    cursor_text = colors.black,
                    border_color = colors.white
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end,
                    onFailedPress = function () end,
                    onFocus = function () end,
                    onKey = function () end,
                    onChar = function () end,
                    onMouseScroll = function () end,
                    onCursorChange = function () end,
                    onWrite = function () end,
                    onPaste = function () end
                }
            }
            newMemo.cursor.blink.binded_cursor = newMemo.cursor
            newMemo.cursor.blink:set_callback(
                const.ONCLOCK,
                function (self, formatted_event)
                    self.binded_cursor.visible = not self.binded_cursor.visible
                end
            )
            setmetatable(newMemo, gui_elements.Memo)
            return newMemo
        end,
        -- DRAWS MEMO
        draw = function (self, delta_time)
            if self.hidden then return; end
            if self.callbacks.onDraw(self, delta_time) then return; end
            
            screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.background, self.border, self.colors.border_color)
            
            local this_pos_x = self.pos.x
            local this_pos_y = self.pos.y
            local this_size_x = self.size.x
            local this_size_y = self.size.y
            if self.border then
                this_pos_x = this_pos_x + 1
                this_pos_y = this_pos_y + 1
                this_size_x = this_size_x - 2
                this_size_y = this_size_y - 2
            end

            local rel_cursor_x = self.cursor.pos.x - self.first_visible_char
            local rel_cursor_y = self.cursor.pos.y - self.first_visible_line

            for y=1, this_size_y do
                local line_i = y + self.first_visible_line - 1
                local rich_line = self.rich_text[line_i] or {}

                local line = self.lines[line_i] or ""
                local line_visible_start = self.first_visible_char
                local line_visible_end = self.first_visible_char + this_size_x - 1
                local visible_line = line:sub(line_visible_start, line_visible_end)

                local y_pos = this_pos_y + y - 1

                if rich_line.background then
                    if type(rich_line.background) == "string" then
                        local bg = rich_line.background:sub(line_visible_start, line_visible_end)
                        bg = #bg > 0 and bg or rich_line.background:sub(#rich_line.background)
                        screen_buffer:blit(
                            this_pos_x, y_pos, string.rep(" ", this_size_x),
                            nil,
                            bg
                        )
                    else
                        screen_buffer:rectangle(this_pos_x, y_pos, this_size_x, 1, rich_line.background)
                    end
                end
                
                if rich_line.foreground then
                    if type(rich_line.foreground) == "string" then
                        local fg = rich_line.foreground:sub(line_visible_start, line_visible_end)
                        fg = #fg > 0 and fg or rich_line.foreground:sub(#rich_line.foreground)
                        screen_buffer:blit(
                            this_pos_x, y_pos, visible_line,
                            fg
                        )
                    else
                        screen_buffer:write(this_pos_x, y_pos, visible_line, rich_line.foreground)
                    end
                else
                    screen_buffer:write(this_pos_x, y_pos, visible_line, self.colors.foreground)
                end
            end

            if self.cursor.visible and (rel_cursor_x >= 0) and (rel_cursor_x < this_size_x) and (rel_cursor_y >= 0) and (rel_cursor_y < this_size_y) then
                screen_buffer:write(
                    rel_cursor_x + this_pos_x,
                    rel_cursor_y + this_pos_y,
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
                if event_utils.in_area(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                    self.callbacks.onPress(self, formatted_event)
                    self:focus(true, formatted_event)
                    local x = formatted_event.x - self.pos.x
                    local y = formatted_event.y - self.pos.y
                    if self.border then
                        if event_utils.in_area(formatted_event.x, formatted_event.y, self.pos.x + 1, self.pos.y + 1, self.size.x - 2, self.size.y - 2) then
                            self:set_cursor(x + self.first_visible_char - 1, y + self.first_visible_line - 1)
                        end
                    else
                        self:set_cursor(x + self.first_visible_char, y + self.first_visible_line)
                    end
                    
                    return true -- RETURNING TRUE DELETES THE EVENT
                else
                    self.callbacks.onFailedPress(self, formatted_event)
                    self:focus(false, formatted_event)
                    return false
                end
            elseif formatted_event.name == const.DELETED then
                self:focus(false, formatted_event)
                return false
            end
            if self.focussed then
                self.cursor.blink:event(self.cursor.blink, formatted_event)
                if formatted_event.name == const.PASTE then
                    if self.callbacks.onPaste(self, formatted_event) then return true; end
                    self:write(formatted_event.paste)
                    return true
                elseif formatted_event.name == const.CHAR then
                    if self.callbacks.onChar(self, formatted_event) then return true; end
                    self:write(formatted_event.char)
                    return true
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
                            self:write(table.concat({this_line, "\n", prev_line}))
                            self:set_cursor(old_x, self.cursor.pos.y - 1)
                        end
                        return true
                    
                    
                    elseif input:are_keys_pressed(false, const.KEY_LEFTALT, const.KEY_DOWN) then
                        local this_line = self.lines[self.cursor.pos.y]
                        local next_line = self.lines[self.cursor.pos.y + 1]

                        if not next_line then return false; end

                        self.lines[self.cursor.pos.y] = ""
                        table.remove(self.lines, self.cursor.pos.y + 1)

                        local old_x = self.cursor.pos.x

                        self:set_cursor(1, self.cursor.pos.y)
                        self:write(table.concat({next_line, "\n", this_line}))
                        self:set_cursor(old_x, self.cursor.pos.y)
                        return true


                    elseif formatted_event.key == const.KEY_UP then
                        self:set_cursor(self.cursor.pos.x, self.cursor.pos.y - 1)
                        return true
                        
                        
                    elseif formatted_event.key == const.KEY_DOWN then
                        self:set_cursor(self.cursor.pos.x, self.cursor.pos.y + 1)
                        return true
                        
                        
                    elseif formatted_event.key == const.KEY_RIGHT then
                        local line = self.lines[self.cursor.pos.y]
                        if self.lines[self.cursor.pos.y + 1] and self.cursor.pos.x >= #line + 1 then
                            self:set_cursor(1, self.cursor.pos.y + 1)
                        else
                            self:set_cursor(self.cursor.pos.x + 1, self.cursor.pos.y)
                        end
                        return true


                    elseif formatted_event.key == const.KEY_LEFT then
                        if self.cursor.pos.x <= 1 and self.cursor.pos.y > 1 then
                            local previous_line = self.lines[self.cursor.pos.y - 1]
                            self:set_cursor(#previous_line + 1, self.cursor.pos.y - 1)
                        else
                            self:set_cursor(self.cursor.pos.x - 1, self.cursor.pos.y)
                        end
                        return true


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
                            local new_line = table.concat({line:sub(1, self.cursor.pos.x - 2), line:sub(self.cursor.pos.x)})
                            self.lines[self.cursor.pos.y] = new_line
                            self:set_cursor(self.cursor.pos.x - 1, self.cursor.pos.y)
                            self.callbacks.onWrite(self, new_line, {new_line})
                        end
                        return true


                    elseif formatted_event.key == const.KEY_DELETE then
                        local line = self.lines[self.cursor.pos.y]
                        local line_end = line:sub(self.cursor.pos.x)

                        if #line_end > 0 then
                            local new_line = table.concat({line:sub(1, self.cursor.pos.x - 1), line:sub(self.cursor.pos.x + 1)})
                            self.lines[self.cursor.pos.y] = new_line
                            self.callbacks.onWrite(self, new_line, {new_line})
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
                        return true
                        

                    elseif formatted_event.key == const.KEY_ENTER then
                        local current_line_to_cursor = self.lines[self.cursor.pos.y]:sub(0, self.cursor.pos.x - 1)
                        local spaces = current_line_to_cursor:gsub("(%s*).*", "%1")
                        self:write(table.concat({"\n", spaces}))
                        return true
                    
                    
                    elseif formatted_event.key == const.KEY_END then
                        self:set_cursor(#self.lines[self.cursor.pos.y] + 1, self.cursor.pos.y)
                        return true

                        
                    elseif formatted_event.key == const.KEY_HOME then
                        local current_line_to_cursor = self.lines[self.cursor.pos.y]:sub(0, self.cursor.pos.x - 1)
                        local spaces = current_line_to_cursor:gsub("(%s*).*", "%1")
                        self:set_cursor(#spaces + 1, self.cursor.pos.y)
                        return true


                    elseif input:are_keys_pressed(false, const.KEY_LEFTSHIFT, const.KEY_TAB) then
                        local current_line = self.lines[self.cursor.pos.y]
                        local spaces = current_line:gsub("^(%s*).*$", "%1")
                        local total_spaces = math.min(#self.tab_spaces, #spaces)
                        
                        local new_line = current_line:sub(total_spaces + 1)
                        self.lines[self.cursor.pos.y] = new_line
                        self:set_cursor(self.cursor.pos.x - total_spaces, self.cursor.pos.y)
                        self.callbacks.onWrite(self, new_line, {new_line})
                        return true


                    elseif formatted_event.key == const.KEY_TAB then
                        local old_x = self.cursor.pos.x
                        local line_len = #self.lines[self.cursor.pos.y]
                        self:set_cursor(1, self.cursor.pos.y)
                        self:write(self.tab_spaces)
                        local delta_x = #self.lines[self.cursor.pos.y] - line_len
                        self:set_cursor(old_x + delta_x, self.cursor.pos.y)
                        return true


                    end
                elseif formatted_event.name == const.MOUSESCROLL then
                    if self.callbacks.onMouseScroll(self, formatted_event) then return true; end
                    self.first_visible_line = math_utils.constrain(self.first_visible_line + formatted_event.direction, 1, #self.lines)
                    return true
                end
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
            
            local rel_cursor_x = cursor_x - self.first_visible_char
            local rel_cursor_y = cursor_y - self.first_visible_line

            local this_size_x = self.size.x
            local this_size_y = self.size.y
            if self.border then
                this_size_x = this_size_x - 2
                this_size_y = this_size_y - 2
            end

            if rel_cursor_x >= this_size_x then
                self.first_visible_char = self.first_visible_char + rel_cursor_x - this_size_x + 1
            elseif rel_cursor_x < 0 then
                self.first_visible_char = self.first_visible_char + rel_cursor_x
            end

            if rel_cursor_y >= this_size_y then
                self.first_visible_line = self.first_visible_line + rel_cursor_y - this_size_y + 1
            elseif rel_cursor_y < 0 then
                self.first_visible_line = self.first_visible_line + rel_cursor_y
            end

            self.callbacks.onCursorChange(self, cursor_x, cursor_y)
            self.cursor.pos = math_utils.Vector2.new(cursor_x, cursor_y)
        end,
        -- WRITES TEXT WHERE THE CURSOR IS
        write = function (self, ...)
            local text = table.concat({...})
            local lines = string_utils.split_by_char(text, "\n")
            self:set_cursor(self.cursor.pos.x, self.cursor.pos.y, true)

            if #self.whitelist > 0 then
                local pattern = table.concat({"[^", string_utils.escape_magic_characters(table.concat(self.whitelist)), "]"})
                for key, line in next, lines do
                    lines[key] = line:gsub(pattern, "")
                end
            elseif #self.blacklist > 0 then
                local pattern = table.concat({"[", string_utils.escape_magic_characters(table.concat(self.blacklist)), "]"})
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

                        self.lines[self.cursor.pos.y] = table.concat({line_start, line})

                        table.insert(self.lines, self.cursor.pos.y + 1, table.concat({last_line, line_end}))

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
                self.lines[self.cursor.pos.y] = table.concat({line_start, lines[1], line_end})
                self:set_cursor(self.cursor.pos.x + #lines[1], self.cursor.pos.y)
            end
            self.callbacks.onWrite(self, text, lines)
        end,
        print = function (self, ...)
            local text = table.concat({...})
            local new_line = #self.lines > 0 and "\n" or ""
            self:write(table.concat({new_line, text}))
        end,
        clear = function (self)
            self.lines = {}
            self.callbacks.onCursorChange(self, 1, 1)
            self.cursor.pos = math_utils.Vector2.new(1, 1)
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
                can_drag = false,
                border = false,
                dragging = {
                    enabled = true,
                    from = math_utils.Vector2.new(1, 1)
                },
                resizing = {
                    enabled = true,
                    corner = math_utils.Vector2.new(-1, 1),
                    enabled_directions = {
                        -- Columns are the X axis
                        -- Rows are the Y axis
                        -- e.g. Window.resizing.enabled_directions[X][Y] (0, 0 is the middle)
                        [-1] = {[1] = true, [0] = true,  [-1] = true},
                        [ 0] = {[1] = true, [0] = false, [-1] = true},
                        [ 1] = {[1] = true, [0] = true,  [-1] = true}
                    },
                    pinned = {
                        x = false,
                        y = false
                    },
                    min_size = math_utils.Vector2.new(width, height),
                    max_size = math_utils.Vector2.new(width, height) * 2
                },
                shadow = {
                    enabled = shadow,
                    offset = math_utils.Vector2.new(1, 1)
                },
                elements = {},
                colors = {
                    background = background,
                    shadow = colors.black,
                    border_color = colors.white
                },
                callbacks = {
                    onDraw = function () end,
                    onPress = function () end,
                    onFailedPress = function () end,
                    onEvent = function () end,
                    onFocus = function () end,
                    onDrag = function () end,
                    onResize = function () end
                }
            }
            setmetatable(newWindow, gui_elements.Window)
            return newWindow
        end,
        -- DRAWS THE WINDOW
        draw = function (self, delta_time)
            if self.hidden then return; end
            if self.callbacks.onDraw(self, delta_time) then return; end
            if self.shadow.enabled then
                screen_buffer:rectangle(
                    self.pos.x + self.shadow.offset.x,
                    self.pos.y + self.shadow.offset.y,
                    self.size.x,
                    self.size.y,
                    self.colors.shadow
                )
            end

            screen_buffer:rectangle(self.pos.x, self.pos.y, self.size.x, self.size.y, self.colors.background, self.border, self.colors.border_color)

            self:draw_elements(delta_time)
        end,
        -- GIVES EVENT TO WINDOW
        event = function (self, formatted_event)
            if self.hidden then return false; end
            if self.callbacks.onEvent(self, formatted_event) then return true; end
            local delete_event = self:event_elements(formatted_event)
            if not delete_event then
                if formatted_event.name == const.TOUCH then
                    if event_utils.in_area(formatted_event.x, formatted_event.y, self.pos.x, self.pos.y, self.size.x, self.size.y) then
                        self.can_drag = false
                        if self.resizing.enabled then
                            local resizing = true
                            local bottom = formatted_event.y == self.pos.y + self.size.y - 1
                            local top = formatted_event.y == self.pos.y
                            if formatted_event.x == self.pos.x + self.size.x - 1 then
                                if self.resizing.enabled_directions[1][1] and bottom then
                                    self.resizing.corner = self.pos.ONE:duplicate()
                                    self.resizing.pinned.x = false
                                    self.resizing.pinned.y = false
                                elseif self.resizing.enabled_directions[1][-1] and top then
                                    self.resizing.corner = self.pos.UP + self.pos.RIGHT
                                    self.resizing.pinned.x = false
                                    self.resizing.pinned.y = false
                                elseif self.resizing.enabled_directions[1][0] and not (bottom or top) then
                                    self.resizing.corner = self.pos.UP + self.pos.RIGHT
                                    self.resizing.pinned.x = false
                                    self.resizing.pinned.y = true
                                else
                                    resizing = false
                                end
                            elseif formatted_event.x == self.pos.x then
                                if self.resizing.enabled_directions[-1][1] and bottom then
                                    self.resizing.corner = self.pos.DOWN + self.pos.LEFT
                                    self.resizing.pinned.x = false
                                    self.resizing.pinned.y = false
                                elseif self.resizing.enabled_directions[-1][-1] and top then
                                    self.resizing.corner = self.pos.ONE * -1
                                    self.resizing.pinned.x = false
                                    self.resizing.pinned.y = false
                                elseif self.resizing.enabled_directions[-1][0] and not (bottom or top) then
                                    self.resizing.corner = self.pos.ONE * -1
                                    self.resizing.pinned.x = false
                                    self.resizing.pinned.y = true
                                else
                                    resizing = false
                                end
                            elseif self.resizing.enabled_directions[0][1] and bottom then
                                self.resizing.corner = self.pos.DOWN + self.pos.RIGHT
                                self.resizing.pinned.x = true
                                self.resizing.pinned.y = false
                            elseif self.resizing.enabled_directions[0][-1] and top then
                                self.resizing.corner = self.pos.UP + self.pos.RIGHT
                                self.resizing.pinned.x = true
                                self.resizing.pinned.y = false
                            else
                                resizing = false
                            end
                            if not resizing then
                                self.resizing.corner = self.pos.ZERO:duplicate()
                                self.dragging.from = math_utils.Vector2.new(formatted_event.x, formatted_event.y)
                                self.can_drag = self.dragging.enabled and true
                            end
                        else
                            self.dragging.from = math_utils.Vector2.new(formatted_event.x, formatted_event.y)
                            self.can_drag = self.dragging.enabled and true
                        end
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
                    if self.can_drag then
                        self:drag(formatted_event.x, formatted_event.y)
                    else
                        self:resize(formatted_event.x, formatted_event.y, self.resizing.pinned.x, self.resizing.pinned.y)
                    end
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
        -- DRAGS WINDOW TO POS BASED ON dragging.from
        drag = function (self, x, y)
            if self.dragging.enabled then
                local old_pos = self.pos:duplicate()
                self.pos = self.pos + math_utils.Vector2.new(
                    x - self.dragging.from.x,
                    y - self.dragging.from.y
                )
                self.dragging.from = math_utils.Vector2.new(x, y)

                self.callbacks.onDrag(self, old_pos.x, old_pos.y)
            end
        end,
        -- RESIZES WINDOW BASED ON resizing
        resize = function (self, x, y, pin_x, pin_y)
            if self.resizing.enabled and self.resizing.corner ~= self.pos.ZERO then
                local function constrain_size()
                    self.size.x = math_utils.constrain(self.size.x, self.resizing.min_size.x, self.resizing.max_size.x)
                    self.size.y = math_utils.constrain(self.size.y, self.resizing.min_size.y, self.resizing.max_size.y)
                end

                local new_pos = math_utils.Vector2.new(x, y)
                local old_pos = self.pos:duplicate()
                local old_size = self.size:duplicate()

                if self.resizing.corner == self.pos.ONE then
                    self.size.x = new_pos.x - self.pos.x + 1
                    self.size.y = new_pos.y - self.pos.y + 1
                    constrain_size()
                elseif self.resizing.corner == self.pos.ONE * -1 then
                    self.size.x = self.size.x + self.pos.x - new_pos.x
                    self.size.y = self.size.y + self.pos.y - new_pos.y
                    constrain_size()

                    local delta_pos = old_size - self.size
                    self.pos = self.pos + delta_pos
                elseif self.resizing.corner == self.pos.UP + self.pos.RIGHT then
                    self.size.x = new_pos.x - self.pos.x + 1
                    self.size.y = self.size.y + self.pos.y - new_pos.y
                    constrain_size()

                    local delta_y = old_size.y - self.size.y
                    self.pos.y = self.pos.y + delta_y
                elseif self.resizing.corner == self.pos.DOWN + self.pos.LEFT then
                    self.size.x = self.size.x + self.pos.x - new_pos.x
                    self.size.y = new_pos.y - self.pos.y + 1
                    constrain_size()

                    local delta_x = old_size.x - self.size.x
                    self.pos.x = self.pos.x + delta_x
                end

                if pin_x then self.size.x = old_size.x; self.pos.x = old_pos.x; end
                if pin_y then self.size.y = old_size.y; self.pos.y = old_pos.y; end

                self.callbacks.onResize(self, old_pos.x, old_pos.y, old_size.x, old_size.y)
            end
        end,
        -- SETS WINDOW'S ELEMENTS
        set_elements = function (self, elements_table)
            self.elements = {}
            for key, element in next, elements_table do
                table.insert(self.elements, element)
            end
        end,
        -- DRAWS ALL WINDOW'S ELEMENTS
        draw_elements = function (self, delta_time)
            for key=#self.elements, 1, -1 do
                local element = self.elements[key]
                if element.draw then
                    element.pos = element.pos + self.pos - self.pos.ONE
                    element:draw(delta_time)
                    element.pos = element.pos - self.pos + self.pos.ONE
                end
            end
        end,
        -- GIVES EVENT TO ALL WINDOW'S ELEMENTS
        event_elements = function (self, formatted_event)
            local this_event = formatted_event
            if this_event.x and this_event.y then
                this_event = event_utils.format_event_table(this_event.raw)
                this_event.x, this_event.y = this_event.x - self.pos.x + 1, this_event.y - self.pos.y + 1
            end

            local delete_event = false
            
            for key, element in next, self.elements do
                if element.event then
                    local this_delete_event = element:event(this_event)
                    delete_event = delete_event or this_delete_event
                    if this_delete_event then
                        this_event = {name = const.DELETED, deleted = formatted_event}
                    end
                end
            end

            return delete_event
        end
    },
    -- It's basically the same as screen_buffer, but it's a gui element
    Canvas = {
        new = function (x, y, width, height)
            local newCanvas = {
                draw_priority = const.LOW_PRIORITY,
                hidden = false,
                pos = math_utils.Vector2.new(x, y),
                size = math_utils.Vector2.new(width, height),
                transparent = false,
                buffer =  {
                    pixels = {},
                    background = {
                        char = " ",
                        foreground = colors.black,
                        background = colors.black,
                        inverted = false
                    }
                },
                callbacks = {
                    onDraw = function () end
                }
            }
            setmetatable(newCanvas.buffer, screen_buffer.buffer)
            setmetatable(newCanvas, gui_elements.Canvas)
            return newCanvas
        end,
        draw = function (self)
            if self.hidden then return; end
            if self.callbacks.onDraw(self, delta_time) then return; end

            self:cast(screen_buffer)
        end,
        cast = function (self, other)
            if self.transparent then
                -- This should be faster than the other method
                for x=1, self.size.x do
                    if self.buffer.pixels[x] then
                        for y=1, self.size.y do
                            local pixel = self.buffer.pixels[x][y]
                            if pixel then
                                if pixel.inverted then
                                    other.buffer:set_pixel(self.pos.x + x - 1, self.pos.y + y - 1, pixel.char, pixel.background, pixel.foreground, true)
                                else
                                    other.buffer:set_pixel(self.pos.x + x - 1, self.pos.y + y - 1, pixel.char, pixel.foreground, pixel.background)
                                end
                            end
                        end
                    end
                end
            else
                for y=1, self.size.y do
                    for x=1, self.size.x do
                        local pixel = self.buffer:get_pixel(x, y)
                        if pixel.inverted then
                            other.buffer:set_pixel(self.pos.x + x - 1, self.pos.y + y - 1, pixel.char, pixel.background, pixel.foreground, true)
                        else
                            other.buffer:set_pixel(self.pos.x + x - 1, self.pos.y + y - 1, pixel.char, pixel.foreground, pixel.background)
                        end
                    end
                end
            end
        end,
        to_nfp = function (self, ...)
            return screen_buffer.frame_to_nfp({frame = self.buffer}, ...)
        end,
        to_nft = function (self, ...)
            return screen_buffer.frame_to_nft({frame = self.buffer}, ...)
        end
    }
}

gui_elements.Clock.__index = gui_elements.Clock
gui_elements.Label.__index = gui_elements.Label
gui_elements.Button.__index = gui_elements.Button
gui_elements.Progressbar.__index = gui_elements.Progressbar
gui_elements.Memo.__index = gui_elements.Memo
gui_elements.Window.__index = gui_elements.Window

-- Copying screen_buffer functions
for key, func in next, screen_buffer do
    if (
        type(func) == "function" and        -- Make sure that's a function (We don't want to reference tables)
        (not gui_elements.Canvas[key]) and  -- Make sure it wasn't overridden
        (not key:find("set_")) and          -- It shouldn't be a function that sets something (monitors, ...)
        (not key:find("frame"))             -- It also shouldn't be related to screen_buffer.frame (not a thing in Canvases)
    ) then
        gui_elements.Canvas[key] = func
    end
end
gui_elements.Canvas.__index = gui_elements.Canvas

-- WSS MODULE
local WSS = {}
WSS = {
    new = function (broadcast_interval)
        local newWSS = {
            draw_priority = const.LOW_PRIORITY,
            enabled = true,
            buffer = {},
            events_whitelist = {
                [const.TOUCH] = true,
                [const.KEY] = true,
                [const.KEYUP] = true,
                [const.CHAR] = true,
                [const.MOUSEDRAG] = true,
                [const.MOUSESCROLL] = true,
                [const.MOUSEUP] = true
            },
            close_on_host_disconnect = true,
            side = const.NONE,
            mode = const.NONE,
            host_id = const.NONE,
            users = {},
            protocol = "YAGUI-"..info.ver.."_WSS",
            broadcast_clock = gui_elements.Clock.new(broadcast_interval or 4),
            callbacks = {
                onDraw = function () end,
                onEvent = function () end,
                onConnect = function () end,
                onDisconnect = function () end
            }
        }
        newWSS.broadcast_clock.WSS = newWSS
        newWSS.broadcast_clock:set_callback(
            const.ONCLOCK,
            function (self, formatted_event)
                rednet.broadcast(
                    screen_buffer.frame,
                    self.WSS.protocol
                )
            end
        )
        setmetatable(newWSS, WSS)
        return newWSS
    end,
    draw = function (self, delta_time)
        if not self.enabled then return false; end
        if self.callbacks.onDraw(self, delta_time) then return; end

        if self.mode == const.USER then
            if self.buffer and self.buffer.background and self.buffer.pixels then
                screen_buffer.buffer.background = self.buffer.background
                screen_buffer.buffer.pixels = self.buffer.pixels
            end
        end
    end,
    event = function (self, formatted_event)
        if not self.enabled then return false; end
        if self.callbacks.onEvent(self, formatted_event) then return true; end

        local return_value = false
        if formatted_event.name == const.REDNET then
            if formatted_event.protocol == self.protocol then
                local msg = formatted_event.message
                if self.mode == const.HOST then
                    if msg == const.CONNECTION_REQUEST then
                        rednet.send(formatted_event.from, const.OK, self.protocol)
                        self.users[formatted_event.from] = true
                        return_value = true
                        self.callbacks.onConnect(self, formatted_event)
                    elseif msg == const.DISCONNECTED then
                        self.users[formatted_event.from] = nil
                        return_value = true
                        self.callbacks.onDisconnect(self, formatted_event)
                    elseif type(msg) == "table" and self.events_whitelist[msg.name] and self.users[formatted_event.from] then
                        if msg.raw then os.queueEvent(table.unpack(msg.raw)); end
                        return_value = true
                    end
                elseif self.mode == const.USER then
                    if formatted_event.from == self.host_id then
                        if msg == const.DISCONNECTED then
                            if self.close_on_host_disconnect then self:close(); end
                            
                            return_value = true
                            self.callbacks.onDisconnect(self, formatted_event)
                        elseif type(msg) == "table" then
                            self.buffer = msg
                            return_value = true
                        end
                    end
                end
            end
        end
        
        if self.mode == const.USER then
            if formatted_event.name == const.TOUCH then
                return_value = true
            end
            if self.events_whitelist[formatted_event.name] then
                rednet.send(self.host_id, formatted_event, self.protocol)
                return_value = true
            end
        elseif self.mode == const.HOST then
            self.broadcast_clock:event(formatted_event)
        end

        return return_value
    end,
    use_side = function (self, side)
        self.side = side
    end,
    connect = function (self, id, timeout, max_attempts)
        timeout = timeout or 2
        max_attempts = max_attempts or 10

        rednet.open(self.side)
        self.host_id = id
        self.mode = const.USER
        rednet.send(self.host_id, const.CONNECTION_REQUEST, self.protocol)

        local attempt = 0
        while true do
            attempt = attempt + 1
            local resp = {rednet.receive(self.protocol, timeout)}

            if resp[1] == id and resp[2] == const.OK and resp[3] == self.protocol then
                return const.OK
            elseif attempt >= max_attempts then
                local err_msg = string.format("Connection timed out on attempt %d after %d ms", attempt, timeout * 1000)
                if #resp > 0 then
                    err_msg = string.format("Connection timed out on attempt %d: invalid response (The traffic on the network may be high, try to increase max attempts)", attempt, timeout * 1000)
                end
                WSS:close()
                error(err_msg, 2)
            end
        end
        self.callbacks.onConnect(self, id)
    end,
    host = function (self)
        rednet.open(self.side)
        self.host_id = os.getComputerID()
        self.mode = const.HOST
    end,
    close = function (self)
        if rednet.isOpen() then
            if self.mode == const.HOST then
                rednet.broadcast(
                    const.DISCONNECTED,
                    self.protocol
                )
            elseif self.mode == const.USER then
                rednet.send(
                    self.host_id,
                    const.DISCONNECTED,
                    self.protocol
                )
            end
            rednet.close(self.side)
        end
        self.host_id = const.NONE
        self.mode = const.NONE
    end
}

WSS.__index = WSS

-- FT MODULE
local FT = {}
FT = {
    new = function (psw)
        local newFT = {
            enabled = true,
            computer_whitelist = {},
            side = const.NONE,
            mode = const.ALL,
            password = psw or const.NONE,
            protocol = "YAGUI-"..info.ver.."_FT",
            save_dir = "/FT",
            callbacks = {
                onEvent = function () end,
                onConnect = function () end,
                onSend = function () end,
                onReceive = function () end
            }
        }
        setmetatable(newFT, FT)
        return newFT
    end,
    event = function (self, formatted_event)
        if not self.enabled then return false; end
        if self.callbacks.onEvent(self, formatted_event) then return true; end

        if (formatted_event.name == const.REDNET) and (formatted_event.protocol == self.protocol) then
            if (self.mode == const.ALL) or (self.mode == const.RECEIVE) then
                local id = formatted_event.from
                if self.computer_whitelist[id] or self.callbacks.onConnect(self, formatted_event) then
                    local msg = formatted_event.message
                    if type(msg) == "table" and msg.name and msg.content then
                        if msg.psw == self.password then
                            local name = fs.getName(tostring(msg.name))
                            local path = fs.combine(self.save_dir, name)
                            
                            if fs.exists(path) then
                                rednet.send(id, const.NO, self.protocol)
                            else
                                local content = tostring(msg.content)
                                if self.callbacks.onReceive(self, formatted_event, id, name, path, content) then return true; end

                                local file = fs.open(path, "w")
                                if file then
                                    file.write(content)
                                    file.close()
                                    rednet.send(id, const.OK, self.protocol)
                                else
                                    rednet.send(id, const.ERROR, self.protocol)
                                end
                            end
                        else
                            rednet.send(id, const.NO, self.protocol)
                        end
                    else
                        rednet.send(id, const.ERROR, self.protocol)
                    end
                else
                    rednet.send(id, const.NO, self.protocol)
                end
            end
        end
    end,
    send = function (self, receiver_id, password, file_path, file_name)
        if (self.mode == const.ALL) or (self.mode == const.SEND) then
            file_name = file_name or fs.getName(file_path)
            password = password or const.NONE
            local file = fs.open(file_path, "r")
            local content = file.readAll()
            file.close()
            local msg = {
                psw = password,
                name = file_name,
                content = content
            }

            if self.callbacks.onSend(self, formatted_event, msg) then return true; end

            rednet.send(
                receiver_id,
                msg,
                self.protocol
            )
        end
    end,
    open = function (self, side)
        self.side = side
        rednet.open(side)
    end,
    close = function (self)
        if rednet.isOpen() then
            rednet.close(self.side)
        end
    end
}

FT.__index = FT

-- LOOP MODULE
local Loop = {}
Loop = {
    -- CREATES A NEW LOOP
    new = function (FPS_target, EPS_target)
        local newLoop = {
            enabled = false,
            options = {
                raw_mode = false,
                stop_on_terminate = true, -- Works only if raw_mode is set to true
                FPS_target = FPS_target,
                EPS_target = EPS_target
            },
            monitors = {
                terminal = term
            },
            threads = {},
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
                show = function (self, state)
                    self.FPS_label.hidden = not state
                    self.EPS_label.hidden = not state
                end,
                update_pos = function (self)
                    self.FPS_label.pos = self.pos
                    self.EPS_label.pos = self.pos + math_utils.Vector2.DOWN
                end,
                Events = 0,
                FPS = 0,
                EPS = 0
            },
            callbacks = {
                onStart = function () end,
                onStop = function () end,
                onDraw = function () end,
                onEvent = function () end
            }
        }
        -- Set references to stats in clock
        newLoop.elements.loop.stats_clock.stats = newLoop.stats
        -- Set a reference to loop elements in stats table
        newLoop.stats.FPS_label = newLoop.elements.loop.FPS_label
        newLoop.stats.EPS_label = newLoop.elements.loop.EPS_label
        -- Set stats_clock callback
        newLoop.elements.loop.stats_clock:set_callback(
            const.ONCLOCK,
            function (self, formatted_event, delta_time)
                self.stats:update_pos()
                self.stats.FPS_label.text = table.concat({math.floor(self.stats.FPS + 0.5), " FPS"})
                self.stats.EPS_label.text = table.concat({math.floor(self.stats.EPS + 0.5), " EPS"})
            end
        )
        newLoop.stats:show(false)
        -- Set draw clock callback
        newLoop.elements.loop.clock.Loop = newLoop
        newLoop.elements.loop.clock:set_callback(
            const.ONCLOCK,
            function (self, formatted_event, delta_time)
                self.Loop.stats.FPS = 1 / delta_time
                self.Loop.stats.EPS = self.Loop.stats.Events / delta_time
                self.Loop.stats.Events = 0

                if #self.Loop.threads > 0 then
                    local dead_threads = {}
                    for i=1, #self.Loop.threads do
                        local thread = self.Loop.threads[i]
                        if coroutine.status(thread) == "dead" then
                            dead_threads[#dead_threads + 1] = i
                        else
                            local returns = {coroutine.resume(thread, self.Loop, delta_time)}
                            os.queueEvent("coroutine", thread, coroutine.status(thread), table.unpack(returns))
                        end
                    end
                    if #dead_threads > 0 then table_utils.better_remove(self.Loop.threads, table.unpack(dead_threads)); end
                end
                
                self.Loop:draw_elements(delta_time)
                
                self.interval = 1 / self.Loop.options.FPS_target
            end
        )
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
    draw_elements = function (self, delta_time)
        local function draw_table(tbl)
            for key=#tbl, 1, -1 do
                local element = tbl[key]
                if element.draw then
                    element:draw(delta_time)
                end
            end
        end

        if self.callbacks.onDraw(self, delta_time) then return; end
        local old_screens = screen_buffer.screens
        screen_buffer.screens = self.monitors

        draw_table(self.elements.low_priority)
        draw_table(self.elements.high_priority)
        for key, element in next, self.elements.loop do
            if element.draw then
                element:draw(delta_time)
            end
        end

        screen_buffer:draw()
        screen_buffer.screens = old_screens
    end,
    -- GIVES AN EVENT TO ALL LOOP ELEMENTS
    event_elements = function (self, formatted_event)
        local function event_table(tbl)
            for key, element in next, tbl do
                if element.event then
                    if element:event(formatted_event) then formatted_event = {name = const.DELETED, deleted = formatted_event}; end
                end
            end
        end

        if self.callbacks.onEvent(self, formatted_event) then
            formatted_event = {name = const.DELETED, deleted = formatted_event}
        end

        if self.options.stop_on_terminate and formatted_event.name == const.TERMINATE then self:stop(); return; end
        
        if formatted_event.name == const.TOUCH then
            local is_monitor_whitelisted = false
            for monitor_name, monitor in next, self.monitors do
                if formatted_event.from == monitor_name then
                    is_monitor_whitelisted = true
                    break
                end
            end
            if not is_monitor_whitelisted then
                formatted_event = {name = const.DELETED, deleted = formatted_event}
            end
        end
        
        event_table(self.elements.loop)

        local high_focussed = {}
        for key, element in next, self.elements.high_priority do
            if element.event then
                local focus = element:event(formatted_event)
                if focus then
                    formatted_event = {name = const.DELETED, deleted = formatted_event}
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
    end,
    -- STARTS THE LOOP
    start = function (self)
        self.enabled = true
        input:reset()
        self.stats:update_pos()
        self.callbacks.onStart(self)
        while self.enabled do
            local timer = os.startTimer(1 / self.options.EPS_target)
            local raw_event
            if self.options.raw_mode then
                raw_event = {os.pullEventRaw()}
            else
                raw_event = {os.pullEvent()}
            end
            local formatted_event = event_utils.format_event_table(raw_event)

            input:manage_event(formatted_event)
            self:event_elements(formatted_event)

            self.stats.Events = self.stats.Events + 1

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

-- Metatable that handles table calling
local simple_new = {
    __call = function (self, ...)
        return self.new(...)
    end
}
simple_new.__index = simple_new

-- Metatable that handles set_callback for objects
local objects_methods = {
    __call = function (self, ...)
        return self.new(...)
    end,
    set_callback = function (self, event, callback)
        if event == const.ONSTART then
            self.callbacks.onStart = callback
        elseif event == const.ONSTOP then
            self.callbacks.onStop = callback
        elseif event == const.ONDRAW then
            self.callbacks.onDraw = callback
        elseif event == const.ONPRESS then
            self.callbacks.onPress = callback
        elseif event == const.ONFAILEDPRESS then
            self.callbacks.onFailedPress = callback
        elseif event == const.ONTIMEOUT then
            self.callbacks.onTimeout = callback
        elseif event == const.ONCLOCK then
            self.callbacks.onClock = callback
        elseif event == const.ONEVENT then
            self.callbacks.onEvent = callback
        elseif event == const.ONFOCUS then
            self.callbacks.onFocus = callback
        elseif event == const.ONKEY then
            self.callbacks.onKey = callback
        elseif event == const.ONCHAR then
            self.callbacks.onChar = callback
        elseif event == const.ONMOUSESCROLL then
            self.callbacks.onMouseScroll = callback
        elseif event == const.ONCURSORCHANGE then
            self.callbacks.onCursorChange = callback
        elseif event == const.ONWRITE then
            self.callbacks.onWrite = callback
        elseif event == const.ONCONNECT then
            self.callbacks.onConnect = callback
        elseif event == const.ONDISCONNECT then
            self.callbacks.onDisconnect = callback
        elseif event == const.ONSEND then
            self.callbacks.onSend = callback
        elseif event == const.ONRECEIVE then
            self.callbacks.onReceive = callback
        elseif event == const.ONDRAG then
            self.callbacks.onDrag = callback
        elseif event == const.ONRESIZE then
            self.callbacks.onResize = callback
        elseif event == const.ONPASTE then
            self.callbacks.onPaste = callback
        elseif event == const.ONHOVER then
            self.callbacks.onHover = callback
        end
    end
}
objects_methods.__index = objects_methods

-- Setting simple_new as a metatable to the tables that support it
setmetatable(math_utils.Vector2, simple_new)
setmetatable(math_utils.Vector3, simple_new)

-- Setting objects_methods as a metatable to the tables that support it
setmetatable(WSS, objects_methods)
setmetatable(FT, objects_methods)
for key, element in next, gui_elements do
    setmetatable(element, objects_methods)
end
setmetatable(Loop, objects_methods)

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
    FT = FT,
    file_transfer = FT,
    gui_elements = gui_elements,
    Loop = Loop
}

-- MAKE CONSTANTS BE GLOBAL VARIABLES OF THE LIBRARY
for key, value in next, const do
    lib[key] = value
end

return lib
