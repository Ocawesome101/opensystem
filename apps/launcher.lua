-- app launcher

local app = {}

local function mkview(t)
  t = t or ""
  local apps = fs.list("/apps") or {}
  table.sort(apps)
  app.buttons = buttongroup()
  local skipped = 0
  for i=1, #apps, 1 do
    local a = apps[i]
    if a ~= "login.lua" and a ~= "launcher.lua" and a:match(t) then
      app.buttons:add {
        x = 3, y = 3 + i - skipped, text = a:gsub("%.lua$", ""), fg = 0,
        click = function()
          local app = dofile("/apps/"..a)
          ui.add(app)
        end
      }
    else
      skipped = skipped + 1
    end
  end
  app.h = #apps + 4 - skipped
end

function app:init()
  self.x = 3
  self.y = 2
  self.w = 16
  self.h = 10
  self.apps = fs.list("/apps") or {}
  mkview()
  self.textboxes = textboxgroup()
  self.textboxes:add {
    x = 3, y = 2, w = 12, bg = 0, fg = 0x888888,
    submit = function(t)
      mkview(t)
    end
  }
end

function app:refresh()
  self.buttons:draw(self)
  self.textboxes:draw(self)
end

function app:click(x,y)
  self.buttons:click(x, y)
  self.textboxes:click(x, y)
end

function app:key(k)
  self.textboxes:key(k)
end

function app:close()
end

return window(app, "Launcher")