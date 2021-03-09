-- ui lib

_G.ui = {}
component.invoke(gpu.getScreen(), "setPrecise", false)

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
  local s = table.pack(computer.pullSignal(1))
  if s.n == 0 then goto draw end
  if s[1] == "touch" then
    local i = search(s[3], s[4])
    if i then
      local w = table.remove(windows, i)
      table.insert(windows, 1, w)
      dx, dy = s[3] - w.x, s[4] - w.y
      windows[1].drag = true
    end
  elseif s[1] == "drag" and windows[1].drag then
    windows[1].x, windows[1].y = s[3]-dx, s[4]-dy
    windows[1].drag = 1
  elseif s[1] == "drop" and search(s[3],s[4])==1 then
    if s[5] == 1 then
      if windows[1].close then windows[1]:close() end
      table.remove(windows, 1)
    elseif windows[1].drag ~= 1 then
      windows[1]:click(s[3]-windows[1].x+1, s[4]-windows[1].y+1)
    end
    if windows[1] then windows[1].drag = false end
  elseif s[1] == "key_up" then
    windows[1]:key(s[3], s[4])
  end
  gpu.setBackground(0x000040)
  gpu.setForeground(0x8888FF)
  gpu.fill(1, 1, 160, 50, " ")
  --gpu.set(1, 1, string.format("%s %s %d %d", s[1], s[2], math.floor(s[3] or 0),
  --  math.floor( s[4] or 0)))
  ::draw::
  for i=#windows, 1, -1 do
    if windows[i].closeme then
      table.remove(windows, i)
    else
      if windows[i].drag == 1 then
        gpu.setBackground(0x444444)
        gpu.fill(windows[i].x, windows[i].y, windows[i].w, 1, " ")
        gpu.fill(windows[i].x, windows[i].y + windows[i].h - 1, windows[i].w, 1, " ")
        gpu.fill(windows[i].x, windows[i].y, 2, windows[i].h - 1, " ")
        gpu.fill(windows[i].x + windows[i].w - 2, windows[i].y, 2, windows[i].h - 1, " ")
      else
        windows[i]:refresh(gpu)
      end
    end
  end
end
