-- an attempt at a user-interface designer.  hooooo-boy.

local app = {}

local function updatebar(self)
  self.bar.buttons = {}
  local n = 3
  for i=1, #self.views, 1 do
    self.bar:add {
      x = n, y = 2,
      fg = self.active == i and 0x888888 or 0x000000,
      bg = self.active == i and 0x000000 or 0x888888,
      text = self.views[i].name or "",
      click = function()
        self.active = i
      end
    }
    n = n + #self.views[i].name + 1
  end
end

function app:init()
  self.w = 156
  self.h = 48
  self.x = 1
  self.y = 1
  self.bar = buttongroup()
  self.views = {view(3, 5, 152, 43, false)}
  self.views[1].name = "widgets"
  self.active = 1
  updatebar(self)
end

function app:refresh()
  if self.views[self.active] then
    self.views[self.active]:draw(self)
  end
  self.bar:draw(self)
end

function app:click(x,y)
  if self.views[self.active] then
    self.views[self.active]:click(x,y)
  end
  self.bar:click(x,y)
end

function app:key()
end

function app:scroll()
end

function app:close()
end

return window(app, "Interface Creator")
