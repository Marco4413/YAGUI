
# Vectors

Note that because they're objects **all their methods except for `new` need to be called with ":" between the object and the method** (e.g. `v:length()`).

## Vector2

Vector2 is a **2D vector object**.

### Vector2 Constants

It's got **six constants that are pre-defined vectors**:

| key   | x  | y  |
|-------|----|----|
| ONE   |  1 |  1 |
| UP    |  0 | -1 |
| DOWN  |  0 |  1 |
| LEFT  | -1 |  0 |
| RIGHT |  1 |  0 |
| ZERO  |  0 |  0 |

### Vector2 Methods

*Vector2* : **new**( *number* : **x**, *number* : **y** )

**Returns a new Vector2 that points to (`x`; `y`)**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing the vector (Note: tostring(v1) will return v1:string(0),
--  if you want more precision you should use v1:string(decimal_digits))
print(v1)
```

*Vector2* : **duplicate**()

**Returns a new Vector2 that has the same x, y as the original Vector2**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a reference to v1
local v2 = v1
-- Making a duplicate of v1
local v3 = v1:duplicate()

-- Changing the x value on
--  The reference to v1
v2.x = 5
--  The duplicate of v1
v3.x = 2

-- Printing all 3 vectors to show the difference between
--  A referenced vector and a duplicate one
print(v1)
print(v2)
print(v3)
```

*number* : **length_sq**()

