-- file browser app

local app = {}

local function mkfolderview(f)
  local buttons = buttongroup()
  local files = fs.list(f) or {}
  for i, file in ipairs(files) do
    buttons:add {
      x = 2, y = i + 3,
      text = file
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
