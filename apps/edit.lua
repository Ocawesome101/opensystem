-- edit - text editor

local app = {}

local lines = {""}
local line = 1

function app:init()
  self.x = 20
  self.y = 10
  self.w = 80
  self.h = 24
end

function app:refresh()
  
end

function app:key()
end

function app:click()
end

function app:close()
end

return window(app, "Editor")