**Returns the squared length of the vector** (It's much faster than doing length if you need to compare lengths).

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing its squared length
print(v1:length_sq())
```

*number* : **length**()

**Returns the length of the vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing its length
print(v1:length())
```

*Vector2* : **unit**()

**Returns the [unit vector](https://en.wikipedia.org/wiki/Unit_vector) of the vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Getting the unit vector of v1
local v1_unit = v1:unit()

-- Printing it with string method to get more decimal digits
--  (If nothing is specified it will have 6 decimal digits the default for string.format("%f"))
print(v1_unit:string())
```

*number* : **dot**( *Vector2* : **other** )

**Returns the [dot product](https://en.wikipedia.org/wiki/Dot_product) between the vector and the specified vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(3, 2)

-- Printing the dot product between the two vectors
print(v1:dot(v2))
```

*number* : **cross**( *Vector2* : **other** )

**Returns the [cross product](https://en.wikipedia.org/wiki/Cross_product) between the vector and the specified vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(3, 2)

-- Printing the cross product between the two vectors
print(v1:cross(v2))
```

*Vector2* : **rotate**( *number* : **angle** )

**Returns a Vector2 that is the vector rotated by `angle`** (in radians).

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing the vector rotated by 180°
print(v1:rotate(math.pi))
```

*string* : **string**( *number* : **precision** )

**Returns a string that is equal to `("(%f; %f)"):format(v.x, v.y)`** if **`precision` is specified** then the string **will show vector's x and y with `precision` decimal digits**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing the vector with 10 decimal digits
print(v1:string(10))
```

### Vector2 Metamethods

**If you don't know what metamethods are you can go to [this link to learn more](http://lua-users.org/wiki/MetatableEvents)**.

#### tostring(Vector2)

Vector2 **implements the `__tostring`** metamethod, which means that doing `tostring(Vector2)` will `return Vector2:string(0)`.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Converting v1 into string
local v1_string = tostring(v1)

-- Printing v1's string
print(v1_string)
```

#### Sum of Vector2

Vector2 **implements the `__add` metamethod**, which means that `Vector2 + Vector2` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(3, 2)

-- Printing the sum between the two vectors
print(v1 + v2)
```

#### Subtraction of Vector2

Vector2 **implements the `__sub` metamethod**, which means that `Vector2 - Vector2` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(3, 2)

-- Printing the subtraction between the two vectors
print(v1 - v2)
```

#### Multiplying a Vector2 by a number

Vector2 **implements the `__mul` metamethod**, which means that `Vector2 * Number` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing the multiplication between a Vector2 and a number
print(v1 * 10)
```

#### Dividing a Vector2 by a number

Vector2 **implements the `__div` metamethod**, which means that `Vector2 / Number` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)

-- Printing the division between a Vector2 and a number
print(v1 / 2)
```

#### Checking if two Vector2 have the same length

**Probably this will be changed to check if the two vectors are the same vector, it's more useful than checking their length**.

Vector2 **implements the `__eq` metamethod**, which means that `Vector2 == Vector2` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(2, 10)

-- Printing if the lengths of the two vectors are equal
print(v1 == v2)
```

#### Checking if a Vector2's length is greater than another Vector2's length

Vector2 **implements the `__lt` metamethod**, which means that `Vector2 < Vector2` and `Vector2 > Vector2` work.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(3, 2)

-- Printing if the length of the first vector is greater than the second one
print(v1 > v2)
-- Printing if the length of the first vector is lower than the second one
print(v1 < v2)
```

#### Checking if a Vector2's length is greater or equal to another Vector2's length

Vector2 **implements the `__le` metamethod**, which means that `Vector2 <= Vector2` and `Vector2 >= Vector2` work.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector2.new(10, 2)
-- Creating a second Vector
local v2 = math_utils.Vector2.new(3, 2)
-- Creating a third vector
local v3 = math_utils.Vector2.new(2, 10)

-- Printing if the length of the first vector is greater or equal to the second one
print(v1 >= v2)
-- Printing if the length of the first vector is lower or equal to the third one
print(v1 <= v3)
```

## Vector3

Vector3 is a **3D vector object**.

### Vector3 Constants

It's got **eight constants that are pre-defined vectors**:

| key     | x  | y  | z  |
|---------|----|----|----|
| ONE     |  1 |  1 |  1 |
| UP      |  0 |  1 |  0 |
| DOWN    |  0 | -1 |  0 |
| LEFT    | -1 |  0 |  0 |
| RIGHT   |  1 |  0 |  0 |
| FORWARD |  0 |  0 |  1 |
| BACK    |  0 |  0 | -1 |
| ZERO    |  0 |  0 |  0 |

### Vector3 Methods

*Vector3* : **new**( *number* : **x**, *number* : **y**, *number* : **z** )

**Returns a new Vector3 that points to (`x`; `y`; `z`)**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing the vector (Note: tostring(v1) will return v1:string(0),
--  if you want more precision you should use v1:string(decimal_digits))
print(v1)
```

*Vector3* : **duplicate**()

**Returns a new Vector3 that has the same x, y, z as the original Vector3**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a reference to v1
local v2 = v1
-- Making a duplicate of v1
local v3 = v1:duplicate()

-- Changing the x value on
--  The reference to v1
v2.x = 5
--  The duplicate of v1
v3.x = 2

-- Printing all 3 vectors to show the difference between
--  A referenced vector and a duplicate one
print(v1)
print(v2)
print(v3)
```

*number* : **length_sq**()

**Returns the squared length of the vector** (It's much faster than doing length if you need to compare lengths).

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing its squared length
print(v1:length_sq())
```

*number* : **length**()

**Returns the length of the vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing its length
print(v1:length())
```

*Vector3* : **unit**()

**Returns the [unit vector](https://en.wikipedia.org/wiki/Unit_vector) of the vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Getting the unit vector of v1
local v1_unit = v1:unit()

-- Printing it with string method to get more decimal digits
--  (If nothing is specified it will have 6 decimal digits the default for string.format("%f"))
print(v1_unit:string())
```

*number* : **dot**( *Vector3* : **other** )

**Returns the [dot product](https://en.wikipedia.org/wiki/Dot_product) between the vector and the specified vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(3, 2, 10)

-- Printing the dot product between the two vectors
print(v1:dot(v2))
```

*Vector3* : **cross**( *Vector3* : **other** )

**Returns the [cross product](https://en.wikipedia.org/wiki/Cross_product) between the vector and the specified vector**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(3, 2, 10)

-- Printing the cross product between the two vectors
print(v1:cross(v2))
```

*Vector3* : **rotate**( *Vector3* : **axis**, *number* : **angle** )

**Returns a Vector3 that is the vector rotated by `angle`** (in radians) **on the specified `axis`**, you can use [Vector3 constants](#vector3-constants) as axis.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing the vector rotated by 180° on the y axis
print(v1.UP, v1:rotate(math.pi))
```

*string* : **string**( *number* : **precision** )

**Returns a string that is equal to `("(%f; %f; %f)"):format(v.x, v.y, v.z)`** if **`precision` is specified** then the string **will show vector's x, y and z with `precision` decimal digits**.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing the vector with 10 decimal digits
print(v1:string(10))
```

### Vector3 Metamethods

**If you don't know what metamethods are you can go to [this link to learn more](http://lua-users.org/wiki/MetatableEvents)**.

#### tostring(Vector3)

Vector3 **implements the `__tostring` metamethod**, which means that doing `tostring(Vector3)` will `return Vector3:string(0)`.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Converting v1 into string
local v1_string = tostring(v1)

-- Printing v1's string
print(v1_string)
```

#### Sum of Vector3

Vector3 **implements the `__add` metamethod**, which means that `Vector3 + Vector3` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(3, 2, 10)

-- Printing the sum between the two vectors
print(v1 + v2)
```

#### Subtraction of Vector3

Vector3 **implements the `__sub` metamethod**, which means that `Vector3 - Vector3` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(3, 2, 10)

-- Printing the subtraction between the two vectors
print(v1 - v2)
```

#### Multiplying a Vector3 by a number

Vector3 **implements the `__mul` metamethod**, which means that `Vector3 * Number` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing the multiplication between a Vector3 and a number
print(v1 * 10)
```

#### Dividing a Vector3 by a number

Vector3 **implements the `__div` metamethod**, which means that `Vector3 / Number` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)

-- Printing the division between a Vector3 and a number
print(v1 / 2)
```

#### Checking if two Vector3 have the same length

**Probably this will be changed to check if the two vectors are the same vector, it's more useful than checking their length**.

Vector3 **implements the `__eq` metamethod**, which means that `Vector3 == Vector3` works.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(2, 10, 5)

-- Printing if the lengths of the two vectors are equal
print(v1 == v2)
```

#### Checking if a Vector3's length is greater than another Vector3's length

Vector3 **implements the `__lt` metamethod**, which means that `Vector3 < Vector3` and `Vector3 > Vector3` work.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(3, 2, 10)

-- Printing if the length of the first vector is greater than the second one
print(v1 > v2)
-- Printing if the length of the first vector is lower than the second one
print(v1 < v2)
```

#### Checking if a Vector3's length is greater or equal to another Vector3's length

Vector3 **implements the `__le` metamethod**, which means that `Vector3 <= Vector3` and `Vector3 >= Vector3` work.

```lua
-- Creating a new Vector
local v1 = math_utils.Vector3.new(10, 2, 5)
-- Creating a second Vector
local v2 = math_utils.Vector3.new(3, 2, 10)
-- Creating a third vector
local v3 = math_utils.Vector3.new(2, 10, 5)

-- Printing if the length of the first vector is greater or equal to the second one
print(v1 >= v2)
-- Printing if the length of the first vector is lower or equal to the third one
print(v1 <= v3)
```
