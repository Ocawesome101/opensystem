-- login

-- step 1: animate this $#@%

gpu.setBackground(0x000040)
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
  self.un = "" -- 1
  self.pw = "" -- 2
  self.focused = 0
end

function app:key(c)
  local k = self.focused == 1 and "un" or self.focused == 2 and "pw"
  if not k then return end
  if c == 8 then
    self[k] = self[k]:sub(1, -2)
  elseif c > 31 and c < 127 then
    self[k] = self[k] .. string.char(c)
  end
end

function app:click(x, y)
  -- gpu.set(1, 1, string.format("%f %f", x, y))
  -- computer.pullSignal(1)
  if x >= 2 and x <= self.w - 4 then
    if y == 4 then
      self.focused = 1
    elseif y == 7 then
      self.focused = 2
    else
      self.focused = 0
    end
  else
    self.focused = 0
  end
  if x >= 14 and x <= 18 and y == 9 then
    -- TODO: proper login scheme
    self.closeme = true
    local mon = dofile("/apps/monitor.lua")
    local lcr = dofile("/apps/launcher.lua")
    ui.add(mon)
    ui.add(lcr)
  end
end

function app:refresh()
  local x, y = self.x, self.y
  if ui.buffered then
    x, y = 1, 1
  end
  gpu.setBackground(0x444444)
  gpu.setForeground(0x888888)
  gpu.fill(x, y, self.w, self.h, " ")
  gpu.set(x + 1, y, "Login Window")
  gpu.setBackground(0x888888)
  gpu.setForeground(0x000000)
  gpu.fill(x+2, y+1, self.w-4, self.h-2, " ")
  gpu.set(x + 12, y + 2, "Username")
  gpu.set(x + 12, y + 5, "Password")
  gpu.setForeground(0x888888)
  gpu.setBackground(0x000000)
  gpu.fill(x + 4, y + 3, self.w - 8, 1, " ")  
  gpu.fill(x + 4, y + 6, self.w - 8, 1, " ")
  gpu.set(x + 4, y + 3, (self.un:sub(0 - self.w + 9))..(
    self.focused == 1 and "_" or " "))
  gpu.set(x + 4, y + 6, ("*"):rep(#(self.pw:sub(0 - self.w + 9)))..(
    self.focused == 2 and "_" or " "))
  gpu.set(x + 13, y + 8, "Log In")
end

function app:close()
  syserror("attempt to close login")
end

ui.add(app)
computer.pushSignal("init")
