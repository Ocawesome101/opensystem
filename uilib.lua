-- ui lib

_G.ui = {}

local windows = {}

function ui.add(app)
  app:init()
  table.insert(windows, 1, app)
end

local function search(x, y)
  for i=1, #windows, 1 do
    local w = windows[i]
    if x >= w.x and x <= w.x + w.w and y >= w.y and y <= w.y + w.h then
      return i, windows[i]
    end
  end
end

local dx, dy = 0, 0
function ui.tick()
  local s = table.pack(computer.pullSignal())
  if s[1] == "touch" then
    local i = search(s[3], s[4])
    if i then
      local w = table.remove(windows, i)
      table.insert(windows, 1, w)
      dx, dy = s[3] - w.x, s[4] - w.y
    end
  elseif s[1] == "drag" then
    windows[1].x, windows[1].y = s[3]-dx, s[4]-dy
  elseif s[1] == "drop" and search(s[3],s[4]) == 1 then
    if s[5] == 1 then
      windows[1]:close()
      table.remove(windows, 1)
    else
      windows[1]:click(s[3]-windows[1].x, s[4]-windows[1].y)
    end
  elseif s[1] == "key_up" then
    windows[1]:key(s[3], s[4])
  end
  gpu.setBackground(0x000040)
  gpu.setForeground(0x8888FF)
  gpu.fill(1, 1, 160, 50, " ")
  for i=#windows, 1, -1 do
    windows[i]:refresh(gpu)
  end
end
