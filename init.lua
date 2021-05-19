-- init

local fs = component.proxy(computer.getBootAddress())
local gpu = component.proxy((component.list("gpu", true)()))
gpu.bind((component.list("screen", true)()))

gpu.setDepth(gpu.maxDepth())

_G.fs = fs
_G.gpu = gpu

local logo = {
  "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿  ⣿⣿  ⣿⣿      ⣿⣿  ⣿⣿    ⣿⣿  ⣿⣿",
  "⣿⣿  ⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿  ⣿⣿",
  "⣿⣿  ⣿⣿                        ⣿⣿",
  "⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿  ⣿⣿    ⣿⣿    ⣿⣿            ⣿⣿",
  "⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿    ⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿  ⣿⣿    ⣿⣿    ⣿⣿            ⣿⣿",
  "⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿    ⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿  ⣿⣿    ⣿⣿    ⣿⣿            ⣿⣿",
  "⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿    ⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿  ⣿⣿    ⣿⣿    ⣿⣿            ⣿⣿",
  "⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿    ⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿  ⣿⣿    ⣿⣿    ⣿⣿            ⣿⣿",
  "⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿    ⣿⣿  ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
  "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
}

local loading = {
  "⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣹",
  "⣏⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣹",
  "⣏⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣹",
  "⣏⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿⣉⣉⣉⣿",
}

local function draw_logo(x, y)
  gpu.setBackground(0x002480)
  gpu.setForeground(0x000040)
  for i=1, #logo, 1 do
    gpu.set(x, y + i - 1, logo[i])
  end
  gpu.setBackground(0x3349ff)
  gpu.set(x + 10, y + 1, "      ")
  gpu.set(x + 22, y + 1, "    ")
  gpu.setBackground(0x002480)
  gpu.fill(x + 12, y + 5, 4, 10, " ")
end

local lst = 1
local last = computer.uptime() + 0.1
local function draw_loading()
  if computer.uptime() - last >= 0.1 then
    lst = lst + 1
    last = computer.uptime()
  end
  if lst > 4 then lst = 1 end
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
  gpu.set(64, 32, loading[lst])
end

draw_logo(64, 12)

function syserror(e)
  gpu.setBackground(0x808080)
  gpu.fill(40, 15, 80, 20, " ")
  gpu.setBackground(0xc0c0c0)
  gpu.fill(42, 16, 76, 18, " ")
  gpu.setForeground(0x000000)
  gpu.set(44, 17, "A fatal system error has occurred:")
  local l = 0
  for line in debug.traceback(e, 2):gmatch("[^\n]+") do
    gpu.set(44, 19 + l, (line:gsub("\t", "  ")))
    l = l + 1
    computer.pullSignal(0.1)
  end
  computer.beep(440, 2)
  while true do computer.pullSignal() end
end

function fread(fpath, f)
  if not fs.exists(fpath) then
    return nil, fpath..": no such file or directory"
  end
  local handle, err = fs.open(fpath, "r")
  if not handle then return nil, err end
  local data = ""
  repeat
    if f then f() end
    local chunk = fs.read(handle, math.huge)
    data = data .. (chunk or "")
  until not chunk
  fs.close(handle)
  
  return data
end

local function dfile(filepath, x)
  local data = assert(
    fread(filepath, x and draw_loading or nil))

  -- too much error handling? perhaps.
  return select(2, assert(
    xpcall(
      assert(
        load(
          data, "=" .. filepath, "bt", _G
        )
      ),
      debug.traceback
    )
  ))
end

function dofile(f, x)
  local ok, err = pcall(dfile, f)
  if not ok then syserror(err) end
  return err
end

dofile("/lib/ui.lua", true)
dofile("/lib/buttons.lua", true)
dofile("/lib/textbox.lua", true)
dofile("/lib/label.lua", true)
dofile("/lib/view.lua", true)
dofile("/lib/window.lua", true)
dofile("/lib/notify.lua", true)
--dofile("/apps/login.lua", true)

gpu.setBackground(0x000040)
for i=1, 10, 1 do
  gpu.fill(1, i*5-4, 160, 5, " ")
  computer.pullSignal(0.0001)
end

local n = ui.add(dofile("/apps/launcher.lua"))

while true do
  ui.tick()
  if not ui.running(n) then
    n = ui.add(dofile("/apps/launcher.lua"))
  end
end
