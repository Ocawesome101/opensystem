-- new text editor

local app = {}

function app:init()
  self.x = 10
  self.y = 5
  self.w = 80
  self.h = 25
  self.scrollp = 0
  self.text = ""
  self.pos = 0
end

function app:refresh()
  gpu.setForeground(0x000000)
  gpu.fill(self.x, self.y, self.w, self.h, " ")
  local text = {}
  local line = ""
  local written = 0
  for c in self.text:gmatch(".") do
    written = written + 1
    if c == "\n" then
      text[#text+1]=line
      line=""
    elseif written-1 == self.pos then
      line=line.."|"
    else
      line=line..c
    end
    if #line>=self.w then
      text[#text+1]=line
      line=""
    end
  end
  if written==self.pos then line = line .. "|" end
  if #line > 0 then text[#text+1]=line end
  for i=1, self.h, 1 do
    local n = i + self.scrollp
    gpu.set(self.x, self.y+i-1, text[n] or "")
  end
end

function app:key(c,k)
  local ch = string.char(c)
  if k == 205 then
    self.pos = self.pos + 1
    if self.pos > #self.text then
      self.text = self.text .. string.rep(" ", self.pos - #self.text)
    end
  elseif k == 203 then
    if self.pos > 0 then self.pos = self.pos - 1 end
  elseif k == 200 then
    if self.pos > self.w then self.pos = self.pos - self.w end
  elseif k == 208 then
    self.pos = self.pos + self.w
    if self.pos > #self.text then
      self.text = self.text .. string.rep(" ", self.pos - #self.text)
    end
  elseif c > 31 and c < 127 then
    if self.pos >= #self.text then
      self.text = self.text .. ch
    else
      self.text = self.text:sub(0, self.pos) .. ch .. self.text:sub(self.pos+1)
    end
    self.pos = self.pos + 1
  elseif c == 8 and self.pos > 0 then
    self.text = self.text:sub(0, self.pos - 1) .. self.text:sub(self.pos + 1)
    self.pos = self.pos - 1
  elseif c == 13 then
    local prev = #self.text - (self.text
      :reverse()
      :find("\n", #self.text - self.pos) or (#self.text - self.pos))
    self.text = self.text:sub(0,self.pos) .. "\n" .. self.text:sub(self.pos+1)
  end
end

function app:click()end

function app:scroll(n)
  self.scrollp = self.scrollp + n
  if self.scrollp < 0 then self.scrollp = 0 end
end

function app:close()
end

return window(app, "Editor")
