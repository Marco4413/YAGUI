
# generic_utils

Contains **functions that could be moved into another Module** if another function that's similar to one of them is made, **it has functions that haven't got their own group yet**.

## set_callback

*nil* : **set_callback**( *table* : **gui_element**, *constant* : **event**, *function* : **callback** )

It **returns nil**.

**gui_element** is the **object that you want to add a callback to**.

**event** is the [**callback constant**](./constants.md#callbacks) **that determines which callback you're setting**.

**callback** is the **function that is called when the object event was triggered**.

```lua
-- Create a clock that "ticks" every second
local c = gui_elements.Clock.new(1)

-- Add callback for when the clock "ticks"
generic_utils.set_callback(
    c,              -- object
    ONCLOCK,        -- event
    function (self) -- callback
        -- DO STUFF WHEN THE CLOCK TRIGGERS
    end
)

-- Loop that updates the clock
while true do
    sleep(0.1) -- Using sleep to not get "too long without yielding" error
    c:event()
end
```

## get_computer_type

*constant*, *boolean* : **get_computer_type**()

Returns a [**computer type constant**](./constants.md#computer-type) and a boolean that's true if the **computer is advanced** and false if not.

```lua
-- Get computer type and if it's advanced
local computer_type, advanced = generic_utils.get_computer_type()

-- Check if computer_type is a COMPUTER
if computer_type ~= COMPUTER then
    printError("You must be using a computer to start this script.")
    return
end
-- Check if computer is advanced
if not advanced then
    printError("This script only works on advanced computers.")
    return
end

-- DO STUFF
```

## expect

*boolean* : **expect**( *string* : **context**, *any* : **...** )

Returns **true if it doesn't error**.

It **checks if even arguments in `...` are of type specified by the previous string in `...`**, if they aren't it errors.

**context** is a **string that can be specified by the code that's useful to get more information about the error** (Usually it's the function's name) **if `nil` it's `"unknown"` by default**.

```lua
-- Get user input
print("Insert a number:")
local var1 = read()
print("Insert a string:")
local var2 = read()

-- Convert user input into a number if it is a valid number
var1 = tonumber(var1) or var1
var2 = tonumber(var2) or var2

-- Check that the first user input is a number and the second one is a string
-- Note: if you want an argument that can be of multiple types you can use a string that
--  has multiple types separated by "/", "." or "," (e.g. "number/string" or "number,string")
--  and be aware that types mustn't have spaces in between (They don't get trimmed) else
--  it won't work properly
generic_utils.expect(
    "User Input",
    "number", var1,
    "string", var2
)
```
