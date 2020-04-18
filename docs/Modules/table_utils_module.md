
# table_utils

Contains all **function that are helpful when dealing with tables**.

## has_value

*boolean*, *string/number/nil* : **has_value**( *table* : **tbl**, *any* : **value** )

**Returns a boolean and a string/number/nil**, the **first return value** is **whether or not `value` was found as a value in `tbl`**, the **second one** is the **key at which `value` was found in `tbl`** if **not found it's nil**.

**tbl** is the table **where `value` should be searched in**.

**value** is the **value to be found in `tbl`**.

```lua
-- Creating a table
local tbl = {
    1, 6, 3,
    ["foo bar"] = 23
}

-- Searching the number 23 in tbl
local has, key = table_utils.has_value(tbl, 23)

-- Printing if value was found, value's key and getting the value on the found key
print(has, key, has and tbl[key] or "NOVALUE")
```

## has_key

*boolean*, *any* : **has_key**( *table* : **tbl**, *string/number* : **key** )

**Returns a boolean and any**, the **first return value** is **whether or not `key` was found in `tbl`**, the **second one** is the **value of `tbl` at `key`** if **not found it's nil**.

**tbl** is the **table where `key` should be in**.

**key** is the **key to search for in `tbl`**.

```lua
-- Creating a table
local tbl = {
    1, 6, 3,
    ["foo bar"] = 23
}

-- Searching the key "foo bar" in tbl
local has, value = table_utils.has_key(tbl, "foo bar")

-- Printing if key was found, value at key and getting the value at key found
print(has, value, has and tbl["foo bar"] or "NOKEY")
```

## serialise

*string* : **serialise**( *table* : **tbl**, *number* : **depth**, *boolean* : **pretty**, *boolean* : **recursion**, *boolean* : **serialise_metatables**, *boolean* : **serialise_index**, *string* : **indent**, *string* : **new_line**, *string* : **space** )

**Returns a string which is `tbl` serialised**, if **functions are found** they're **serialised as `tostring(func)`**.

*tbl* is the **table to be serialised**.

**depth** is the **depth at which serialisation will be done**, if **set to -1 it will be ignored** (e.g. `{1, {2}}` to be fully serialised depth should be set to 2 or -1).

**pretty** is **whether or not the serialised table should be prettified**.

**recursion** is how recursion should be handled, if **set to false** if a **table that was already found was found again then it will be a string that's the path to the first table found** (root being the table serialised) **else it will also be serialised** (should be set to false if depth was set to -1).

**serialise_metatables** is **whether or not metatables should also be serialised**.

**serialise_index** is **whether or not the key __index should be serialised if found**.

**indent** is the **string that is going to be used to indent the serialised table** if `pretty` was set to true.

**new_line** is the **string to be used at the end of a line** (e.g. `"\n"`) if `pretty` was set to true.

**space** is the **string to be used as a space** if `pretty` was set to true.

```lua
-- Creating a table
local tbl = {
    1, 6, 3,
    ["foo bar"] = 23
}

-- Serialising tbl
local s_tbl = table_utils.serialise(tbl, -1, true)

-- Printing serialised tbl
print(s_tbl)
```

## unserialise

**COPY OF [`textutils.unserialise`](https://computercraft.info/wiki/Textutils.unserialize)**.

## better_unpack

*...* :  **better_unpack**( *table* : **tbl**, *number* : **i**, *number* : **max_i** )

**Returns all the values in `tbl` from `i` to `max_i`**.

**tbl** is the **table to be unpacked**.

**i** is the **starting index** (1 by default).

**max_i** is the **last index** (`#tbl` by default).

```lua
-- Creating a table
local tbl = {
    1, 6, 3,
    ["foo bar"] = 23
}

-- Printing unpacked tbl starting from index 2
print(
    table_utils.better_unpack(tbl, 2)
)
```
