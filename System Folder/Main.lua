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

while true do computer.pullSignal() end
