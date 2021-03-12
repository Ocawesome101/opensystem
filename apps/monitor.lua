-- example app

local app = {}

function app:init()
  self.x = 1
  self.y = 1
  self.w = 20
  self.h = 10
  self.active = true
  self.buttons = buttongroup()
  self.textbox = textboxgroup()
  self.buttons:add({
    x = 3, y = 4, text = "Shut Down",
    click = function()computer.shutdown()end
  })
  self.buttons:add({
    x = 3, y = 5, text = "Restart",
    click = function()computer.shutdown(true)end
  })
  self.textbox:add({
    x = 3, y = 7, w = 16, fg = 0x888888,
    bg = 0x000000, submit = function(text)
      local app = dofile(text)
      ui.add(app)
      return true
    end
  })
end

local last = computer.uptime()
local free = computer.freeMemory() // 1024
local vfree = 0
local gtm = 0
function app:refresh()
  gpu.setForeground(0x000000)
  gpu.set(self.x + 2, self.y + 1, string.format("Total RAM: %sk", computer.totalMemory() // 1024))
  if computer.uptime() - last >= 1 then
    free = computer.freeMemory() // 1024
    last = computer.uptime()
    if gpu.freeMemory then
      gtm = gpu.totalMemory() // 1024
      vfree = gpu.freeMemory() // 1024
    end
  end
  gpu.set(self.x + 2, self.y + 2, string.format("Free RAM: %sk", free))
  gpu.set(self.x + 2, self.y + 5, "Run File")
  if gpu.freeMemory then
    gpu.set(self.x + 2, self.y + 7, string.format("Total VRAM: %sk", gtm))
    gpu.set(self.x + 2, self.y + 8, string.format("Free VRAM: %sk", vfree))
  end
  self.buttons:draw(self)
  self.textbox:draw(self)
end

function app:click(x, y)
  self.buttons:click(x, y)
  self.textbox:click(x, y)
end

function app:key(k)
  self.textbox:key(k)
end

function app:close()
end

return window(app, "Monitor")
