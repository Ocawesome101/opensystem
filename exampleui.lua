-- example app

local app = {}

function app:init()
  self.x = 1
  self.y = 1
  self.w = 20
  self.h = 10
end

function app:refresh(gpu)
  gpu.setBackground(0x444444)
  gpu.setForeground(0x888888)
  gpu.fill(self.x, self.y, self.w, self.h, " ")
  gpu.set(self.x, self.y, "Example App")
  gpu.setBackground(0x888888)
  gpu.fill(self.x + 2, self.y + 1, self.w - 4, self.h - 2, " ")
end

function app:click(x, y)
end

function app:close()
end

return app
