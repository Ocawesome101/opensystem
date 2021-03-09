-- example app

local app = {}

function app:init()
  self.x = 1
  self.y = 1
  self.w = 20
  self.h = 10
  self.buttons = buttongroup()
  self.buttons:add({
    x = 3, y = 4, text = "Shut Down",
    click = function()computer.shutdown()end
  })
  self.buttons:add({
    x = 3, y = 5, text = "Restart",
    click = function()computer.shutdown(true)end
  })
end

function app:refresh()
  gpu.setForeground(0x000000)
  gpu.set(self.x + 2, self.y + 1, string.format("Total: %sk", computer.totalMemory() // 1024))
  gpu.set(self.x + 2, self.y + 2, string.format("Free: %sk", computer.freeMemory() // 1024))
  self.buttons:draw(self)
end

function app:click(x, y)
  self.buttons:check(x, y)
end

function app:key()
end

function app:close()
end

return window(app, "Monitor")
