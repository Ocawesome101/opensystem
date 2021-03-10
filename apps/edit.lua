-- edit - text editor

local app = {}

local lines = {""}
local scr = 0

local function update()
  app.textboxes = textboxgroup()
  for i=scr+1, math.min(app.h,#lines), 1 do
    app.textboxes:add {
      x = 1, y = i, w = app.w, submit = function()
        table.insert(lines, i + 1, "")
      end
    }
  end
end

function app:init()
  self.x = 20
  self.y = 10
  self.w = 80
  self.h = 24
  update()
end

function app:load(file)
  local data = fread(file) or ""
  for c in data:gmatch()
  end
end

function app:refresh()
  self.textboxes:draw(self)
end

function app:key(k, c)
  self.textboxes:key(k)
end

function app:click()
end

function app:close()
end

return window(app, "Editor")
