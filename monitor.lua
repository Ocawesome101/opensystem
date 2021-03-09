-- example app

local app = {}

function app:init()
  self.x = 1
  self.y = 1
  self.w = 20
  self.h = 10
end

function app:refresh()
  gpu.setForeground(0x000000)
  gpu.set(self.x + 2, self.y + 1, string.format("Free: %sk", computer.freeMemory() // 1024))
  gpu.set(self.x + 2, self.y + 3, "Shut Down")
  gpu.set(self.x + 3, self.y + 4, "Restart")
end

function app:click(x, y)
  if x >= 3 and x <= 11 and y == 4 then
    computer.shutdown()
  elseif x >= 4 and x <= 10 and y == 5 then
    computer.shutdown(true)
  end
end

function app:key()
end

function app:close()
end

return window(app, "Monitor")
