-- bios!
ROM_VERSION = 1.1

-- GPU + some graphical functions
local gpu,w,h=component.proxy(component.list"gpu"())
gpu.bind((assert(component.list"screen"())))
w,h=gpu.maxResolution()
if w>=80 then
  w,h=80,25
  gpu.setResolution(80, 25)
end

_G.system={}

local icons={system={
"⡏⡏⠯⠭⠏⠯⠽⢹",
"⡇⡯⢽⠉⡏⠭⠭⢽",
"⡇⡯⢽ ⡇⠭⠭⢽",
"⣇⣯⣽⣀⣇⣭⣭⣽"},
alert={
"  ⢀⠎⠱⡀  ",
" ⢀⠎⡎⢱⠱⡀ ",
"⢀⠎ ⡣⢜ ⠱⡀",
"⣎⣀⣀⣑⣊⣀⣀⣱"},
info={
"⢀⠔⠊⢉⡉⠑⠢⡀",
"⡎  ⡣⢜  ⢱",
"⢇  ⡇⢸  ⡸",
"⠈⠢⢄⣈⣁⡠⠔⠁"},
--info={"⢀⠔⠊⡩⢍⠑⠢⡀","⡎  ⡕⢪  ⢱","⢇  ⡇⢸  ⡸","⠈⠢⢄⣑⣊⡠⠔⠁"}
}

function system.icon(ic,x,y)
  checkArg(1,ic,"string","table")
  checkArg(2,x,"number")
  checkArg(3,y,"number")
  if icons[ic]then ic=icons[ic]end
  for i=1,#ic,1 do
    gpu.set(x,y+i-1,ic[i])
  end
end

function system.drawbg()
  gpu.setForeground(0)
  gpu.setBackground(0xFFFFFF)
  gpu.fill(1,1,w,h,"▒")
  gpu.fill(1,1,w,1," ")
end

function system.frame(x, y, w, h)
  local top=string.format("⡎%s⢱",string.rep("⠉",w-1))
  local left=string.rep("⡇",h-1)
  local right=string.rep("⢸",h-1)
  local bottom=string.format("⢇%s⡸",string.rep("⣀",w-1))
  gpu.fill(x,y+1,w,h," ")
  gpu.set(x,y,top)
  gpu.set(x,y+h,bottom)
  gpu.set(x,y+1,left,true)
  gpu.set(x+w,y+1,right,true)
end

function system.button(text,x,y,press)
  checkArg(1,text,"string")
  checkArg(2,x,"number")
  checkArg(3,y,"number")
  checkArg(4,press,"boolean","nil")
  local top=string.format("⢀%s⡀",string.rep("⣀",#text))
  local middle=string.format("⡇%s⢸",text)
  local bottom=string.format("⠈%s⠁",string.rep("⠉",#text))
  gpu.set(x,y,top)
  if press then
    gpu.setBackground(0)
    gpu.setForeground(0xFFFFFF)
  end
  gpu.set(x,y+1,middle)
  if press then
    gpu.setForeground(0)
    gpu.set(x,y+1,"⡇")
    gpu.set(x+#text+1,y+1,"⢸")
    gpu.setBackground(0xFFFFFF)
  end
  gpu.set(x,y+2,bottom)
end

function system.notify(icon,text,opts)
  opts=opts or{"OK"}
  checkArg(1,icon,"string")
  checkArg(2,text,"string")
  checkArg(3,opts,"table")
  local bw,bh=math.max(48,#text+16),8
  local bx,by=(w//2)-(bw//2),(h//4)
  gpu.setForeground(0)
  system.frame(bx,by,bw,bh)
  system.icon(icon,bx+3,by+2)
  gpu.set(bx+14,by+3,text)
  if #opts==0 then return end
  computer.pushSignal("box")
  while true do
    local evt,_,x,y=computer.pullSignal()
    local n=0
    for i,opt in ipairs(opts)do
      local len=#opt+3
      local Bx,By=(bx+bw-1-n)-len,by+bh-3
      local pr=(evt=="touch"and(x>=Bx and x<=Bx+len)and(y>=By and y<=By+2))
      system.button(opt,Bx,By,pr)
      if pr then return opt end
      n = n + len
    end
  end
end

system.drawbg()

-- filesystem + some file routines
local fs
do
  for k,v in component.list("filesystem") do
    if component.invoke(k,"exists","/System Folder/Main.lua") then
      fs=component.proxy(k)
      break
    end
  end
  if not fs then
    system.notify("alert","No valid filesystem was detected.")
    while true do computer.pullSignal() end
  end
end

function system.readfile(f)
  checkArg(1,f,"string")
  local fd=fs.open(f,"r")
  if not fd then
    return nil,"The file could not be opened."
  end
  local data=""
  repeat
    local chunk=fs.read(fd,128)
    data=data..(chunk or"")
  until not chunk
  return data
end

function system.loadfile(f,m,e)
  local d,E=system.readfile(f)
  if not d then return nil,E end
  return load(d,"="..f,m,e)
end

function system.writefile(f,d)
  checkArg(1,f,"string")
  checkArg(2,d,"string")
  local fd=fs.open(f,"w")
  if not fd then
    return nil,"The file could not be opened."
  end
  fs.write(fd,d)
  fs.close(fd)
  return true
end

system.notify("system","The system ROM version is "..ROM_VERSION..".",{})
do
  local mt=computer.uptime()+1
  repeat
    computer.pullSignal(mt-computer.uptime())
  until computer.uptime()>=mt
end

system.loadfile("/System Folder/Main.lua")(gpu)

system.notify("info","It is now safe to turn off your computer.",{"Restart"})
computer.shutdown(true)
