-- System Interface library --

_G.finder = {}

local _window = {}

function _window:resize()
end

function _window:close()
end

setmetatable(_window, {__index = system._canvas})

function finder.makeWindow()
end

function finder.start()
  finder.start = nil
  while true do
  end
end
