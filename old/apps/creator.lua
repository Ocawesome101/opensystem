-- an attempt at a user-interface designer.  hooooo-boy.

local app = {}

local templates = {
  main = [[
local app = {}

%s

return window(app, "%s")
]],
  init = [[
function app:init()
  %s
end
]],
  refresh = [[
function app:refresh()
  %s
end
]],
  click = [[
function app:click(x,y)
  %s
end
]],
  key = [[
function app:key(c,k)
  %s
end
]],
  scroll = [[
function app:scroll(n)
  %s
end
]],
  close = [[
function app:close()
  %s
end
]],
  selfdecl = [[
  self.%s = %s
]],
  -- elemadd<x, y, w, fg, bg, text, click, submit>
  elemadd = [[
  self.%s:add {
    x = %d,
    y = %d,
    w = %s,
    fg = %s,
    bg = %s,
    text = %q,
    click = %s,
    submit = %s
  }
]],
}

local function execute_app()
  local demo = {}
end

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
  self.bar:add {
    x = n, y = 2,
    text = "Run App",
    click = function()
      execute_app()
    end
  }
end

function app:init()
  self.w = 156
  self.h = 48
  self.x = 1
  self.y = 1
  self.bar = buttongroup()
  self.app = {}
  self.views = {view(3, 5, 152, 10, false)}
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
