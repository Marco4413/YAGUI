
# math_utils

Contains all **functions that are helpful when dealing with numbers**.

## Vectors

**Vectors are going to be explained in [this document](./Vectors.md)**.

## map

*number* : **map**( *number* : **value**, *number* : **value_start**, *number* : **value_stop**, *number* : **return_start**, *number* : **return_stop**, *boolean* : **constrained**)

**Returns a number from a number that is in the range [`value_start`; `value_stop`] mapped in the range [`return_start`; `return_stop`]** and **constrained** in the **return range if `constrained` is set to true**.

**value** is the **number that is going to be mapped**.

**value_start** is the **lowest number that `value` can be**.

**value_stop** is the **biggest number that `value` can be**.

**return_start** is the **lowest number that the returned number can be**.

**return_start** is the **biggest number that the returned number can be**.

*constrained* **if set to true** the **returned value** is going to be **constrained to its range of numbers**.

```lua
-- Define the range of value
local value_min = 0
local value_max = 10

-- Map value in range without constrain
local mapped_value = math_utils.map(2, value_min, value_max, 0, 100, false)
-- Map value in range with constrain
local mapped_constrained_value = math_utils.map(2, value_min, value_max, 0, 100, true)

-- Map value out of range without constrain
local mapped_outofrange_value = math_utils.map(11, value_min, value_max, 0, 100, false)
-- Map value out of range with constrain
local mapped_constrained_outofrange_value = math_utils.map(11, value_min, value_max, 0, 100, true)

-- Print mapped values
print(
string.format(
[[
Mapped value: %.2f;
Mapped constrained value: %.2f;
Mapped out of range value: %.2f;
Mapped constrained out of range value: %.2f.
]],
mapped_value,
mapped_constrained_value,
mapped_outofrange_value,
mapped_constrained_outofrange_value
)
)
```

## constrain

*number* : **constrain**( *number* : **value**, *number* : **min_value**, *number* : **max_value**)

It **returns a number** that is **`value` constrained in the range [`min_value`; `max_value`]**.

**value** is the **number to be constrained**.

**min_value** is the **lowest number that value can be**.

**max_value** is the **biggest number that value can be**.

```lua
-- Define the range of value
local value_min = 0
local value_max = 10

-- Constrain value in range
local constrained_value = math_utils.constrain(2, 0, 10)
-- Constrain out of range value in range
local constrained_outofrange_value = math_utils.constrain(11, 0, 10)

-- Print constrained values
print(
string.format(
[[
Constrained value: %.2f;
Constrained out of range value: %.2f.
]],
constrained_value,
constrained_outofrange_value
)
)
```

## round

*number* : **round**( *number* : **number** )

**Returns a number** that is **`number rounded` to the closest unit**.

```lua
print(
    math_utils.round(0.1),
    math_utils.round(0.6)
)
```

## round_numbers

*numbers* : **round_numbers**( *numbers* : **...** )

**Returns all specified numbers rounded to their closest unit**.

```lua
print(
    math_utils.round_numbers(0.1, 0.6)
)
```

## floor_numbers

*numbers* : **floor_numbers**( *numbers* : **...** )

**Returns all specified numbers floored**.

```lua
print(
    math_utils.floor_numbers(0.1, 0.6)
)
```

## ceil_numbers

*numbers* : **ceil_numbers**( *numbers* : **...** )

**Returns all specified numbers ceiled**.

```lua
print(
    math_utils.ceil_numbers(0.1, 0.6)
)
```
