-- ui lib

_G.ui = {}
component.invoke(gpu.getScreen(), "setPrecise", false)

local windows = {}

function ui.add(app)
  app:init()
  app.update = true
  if ui.buffered then
    local err
    app.buf, err = gpu.allocateBuffer(app.w, app.h)
    if not app.buf then
      syserror(err)
    end
  end
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

-- return whether w1 overlaps with w2
local function overlaps(w1, w2)
  do return true end
  local blx, bly = w1.x + w1.w, w2.y + w1.h
  return (w1.x >= w2.x and w1.x <= w2.x + w2.w and w1.y >= w2.y
    and w1.y <= w2.y + w2.h) or
         (w2.x >= blx and w2.x + w2.h <= blx and w2.y >= bly
    and w2.y + w2.h <= bly)
end

local dx, dy, to = 0, 0, 1
ui.composited = 0
function ui.tick()
  local s = table.pack(computer.pullSignal(to))
  to = 1
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
    gpu.setBackground(0x000040)
    gpu.fill(windows[1].x, windows[1].y, windows[1].w, windows[1].h, " ")
    windows[1].x, windows[1].y = s[3]-dx, s[4]-dy
    windows[1].drag = 1
  elseif s[1] == "drop" and search(s[3],s[4])==1 then
    if s[5] == 1 then
      if windows[1].close then
        local r = windows[1]:close()
        if r == "__no_keep_me_open" then goto draw end
      end
      windows[1].closeme = true
    elseif windows[1].drag ~= 1 then
      windows[1].update = true
      windows[1]:click(s[3]-windows[1].x+1, s[4]-windows[1].y+1)
    end
    if windows[1] then windows[1].drag = false end
  elseif s[1] == "key_up" then
    windows[1].update = true
    windows[1]:key(s[3], s[4])
  end
  --gpu.set(1, 1, string.format("%s %s %d %d", s[1], s[2], math.floor(s[3] or 0),
  --  math.floor( s[4] or 0)))
  ::draw::
  local comp = 0
  for i=#windows, 1, -1 do
    if windows[i].closeme then
      if ui.buffered then
        gpu.freeBuffer(windows[i].buf)
        gpu.setActiveBuffer(0)
      end
      gpu.setBackground(0x000040)
      gpu.fill(windows[i].x, windows[i].y, windows[i].w, windows[i].h, " ")
      table.remove(windows, i)
      to = 0
    else--if s[1] then
      if ui.buffered then
        gpu.setActiveBuffer(windows[i].buf)
      end
      -- note: while buffered, no windows will refresh during a window drag
      if (not (windows[1].drag and ui.buffered)) and
          (windows[i].active or windows[i].update or not ui.buffered) then
        windows[i].update = false
        windows[i]:refresh(gpu)
        comp = comp + 1
      end
      if ui.buffered then
        gpu.bitblt(0, windows[i].x, windows[i].y)
        gpu.setActiveBuffer(0)
      end
    --[[elseif windows[i].active then
      for n=1, i, 1 do
        if overlaps(windows[n], windows[i]) then
          if ui.buffered then
            gpu.setActiveBuffer(windows[n].buf)
          end
          windows[n]:refresh(gpu)
          if ui.buffered then
            gpu.bitblt(0, windows[n].x, windows[n].y)
            gpu.setActiveBuffer(0)
          end
        end
      end
      if ui.buffered then
        gpu.setActiveBuffer(windows[i].buf)
      end
      windows[i]:refresh(gpu)
      if ui.buffered then
        gpu.bitblt(0, windows[i].x, windows[i].y)
        gpu.setActiveBuffer(0)
      end]]
    end
  end
  ui.composited = comp
end

if gpu.allocateBuffer then
  ui.buffered = true
end
