-- login

-- step 1: animate this $#@%

for i=1, 10, 1 do
  gpu.fill(1, i*5-4, 160, 5, " ")
  computer.pullSignal(0.0001)
end

-- step 2: functionality

local app = {}

function app:init()
  self.x = 64
  self.y = 12
  self.w = 32
  self.h = 16
end

function app:key()
end

function app:click()
end

function app:refresh()
  gpu.setBackground(0x8888FF)
  gpu.setForeground(0x000040)
  gpu.fill(self.x, self.y, self.w, self.h, " ")
  gpu.set(self.x, self.y, "Credentials:")
end

function app:close()
  syserror("attempt to close login")
end

ui.add(app)
computer.pushSignal("init")
