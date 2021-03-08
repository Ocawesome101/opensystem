-- example app

local app = {}

function app:init()
  self.x = 1
  self.y = 1
  self.w = 20
  self.h = 10
end

function app:refresh(gpu)
  gpu.setForeground(0x8888FF)
  gpu.setBackground(0x00AAFF)
  gpu.fill(self.x, self.y, self.w, self.h, " ")
  gpu.set(self.x, self.y, "Example App")
end

function app:click(x, y)
end

function app:close()
end

return app
