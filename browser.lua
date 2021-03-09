-- file browser app

local app = {}

local function prompt(f)
  f = f:gsub("[/\\]+", "/")
  local new = {}

  function new:init()
    self.x = app.x + 10
    self.y = app.y + 5
    self.w = 24
    self.h = 5
    self.labels = labelgroup()
    self.buttons = buttongroup()
    self.labels:add {
      x = 3, y = 2, text = "What do you want to"
    }
    self.labels:add {
      x = 3, y = 3, text = "do with this file?"
    }
    self.buttons:add {
      x = 3, y = 5, text = "Execute", click = function()
        local app = dofile(f)
        if app then ui.add(app) end
        self.closeme = true
      end
    }
  end
  
  function new:refresh()
    self.labels:draw(self)
    self.buttons:draw(self)
  end
  
  function new:click(x,y)
    self.buttons:click(x,y)
  end
  
  function new:key()
  end
  
  function new:close()
  end
  
  ui.add(window(new, f))
end

local function mkfolderview(f)
  local buttons = buttongroup()
  local files = fs.list(f) or {}
  for i, file in ipairs(files) do
    buttons:add {
      x = 2, y = i + 3,
      text = file,
      click = function()
        if fs.isDirectory(f .. "/" .. file) then
          app.buttons = mkfolderview(f .. "/" .. file)
          app.textboxes.boxes[1].text = (f .. "/" .. file):gsub("[/\\]+", "/")
        else
          prompt(f.."/"..file)
        end
      end
    }
  end
  return buttons
end

function app:init()
  self.x = 10
  self.y = 5
  self.w = 64
  self.h = 32
  self.labels = labelgroup()
  self.labels:add {
    x = 3, y = 2, fg = 0x000000, text = "Path:"
  }
  self.textboxes = textboxgroup()
  self.textboxes:add {
    x = 8, y = 2, w = 54, fg = 0x888888, bg = 0x000000,
    text = "/", submit = function(text)
      if fs.exists(text) then
        self.view = mkfolderview(text)
      else
        self.view = {}
      end
    end
  }
  self.buttons = mkfolderview("/")
end

function app:refresh()
  self.labels:draw(self)
  self.buttons:draw(self)
  self.textboxes:draw(self)
end

function app:key(k)
  self.textboxes:key(k)
end

function app:click(x, y)
  self.buttons:click(x, y)
  self.textboxes:click(x, y)
end

return window(app, "File Browser")
