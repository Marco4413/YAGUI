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
    ver = "0.1",
    author = "hds536jhmk",
    website = "https://github.com/hds536jhmk/YAGUI"
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
        if not sep then
            sep = "%s"
        end
        local tbl = {}
        for current_string in str:gmatch("([^"..sep.."]+)") do
            table.insert(tbl, current_string)
        end
        return tbl
    end,
    -- COMPARES V1 AND V2 AND IF V1 IS NEWER THAN V2 THEN IT RETURNS 1, IF THEY'RE THE SAME IT RETURNS 0 ELSE IT RETURNS -1
    -- v1 = "0.2"; v2 = "0.1" -> returns 1
    -- v1 = "0.1"; v2 = "0.1" -> returns 0
    -- v1 = "0.1"; v2 = "0.2" -> returns -1
    compareVersions = function(v1, v2)
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

-- SCREEN BUFFER TABLE
local screen_buffer = {
    -- DEFAULT SCREEN IS TERMINAL
    screen = term,
    -- BUFFER WILL BE CLEARED AFTER HAVING CALLED THE DRAW FUNCTION
    clear_after_draw = true,
    -- BUFFER STORES ALL PIXELS
    buffer = {
        pixels = {},
        background = colors.black,
        -- CHECKS IF SPECIFIED PIXEL WAS CREATED WITH "setPixel" FUNCTION
        isPixelCustom = function (self, x, y)
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
        getPixel = function (self, x, y)
            x = tostring(x)
            y = tostring(y)
            if self:isPixelCustom(x, y) then return self.pixels[x][y]; end
            return {
                char = " ",
                foreground = self.background,
                background = self.background
            }
        end,
        -- SETS PROPERTIES FOR A PIXEL SO IT ISN'T A "DEFAULT PIXEL" ANYMORE
        setPixel = function (self, x, y, char, foreground, background)
            x = tostring(x)
            y = tostring(y)

            local pixel = self:getPixel(x, y)

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
    -- CLEARS BUFFER'S PIXELS TABLE
    clear = function (self)
        self.buffer:clear()
    end,
    -- DRAWS SCREEN BUFFER
    draw = function (self)
        local screen = self.screen
        local buffer = self.buffer
        
        local old_bg = screen.getBackgroundColor()
        local old_fg = screen.getTextColor()
        local old_x, old_y = screen.getCursorPos()
        
        local width, height = screen.getSize()
        for x=1, width do
            for y=1, height do
                screen.setCursorPos(x, y)
                local pixel = buffer:getPixel(x, y)
                screen.setBackgroundColor(pixel.background)
                screen.setTextColor(pixel.foreground)
                screen.write(pixel.char)
            end
        end
        
        screen.setBackgroundColor(old_bg)
        screen.setTextColor(old_fg)
        screen.setCursorPos(old_x, old_y)

        if self.clear_after_draw then self:clear(); end
    end,
    -- DRAWS A POINT ON THE SCREEN
    point = function (self, x, y, color)
        self.buffer:setPixel(x, y, " ", color, color)
    end,
    -- WRITES A TEXT ON THE SCREEN
    write = function (self, x, y, text, foreground, background)
        for rel_x=0, #text - 1 do
            char = text:sub(rel_x + 1, rel_x + 1)
            self.buffer:setPixel(x + rel_x, y, char, foreground, background)
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
    circle = function (xCenter, yCenter, radius, color) -- SOURCE: http://groups.csail.mit.edu/graphics/classes/6.837/F98/Lecture6/circle.html
    
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

-- LOOP TABLE
local loop = {}

-- RETURNS LIB TO MAKE REQUIRE OR DOFILE WORK
return {
    info = info,
    string_utils = string_utils,
    screen_buffer = screen_buffer,
    loop = loop
}
