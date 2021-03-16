-- edit - text editor

local app = {}

local lines = {""}
local scr = 0

local function update()
  app.textboxes = textboxgroup()
  for i=scr+1, math.min(app.h,math.max(#lines,1)), 1 do
    app.textboxes:add {
      x = 1, y = i-scr, w = app.w, fg = 0x000000,
      i = i, text = lines[i] or "", submit = function(text)
        lines[i] = text
        if i >= #lines then
          lines[#lines+1]=""
        else
          table.insert(lines, i + 1, "")
        end
        update()
        app.textboxes.focused = i + 1
      end
    }
    --app.textboxes.boxes[#app.textboxes.boxes].text = lines[i] or ""
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
  if self.prompt then
    local file = self.prompt.poll()
    if file and type(file) == "string" then
      self.prompt = nil
      if fs.exists(file) then
        self:load(file)
      else
        notify("That file does not exist.")
      end
    end
  end
end

function app:key(k, c)
  self.textboxes:key(k)
  if self.textboxes[self.textboxes.focused] then
    lines[self.textboxes[self.textboxes.focused].i] =
      self.textboxes[self.textboxes.focused].text
  end
  if k == 15 then -- ^O
    self.prompt = prompt("text", "File to open:")
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
