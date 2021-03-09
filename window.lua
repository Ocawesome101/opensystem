-- basic window "app"

local function wrap(app, name)
  local w = {}
  
  function w:init()
    app:init()
    self.x = app.x
    self.y = app.y
    self.w = app.w + 4
    self.h = app.h + 2
  end
  
  function w:refresh(gpu)
    gpu.setBackground(0x444444)
    gpu.setForeground(0x888888)
    gpu.fill(self.x, self.y, self.w, self.h, " ")
    if name then gpu.set(self.x, self.y, name) end
    gpu.setBackground(0x888888)
    gpu.fill(self.x + 2, self.y + 1, self.w - 4, self.h - 2, " ")
    app.x = self.x + 2
    app.y = self.y + 1
    app:refresh(gpu)
  end
  
  function w:click(x, y)
    app:click(x - 1, y - 1)
  end
  
  return setmetatable(w, {__index = app})
end

_G.window = wrap
