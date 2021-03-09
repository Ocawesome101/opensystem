// Open System

This is a very simple, vaguely Mac-inspired GUI toolkit plus OS for OpenComputers.  Probably easily portable, though this uses globals because it was easier.

//// Apps

Apps are defined similarly to libraries.  See `monitor.lua` for an example.

Apps are refreshed once per at least once per second.

//// Files

`init.lua` loads everything, in order:

`ui.lua`: the base UI library, very minimal

`buttons.lua`: a basic button system, provides `buttongroup()`

`textbox.lua`: a basic textbox system, provides `textboxgroup()`

`window.lua`: provides, `window(app)`, an `app` wrapper that automatically draws a windowframe and a backdrop

`login.lua`: the login window, which doesn't really do anything.  Does not use `textboxgroup()`, `buttongroup()`, or `window()`, since I wrote it before I implemented them.
