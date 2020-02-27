
# What are Modules?

Well... Modules are basically **all the tables that make the library** (e.g. `string_utils`, `math_utils`)

## Why Modules/Tables?

I chose to use tables for these reasons:

1. It's **easier to make** [**dofile/require**](../Introduction/index.md#library-syntax) **work on the library's end**.
2. It's **way more intuitive** than having functions directly in the library (e.g. I want to do something with a string, oh wait there's `string_utils`, maybe that can help me).
3. **Better organized**.
4. I don't think there's a fourth point...
5. But there's for sure a fifth point: This **documentation will be much easier to organize**.

## All the modules that are available

There are currently 16 modules available, where 1 is dumped into the library and 1 is a duplicate of another one:

1. [**info**](./info_module.md) : Contains **all informations about the library** (version, copyright, docs, ...).
2. [**const**](./constants.md) : This is the one that's **dumped into the library** and **contains all available constants** that you can use to make future proofing easier.
3. [**generic_utils**](./generic_utils_module.md) : This contains **functions that could be moved into another Module** if another function that's similar to one of them is made, **it has functions that haven't got their own group yet**.
4. **string_utils** : Contains all **functions that are helpful when dealing with strings** (e.g. `split`, `join`).
5. **math_utils** : Contains all **functions that are helpful when dealing with numbers** (e.g. `Vector2`, `map`).
6. **table_utils** : Contains all **function that are helpful when dealing with tables** (e.g. `has_value`, `has_key`).
7. **color_utils** : You **won't probably use this when making you first program**, because this one was made to **convert a color from** [**Colors API**](http://www.computercraft.info/wiki/Colors_(API)) **into a string that can be used with** [**monitor.blit**](http://www.computercraft.info/wiki/Term.blit), so it's just used by the library to draw on the screen faster, **everything that asks you a color wants a color from the** [**Colors API**](http://www.computercraft.info/wiki/Colors_(API)).
8. **event_utils** : Contains all **functions that are helpful when dealing with events**, like **formatting one**... That is **needed for all `event` functions for making a GUI work** (a "raw event" is `local raw_event = {os.pullEvent()}`, and all event functions want a formatted one `local formatted_event = event_utils.format_event_table(raw_event)`).
9. **setting_utils** : Have you ever **needed to make changes in CraftOS's settings "permanent"**? Well this one is what you were looking for **it has `set`, `unset`, `get`**, and **all the ones that change something in the settings will save a file that will automatically be loaded by CraftOS on boot**, so settings changes are permanent as long as the file doesn't get deleted.
10. **monitor_utils** : This **isn't related to `screen_buffer` by any means**, they usually aren't used in combo with that out of the way, this **contains all functions that make managing monitors easier** (e.g. `better_print`, `better_clear`).
11. **screen_buffer** : It's a **screen buffer that lets you draw things on it and draw it to the screen** (or multiple screens).
12. **input** : This module contains **all functions that can help you with keyboard input**. It has a table which contains keycodes that are pressed, **this doesn't work by itself** but it has functions to add, remove and check keys (if you're using a `Loop` it's already managed by it).
13. **WSS** : This module **helps with screen sharing by broadcasting on a rednet protocol a table which contains `screen_buffer.buffer.pixels` and `screen_buffer.buffer.background`** and it also has **functions to connect to a WSS Server and replace the computer's buffer with the one received** (doesn't draw automatically, you would need to do `screen_buffer:draw()` after having received the buffer to draw on screen).
14. wireless_screen_share : Duplicate of WSS.
15. **gui_elements** : Contains **all elements that make a GUI** (e.g. `Button`, `Progressbar`).
16. **Loop** : A **loop that automatically manages specified `gui_elements`** by giving them events and drawing them to the screen, **also manages `screen_buffer`** (it just draws it when it's done drawing the elements, so you can draw things on the screen and see the effects. Note that elements are always on top of what you draw if you draw stuff on `onEvent` and `onClock` `Loop` callbacks) **and `input` modules**.
