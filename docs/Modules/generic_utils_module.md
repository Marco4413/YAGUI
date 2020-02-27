
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
    c:event()
end
```

## get_computer_type

*constant*, *boolean* : **get_computer_type**()

Returns a [**computer type constant**](./constants.md#computer-type) and a boolean that's true if the **computer is advanced** and false if not.
