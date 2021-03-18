-- an attempt at a user-interface designed.  hooooo-boy.

local app = {}

function app:init()
  self.w = 156
  self.h = 48
  self.x = 1
  self.y = 1
  self.nodrag = true
  self.views = {view()}
  self.active = 1
end

function app:refresh() end

return window(app, "Interface Creator")
