-- new text editor

local app = {}

function app:init()
  self.x = 10
  self.y = 5
  self.w = 80
  self.h = 25
  self.scr = 0
  self.text = {"this is some text"}
  self.line = 1
  self.pos = 0
end

function app:refresh()
  gpu.setForeground(0x000000)
  for i=1, self.h, 1 do
    local n = i + self.scr
    local text = self.text[n] or ""
    local pos = (self.line == n and self.pos or 0)
    if self.line == n then
      if self.pos == 0 then
        text = text .. "|"
      else
        text = text:sub(1,-self.pos - 1) .. "|" .. text:sub(-self.pos + 1)
      end
    end
    local tn = 1
    if #text > self.w then
      tn = math.max(1, (#text - pos) - self.w)
    end
    gpu.set(self.x, self.y+i-1, (text:sub(tn, tn + self.w)))
  end
end

function app:key(c,k)
  if c > 31 and c < 127 then
    local ch = string.char(c)
    local ltx = self.text[self.line]
    if self.pos == 0 then
      self.text[self.line] = ltx .. ch
    else
      self.text[self.line] = ltx:sub(1, #ltx - self.pos) .. ch ..
        ltx:sub(#ltx - self.pos + 1)
    end
  end
end

function app:click(x, y)
  self.line = math.max(1, math.min(#self.text, y + self.scr))
  if #self.text[self.line] < self.w then
    self.pos = #self.text - x
  else
    self.pos = #self.text - (x + (#self.text - self.w))
  end
end

function app:scroll(n)
  self.scr = self.scr + n
  if self.scr < 0 then self.scr = 0 end
end

function app:close()
end

return window(app, "Editor")
