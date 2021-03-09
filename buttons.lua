-- buttons!

local base = {}

function base:click(x, y)
  for k,v in pairs(self.buttons) do
    if x >= v.x and x <= v.x + #v.text and y == v.y then
      if v.click then v.click() end
    end
  end
end

function base:draw(app)
  local f,b
  for k, v in pairs(self.buttons) do
    if v.fg and v.fg ~= f then
      gpu.setForeground(v.fg)
      f = v.fg
    end
    if v.bg and v.bg ~= b then
      gpu.setBackground(v.bg)
      b = v.bg
    end
    gpu.set(app.x + v.x - 1, app.y + v.y - 1, v.text)
  end
end

function base:add(btn)
  self.buttons[#self.buttons+1] = btn
end

function buttongroup()
  return setmetatable({buttons={}}, {__index=base})
end
