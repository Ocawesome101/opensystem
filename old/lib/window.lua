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
    local x, y = self.x, self.y
    if ui.buffered then
      x, y = 1, 1
    end
    gpu.setBackground(0x444444)
    gpu.setForeground(0x888888)
    gpu.fill(x, y, self.w, self.h, " ")
    if name then gpu.set(x, y, name) end
    gpu.setBackground(0x888888)
    gpu.setForeground(0x000000)
    gpu.fill(x + 2, y + 1, self.w - 4, self.h - 2, " ")
    app.x = x + 2
    app.y = y + 1
    app:refresh(gpu)
  end
  
  function w:click(x, y)
    app:click(x - 1, y - 1)
  end
  
  return setmetatable(w, {__index = app})
end

_G.window = wrap
