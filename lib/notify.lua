-- notify

local app = {}

function app:init()
  local w, h = gpu.getResolution()
  self.x = (w // 2 - #self.text // 2 - 2)
  self.y = (h // 2 - 2)
  self.w = #self.text + 4
  self.h = 4
end

function app:refresh()
  local x, y = self.x, self.y
  if ui.buffered then x = 1 y = 1 end
  if not (ui.buffered and self.refreshed) then
    gpu.setBackground(0x888888)
    gpu.fill(x, y, self.w, self.h, " ")
    gpu.setForeground(0x000000)
    gpu.set(x + 2, y + 1, self.text)
    self.refreshed = true
  end
end

function app:key()
end

function app:click()
end

function app:close()
end

function _G.notify(notif)
  computer.beep(400, 0.2)
  ui.add(setmetatable({text = "/!\\ " .. notif}, {__index = app}))
end
