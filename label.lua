-- text groups

local base = {}

function base:draw(app)
  for k, v in pairs(self.labels) do
    gpu.set(app.x+v.x-1, app.y+v.y-1, v.text)
  end
end

function base:add(new)
  self.labels[#self.labels+1] = new
end

function labelgroup()
  return setmetatable({labels={}},{__index=base})
end
