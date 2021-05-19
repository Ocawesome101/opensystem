-- System Interface library --

local gpu = ...

_G.finder = {}

local _window = {}

local b_close = "▢"
local b_pressed = "▣"
local b_max = "◰"
local b_blank = "▤"

local function mktbar(t, w)
  w = math.max(w, 12)
  
end

function _window:refresh(t, f)
end

function _window:resize(w, h)
  self.canvas:resize(w, h)
end

function _window:key(key, char)
  self.canvas:key(key, char)
end

function _window:click(x, y)
  self.canvas:click(x, y - 1)
end

function _window:close()
  if self.canvas.close then
    self.canvas:close()
  end
end

setmetatable(_window, {__index = system._canvas})

finder.windows = {}

function finder.makeWindow(title, canvas)
  checkArg(1, title, "string")
  checkArg(2, canvas, "table")
  local win = {tbar = mktbar(title, canvas.w), canvas = canvas}
  local function refresh(focused)
    _window.refresh(canvas, tb, focused)
  end
  setmetatable(win, { __index = function(t, k)
    if k == "refresh" then
      return refresh
    else
      return canvas[k] or _window[k]
    end
  end })
end

function finder.start()
  finder.start = nil
  while true do
  end
end
