-- Main OS file

system.notify("system", "Welcome to the Open System.", {})

-- more system.* utilities

-- canvas: drawing surface for applications.  can be hardware accelerated or
-- software managed, flexibly.  Open System being black-and-white simplifies
-- this greatly.
-- note that hardware canvases *may* use more than two colors, and may mix them
-- freely.  in software canvases the app may only use black-on-white.
do
  local _canvas = {}
  
  function _canvas:set(x, y, text, vert)
  end

  function system.canvas(w, h)
  end
end

while true do computer.pullSignal() end
