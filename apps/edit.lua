-- edit - text editor

local app = {}

local lines = {""}
local scr = 0

local function update()
  app.textboxes = textboxgroup()
  for i=scr+1, math.min(app.h,math.max(#lines,1)), 1 do
    app.textboxes:add {
      x = 1, y = i, w = app.w, fg = 0x000000, submit = function()
        if i >= #lines then
          lines[#lines+1]=""
        else
          table.insert(lines, i + 1, "")
        end
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
  local ln = ""
  lines = {}
  for c in data:gmatch() do
    if c == "\n" then
      lines[#lines + 1] = ln
      ln = ""
    else
      ln = ln .. c
    end
  end
end

function app:refresh()
  self.textboxes:draw(self)
end

function app:key(k, c)
  self.textboxes:key(k)
  if k == 15 then -- ^O
    local file = prompt("text", "Enter File")
    if not file then return end
    if not fs.exists(file) then
      notify("That file does not exist.")
    else
      self:load(file)
    end
  end
end

function app:click(x,y)
  self.textboxes:click(x,y)
end

function app:scroll(n)
  scr = scr + n
  if scr < 0 then scr = 0 end
  update()
end

function app:close()
end

return window(app, "Editor")
