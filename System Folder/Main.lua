-- Main OS file

local gpu = ...
system.notify("system", "Welcome to the Open System.", {})

-- more system.* utilities

-- canvas: drawing surface for applications.  can be hardware accelerated or
-- software managed, flexibly.  Open System being mostly monochrome simplifies
-- this greatly.
-- note that hardware canvases *may* use more than two colors, and may mix them
-- freely.  in software canvases the app may only use black-on-white for
-- performance reasons.  software canvases are also much more memory-hungry.
--
-- software canvases are somewhat of a second-class citizen.
do
  local _canvas = {}
  
  function _canvas:set(x, y, text, vert)
    if self.hw then
      return gpu.set(x, y, text, vert)
    else
      if vert then
        for i=y, #text, 1 do
          self.buffer[i] = self.buffer[i] or string.rep(" ", self.w)
          self.buffer[i] = self.buffer[i]:sub(1, x - 1) .. text:sub(i,i)
            .. self.buffer[i]:sub(x + 1)
        end
      else
        self.buffer[y] = self.buffer[y] or string.rep(" ", self.w)
        if #text + x > self.w then text = text:sub(1, self.w - x) end
        self.buffer[y] = self.buffer[y]:sub(1, x - 1) .. text
          .. self.buffer[y]:sub(x + #text)
      end
    end
  end
  
  function _canvas:get(x, y)
    if self.hw then
      return gpu.get(x, y)
    else
      self.buffer[y] = self.buffer[y] or string.rep(" ", self.w)
      return self.buffer[y]:sub(x, x), 0xFFFFFF, 0
    end
  end
  
  function _canvas:fill(x, y, w, h, c)
    if self.hw then
      return gpu.fill(x, y, w, h, c)
    else
      error("software canvas fill unsupported")
    end
  end
  system._canvas = _canvas

  function system.canvas(w, h)
    if gpu.allocateBuffer then
      local n = gpu.allocateBuffer(w, h)
      if not n then
        -- this is a NON-FATAL error.
        system.notify("alert", "Failed to create hardware canvas: Not enough memory or other error.")
      else
        return setmetatable({
          hw = true,
          w = w,
          h = h,
          buffer = n,
        }, { __index = _canvas })
      end
    end
    return setmetatable({
      hw = false,
      w = w,
      h = h,
      buffer = {}
    }, { __index = _canvas })
  end
end

-- Menu functions
-- this is used to create a drop-down menu
-- as a special case, "[spacer]" will insert a spacer that is not clickable.
-- note that these menus as they stand will lock up the entire system while
-- in use.  this is roughly how the Classic Mac OS functioned as well, so I'm
-- not particularly worried about it as long as the menu closes when the mouse
-- is released.
do
  local function dmenu(x, y, it, mw, mh, p)
    gpu.setForeground(0)
    gpu.setBackground(0xFFFFFF)
    local is_spacer = (it[p] == "[spacer]")
    --if is_spacer then error("is spacer") end
    for i=1, math.min(#it, mh), 1 do
      local draw = it[i]
      if it[i] == "[spacer]" then
        draw = string.rep("┈", mw)
      end
      if p == i and not is_spacer then
        gpu.setForeground(0xFFFFFF)
        gpu.setBackground(0)
      elseif i == p + 1 then
        gpu.setForeground(0)
        gpu.setBackground(0xFFFFFF)
      end
      local text = string.format("%s%s", draw, string.rep(" ", mw - #draw))
      gpu.set(x, y + i - 1, string.format("%s%s%s",
        p == i and " " or "⡇", text, p == i and " " or "⢸"))
    end
    gpu.setForeground(0)
    gpu.setBackground(0xFFFFFF)
    gpu.set(x, y + math.min(#it, mh), string.format("⣇%s⣸",
      string.rep("⣀", mw)))
  end
  
  function system.menu(x, y, items, maxWidth, maxHeight)
    checkArg(1, x, "number")
    checkArg(2, y, "number")
    checkArg(3, items, "table")
    checkArg(4, maxWidth, "number", "nil")
    checkArg(5, maxHeight, "number", "nil")
    local maxWidth, maxHeight
    if not maxWidth then
      maxWidth = 0
      for i=1, #items, 1 do
        if #items[i] > maxWidth then
          maxWidth = #items[i]
        end
      end
    end
    maxHeight = maxHeight or #items
    local press = 0
    dmenu(x, y, items, maxWidth, maxHeight, 0)
    while true do
      local evt, _, mx, my = computer.pullSignal()
      if evt == "drag" or evt == "drop" then
        if x >= x - 1 and x <= x + maxWidth + 1 then
          press = math.max(y, math.min(y + maxHeight, my)) - y + 1
        end
      end
      if evt == "drop" then
        dmenu(x, y, items, maxWidth, maxHeight, press)
        computer.pullSignal(0.1)
        dmenu(x, y, items, maxWidth, maxHeight, 0)
        computer.pullSignal(0.1)
        dmenu(x, y, items, maxWidth, maxHeight, press)
        computer.pullSignal(0.1)
        dmenu(x, y, items, maxWidth, maxHeight, 0)
        computer.pullSignal(0.1)
        return items[press] ~= "[spacer]" and items[press] or nil
      end
      dmenu(x, y, items, maxWidth, maxHeight, press)
    end
  end
end

-- Load the rest of the system
do
  local function dofile(f)
    local ok, err = system.loadfile(f)
    if not ok then
      system.notify("alert", err, {})
      while true do computer.pullSignal() end
    end
    local ok = xpcall(ok, function(...)system.notify("alert",...,{})end)
    if not ok then
      while true do computer.pullSignal() end
    end
    return true
  end
  
  dofile("/System Folder/Libraries/Interface.lua")
  dofile("/System Folder/Finder.lua")
end

while true do computer.pullSignal() end
