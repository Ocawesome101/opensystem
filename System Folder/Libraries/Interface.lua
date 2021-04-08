-- System Interface library --

_G.finder = {}

local _window = {}

function _window:resize(w, h)
  self.elements:resize(w, h)
end

function _window:key(key, char)
  self.elements:key(key, char)
end

function _window:click(x, y)
  self.elements:click(x, y - 1)
end

function _window:close()
  if self.elements.close then
    self.elements:close()
  end
end

setmetatable(_window, {__index = system._canvas})

finder.windows = {}

function finder.makeWindow(elements)
  return setmetatable({
    elements = elements,
  }, {__index = _window})
end

function finder.start()
  finder.start = nil
  while true do
  end
end
