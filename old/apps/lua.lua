-- Lua REPL

local app = {}

local env = setmetatable({}, {__index = _G})

local WIDTH, LINES
function env.print(...)
  local args = table.pack(...)
  for i=1, args.n, 1 do
    args[i] = tostring(args[i])
  end
  local new = string.format(("%s  "):rep(args.n), table.unpack(args))
  while #new > WIDTH do
    app.text[#app.text+1] = new:sub(1, WIDTH)
    new = new:sub(WIDTH + 1)
  end
  if #new > 0 then app.text[#app.text+1] = new end
  while #app.text >= LINES do
    table.remove(app.text, 1)
  end
  return true
end

function app:init()
  self.x = 10
  self.y = 5
  local sw, sh = gpu.maxResolution()
  self.w = sw / 2
  self.h = sh / 2
  WIDTH = self.w - 4
  LINES = self.h - 2
  self.text = {}
  self.textboxes = textboxgroup()
  self.textboxes:add {
    x = 3,
    y = self.h - 1,
    w = WIDTH,
    submit = function(text)
      local ok, err = load("return " .. text, "=input", "bt", env)
      if not ok then
        ok = load(text, "=input", "bt", env)
      end
      if not ok then
        notify(err)
      else
        local result = table.pack(pcall(ok))
        if not result[1] and result[2] then
          notify(result[2])
        else
          for i=2, result.n, 1 do result[i] = tostring(result[i]) end
          local new = string.format(("%s  "):rep(result.n-1), table.unpack(result, 2))
          while #new > WIDTH do
            self.text[#self.text+1] = new:sub(1, WIDTH)
            new = new:sub(WIDTH + 1)
          end
          if #new > 0 then self.text[#self.text+1] = new end
          while #self.text >= LINES do
            table.remove(self.text, 1)
          end
          return true
        end
      end
    end
  }
end

function app:refresh()
  gpu.setForeground(0)
  for i=1, #self.text, 1 do
    gpu.set(self.x + 2, self.y + i, self.text[i])
  end
  gpu.setForeground(0x888888)
  gpu.setBackground(0)
  self.textboxes:draw(self)
end

function app:click(x,y)
  self.textboxes:click(x,y)
end

function app:key(k)
  self.textboxes:key(k)
end

function app:close()
end

return window(app, "Lua")
