local component = require("component")
local modem = component.modem
local gpu = component.gpu
local event = require("event")
local unicode = require("unicode")
local computer = require("computer")
local lock = {}
local code = {}

dofile("/home/Codepadconf.lua")

local green = 0x33DB00
local green2 = 0x33B600
local red = 0xFF0000
local black = 0x000000
local white = 0xFFFFFF

local backx = 10
local backy = 10

gpu.setResolution(13, 12)

function lock.code(miny, minx, color, door)
  local maxx, maxy = gpu.getResolution()
  gpu.setBackground(black)
  gpu.set(minx, miny, unicode.char(0x2552))
  gpu.set(minx + 1, miny, string.rep(unicode.char(0x2550), maxx - minx - 1))
  gpu.set(maxx, miny, unicode.char(0x2555))
  local frameheight = maxy - miny - 1
  gpu.fill(minx, miny + 1, 1, frameheight, unicode.char(0x2502))
  gpu.fill(maxx, miny + 1, 1, frameheight, unicode.char(0x2502))
  gpu.set(minx, maxy, unicode.char(0x2514))
  gpu.set(minx + 1, maxy, string.rep(unicode.char(0x2500), maxx - minx - 1))
  gpu.set(maxx, maxy, unicode.char(0x2518))
  gpu.setBackground(color)
  local width = maxx - minx - 1
  local height = maxy - miny - 1
  gpu.fill(minx + 1, miny + 1, width, height, " ")
  lock.setTable(minx + 3, miny + 3, "1")
  lock.setTable(minx + 6, miny + 3, "2")
  lock.setTable(minx + 9, miny + 3, "3")
  lock.setTable(minx + 3, miny + 5, "4")
  lock.setTable(minx + 6, miny + 5, "5")
  lock.setTable(minx + 9, miny + 5, "6")
  lock.setTable(minx + 3, miny + 7, "7")
  lock.setTable(minx + 6, miny + 7, "8")
  lock.setTable(minx + 9, miny + 7, "9")
  lock.setTable(minx + 6, miny + 9, "0")
  gpu.setBackground(black)
  lock.Touch(minx, miny, door)
end

function lock.setTable(x, y, number)
  code[number] = {}
  code[number]["number"] = number
  code[number]["y"] = y
  code[number]["x"] = x
  gpu.set(x, y, number)
end

function lock.digit(x2, y2)
  while true do
    Num = nil
    _, _, X, Y, _, _ = event.pull("touch")
    gpu.setBackground(green2)
    for _, data in pairs(code) do
      if X == data["x"] and Y == data["y"] then
        Num = data["number"]
        gpu.set(data["x"], data["y"], data["number"])
      end
    end
    if Num ~= nil or X == backx and Y == backy then break end
  end
  if X == backx and Y == backy then gpu.set(backx, backy, unicode.char(0x2190)) end
  gpu.setBackground(green)
  if X == backx and Y == backy then os.sleep(0.5) gpu.set(backx, backy, unicode.char(0x2190)) else gpu.set(x2, y2, "*") end
  if Num ~= nil then
    os.sleep(0.5)
    gpu.set(X, Y, Num)
  end
end

function lock.Touch(minx, miny, door)
  ::GetD1::
  lock.digit(minx+ 3, miny + 1)
  D1 = Num
  gpu.set(backx, backy, unicode.char(0x2190))
  ::GetD2::
  lock.digit(minx+ 5, miny + 1)
  D2 = Num
  if X == backx and Y == backy then gpu.set(minx + 3, miny + 1, " ") goto GetD1 end
  ::GetD3::
  lock.digit(minx+ 7, miny + 1)
  D3 = Num
  if X == backx and Y == backy then gpu.set(minx + 5, miny + 1, " ") goto GetD2 end
  lock.digit(minx+ 9, miny + 1)
  D4 = Num
  if X == backx and Y == backy then gpu.set(minx + 7, miny + 1, " ") goto GetD3 end
  Pass = D1..D2..D3..D4
  modem.open(Port)
  modem.broadcast(Port, "code", door, nil, Pass)
  local _, _, _, _, _, check = event.pull("modem_message")
  gpu.setBackground(green)
  if check == "correct" then
    gpu.setForeground(green2)
    gpu.set(minx + 3, miny + 1, "* * * *")
    computer.beep(500) computer.beep(1000)
  end
  if check == "wrong" then
    gpu.setForeground(red)
    gpu.set(minx + 3, miny + 1, "* * * *")
    computer.beep(200) computer.beep(100)
  end
  Num = nil
  D1, D2, D3, D4 = nil, nil, nil, nil
  Pass = nil
  gpu.setForeground(white)
  os.sleep(1)
end

while true do
  lock.code(1, 1, green, Doorname)
end
