-- bios!

-- GPU + some graphical functions
local gpu = component.proxy(component.list('gpu')())
gpu.bind((assert(component.list("screen")())))

_G.system = {}

local icons = {
  system = {
    "⡏⡏⠯⠭⠏⠯⠽⢹",
    "⡇⡯⢽⠉⡏⠭⠭⢽",
    "⡇⡯⢽ ⡇⠭⠭⢽",
    "⣇⣯⣽⣀⣇⣭⣭⣽"
  },
  alert = {
    "  ⢀⠎⠱⡀  ",
    " ⢀⠎⡎⢱⠱⡀ ",
    "⢀⠎ ⡣⢜ ⠱⡀",
    "⣎⣀⣀⣑⣊⣀⣀⣱"
  },
  info = {
    "⢀⠔⠊⢉⡉⠑⠢⡀",
    "⡎  ⡣⢜  ⢱",
    "⢇  ⡇⢸  ⡸",
    "⠈⠢⢄⣈⣁⡠⠔⠁"
  },
}

function system.icon(ic, x, y)
  checkArg(1, ic, "string", "table")
  checkArg(2, x, "number")
  checkArg(3, y, "number")
  if type(ic) == "string" then ic = icons[ic] end
  for i=1, #ic, 1 do
    gpu.set(x, y + i - 1, ic[i])
  end
end

function system.button(text, x, y, press)
  checkArg(1, text, "string")
  checkArg(2, x, "number")
  checkArg(3, y, "number")
  checkArg(4, press, "boolean", "nil")
  local top = string.format("⢀%s⡀", string.rep("⣀", #text))
  local middle = string.format("⡇%s⢸", text)
  local bottom = string.format("⠈%s⠁", string.rep("⠉", #text))
  gpu.set(x, y, top)
  if press then
    gpu.setBackground(0)
    gpu.setForeground(0xFFFFFF)
  end
  gpu.set(x, y + 1, middle)
  if press then
    gpu.setForeground(0)
    gpu.set(x, y + 1, "⡇")
    gpu.set(x + #text, y + 1, "⢸")
    gpu.setBackground(0xFFFFFF)
  end
  gpu.set(x, y + 2, bottom)
end

function system.notify(icon, text, opts)
  opts = opts or {"OK"}
  checkArg(1, icon, "string")
  checkArg(2, text, "string")
  checkArg(3, opts, "table")
  local w, h = gpu.maxResolution()
  local bx, by = (w // 2) - 16, (h // 4)
  gpu.setForeground(0)
  gpu.setBackground(0)
  gpu.fill(bx, by, 48, 12, " ")
  gpu.setBackground(0xFFFFFF)
  gpu.fill(bx + 1, by, 46, 12, "⠶")
  gpu.fill(bx + 2, by + 1, 44, 10, " ")
  system.icon(icon, bx + 3, by + 2)
  gpu.set(bx + 12, by + 3, text)
  if #opts == 0 then return end
  while true do
    local evt, _, x, y = computer.pullSignal()
    local n = 0
    for i=1, #opts, 1 do
      local len = #opts[i] + 3
      system.button(opts[i], (bx + 44 - n) - len, by + 6)
      n = n + len
    end
  end
end

-- filesystem + some file routines
local fs
do
  for k, v in component.list("filesystem") do
    if component.invoke(k, "exists", "/init.lua") then
      fs = component.proxy(k)
      break
    end
  end
end

system.notify("system", "HI THIS IS OPEN SYSTEM", {"OK", "Exit"})


