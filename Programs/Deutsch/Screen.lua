local component = require("component")
local modem = component.modem
local gpu = component.gpu
local event = require("event")
local unicode = require("unicode")
local computer = require("computer")

local conf = {}
local button = {}
local light = {}
local door = {}
local alarm = {}
local lightbutton = {}
local doorbutton = {}
local button2 = {}
local lock = {}
local code = {}

gpu.setResolution(80, 35)

Port = 4
Green = 0x33DB00
Green2 = 0x33B600
Red = 0xFF0000
Black = 0x000000
White = 0xFFFFFF

function conf.setmenu()
    button.setTable("Lichter", "lights", 2, 3, 7, 26, Green)
    button.setTable("Türen", "doors",2, 29, 7, 52, Green)
    button.setTable("Alarmanlage", "alarm", 2, 55, 7, 78, Green)
end

function conf.setlights()
    button.draw(2, 3, 7, 26, "Lichter", Red)
    button.setTable("Türen", "doors", 2, 29, 7, 52, Green)
    button.setTable("Alarmanlage", "alarm", 2, 55, 7, 78, Green)

    lightbutton.setTable("Garage", "garage", 8, 4, 11, 17, "Das Licht in der Garage ist eingeschaltet!", "Das Licht in der Garage ist ausgeschaltet!", Green)
    lightbutton.setTable("Küche", "kitchen", 8, 19, 11, 32, "Das Licht in der Küche ist eingeschaltet!", "Das Licht in der Küche ist ausgeschaltet!", Green)
    lightbutton.setTable("Esszimmer", "dining room", 8, 34, 11, 48, "Das Licht im Esszimmer ist eingeschaltet!", "Das Licht im Esszimmer ist ausgeschaltet!", Green)
    lightbutton.setTable("Bad unten", "bathroom down", 8, 50, 11, 63, "Das Licht im Bad unten ist eingeschaltet!", "Das Licht im Bad unten ist ausgeschaltet!", Green)
    lightbutton.setTable("Büro", "office", 8, 65, 11, 77, "Das Licht im Büro ist eingeschaltet!", "Das Licht im Büro ist ausgeschaltet!", Green)
    lightbutton.setTable("Bad oben", "bathroom up", 11, 22, 14, 39, "Das Licht im Bad oben ist eingeschaltet!", "Das Licht im Bad oben ist ausgeschaltet!", Green)
    lightbutton.setTable("Kleiderschrank", "wardrobe", 11, 42, 14, 59, "Das Licht im Kleiderschrank ist eingeschaltet!", "Das Licht im Kleiderschrank ist ausgeschaltet!", Green)
    button.setTable("in allen ausschalten", "turn all off", 14, 29, 17, 52, Green)
end

function conf.statelights(state, reciever)
    if state == "on" then
        button.draw(18, 15, 21, 65, Stateonsentence, Green, "Möchten sie es ausschalten?")
        button.setTable("Ja", "turn off", 22, 22, 25, 39, Green)
    end
    if state == "off" then
        button.draw(18, 15, 21, 65, Stateoffsentence, Red, "Möchten sie es einschalten?")
        button.setTable("Ja", "turn on", 22, 22, 25, 39, Green)
    end
    button.setTable("Nein", "no", 22, 42, 25, 59, Green)
    Touch()
    if Func == "doors" then door() end
    if Func == "alarm" then alarm() end
    if Func == "turn off" or Func == "turn on" then modem.send(reciever, Port, "light", Room, Func)
        local _, _, _, _, _, check = event.pull("modem_message")
        conf.lightscheck(check)
    end
    Func, state, Room = nil
end

function conf.lightscheck(check)
    if check == "turned on" then button.draw(25, 15, 28, 65, "Das Licht wurde eingeschaltet!", Green) end
    if check == "turned off" then button.draw(25, 15, 28, 65, "Das Licht wurde ausgeschaltet!", Green) end
end

function conf.setdoors()
    button.setTable("Lichter", "lights", 2, 3, 7, 26, Green)
    button.draw(2, 29, 7, 52, "Türen", Red)
    button.setTable("Alarmanlage", "alarm", 2, 55, 7, 78, Green)

    doorbutton.setTable("Haustür", "front door", 8, 15, 11, 38, "Die Haustür ist geöffnet!", "Die Haustür ist geschlossen!", Green)
    doorbutton.setTable("Garagentor", "garage door", 8, 43, 11, 66, "Das Garagentor ist geöffnet!", "Das Garagentor ist geschlossen!", Green)
end

function conf.statedoors(state)
    if state == "opened" then
        button.draw(11, 20, 14, 60, Sos, Red, "Möchten sie die Tür schließen?")
        button.setTable("Ja", "close", 15, 22, 18, 39, Green)
    end
    if state == "closed" then
        button.draw(11, 20, 14, 60, Scs, Green, "Möchten sie die Tür öffnen?")
        button.setTable("Ja", "open", 15, 22, 18, 39, Green)
    end
    button.setTable("Nein", "no", 15, 42, 18, 59, Green)
    Touch()
    if Func == "no" then
    else lock.doorcode(Func, 19, 34)
    end
end

function conf.checkdooraction(check, miny)
    if check == "was opened" then button.draw(miny + 13, 25, miny + 16, 55, "Die Tür wurde geöffnet!", Green) end
    if check == "was closed" then button.draw(miny + 13, 25, miny + 16, 55, "Die Tür wurde geschlossen!", Green) end
end

function conf.setalarm()
    button.setTable("Lichter", "lights", 2, 3, 7, 26, Green)
    button.setTable("Türen", "doors",2, 29, 7, 52, Green)
    button.draw(2, 55, 7, 78, "Alarmanlage", Red)
end

function conf.statealarm(state)
    if state == "alarm not triggered" then
        button.draw(7, 15, 12, 65, "Es wurde kein Alarm ausgelöst!", Green)
    end

    if state == "alarm triggered" then
        button.draw(7, 15, 12, 65, "Es wurde ein Alarm ausgelöst!", Red)
        button.setTable("Alarm zurücksetzen", "reset alarm", 12, 17, 15, 39, Green)
        button.setTable("Alarm deaktivieren", "disable alarm", 12, 41, 15, 63, Green)
        Touch()
        lock.alarmcode(Func, 15, 34)
    end
end

function conf.checkalarm(check, miny)
    if check == "alarm disabled" then button.draw(miny + 13, 20, miny + 16, 60, "Der Alarm wurde deaktiviert!", Green) end
    if check == "alarm reset" then button.draw(miny + 13, 20, miny + 16, 60, "Der Alarm wurde zurückgesetzt!", Green) end
end

::checkserv::
modem.broadcast(Port, "check server")
local _, _, server, _, _, servok = event.pull("modem_message")
if servok ~= "server ok" then goto checkserv end

function button.clear()
    button2 = {}
end

function button.draw(miny, minx, maxy, maxx, text, color, text2)
    gpu.setBackground(Black)
    if text2 ~= nil then Maxy2 = maxy + 1
    else Maxy2 = maxy end
    gpu.set(minx, miny, unicode.char(0x2552))
    gpu.set(minx + 1, miny, string.rep(unicode.char(0x2550), maxx - minx - 1))
    gpu.set(maxx, miny, unicode.char(0x2555))
    local frameheight = Maxy2 - miny - 2
    gpu.fill(minx, miny + 1, 1, frameheight, unicode.char(0x2502))
    gpu.fill(maxx, miny + 1, 1, frameheight, unicode.char(0x2502))
    gpu.set(minx, Maxy2 - 1, unicode.char(0x2514))
    gpu.set(minx + 1, Maxy2 - 1, string.rep(unicode.char(0x2500), maxx - minx - 1))
    gpu.set(maxx, Maxy2 - 1, unicode.char(0x2518))
    gpu.setBackground(color)
    local width = maxx - minx - 1
    local height = Maxy2 - miny - 2
    gpu.fill(minx + 1, miny + 1, width, height, " ")
    local y = (miny + maxy) / 2
    local x = math.ceil((maxx - minx - #text) / 2) + minx
    gpu.set(x, y, text)
    if text2 ~= nil then
        local y2 = y+1
        local x2 = math.ceil((maxx - minx - #text2) / 2) + minx
        gpu.set(x2, y2, text2)
    end
    gpu.setBackground(Black)
end

function button.setTable(name, func, miny, minx, maxy, maxx, color)
    button.draw(miny, minx, maxy, maxx, name, color)
    button2[name] = {}
    button2[name]["name"] = name
    button2[name]["func"] = func
    button2[name]["miny"] = miny
    button2[name]["minx"] = minx
    button2[name]["maxy"] = maxy
    button2[name]["maxx"] = maxx
end

function lightbutton.setTable(name, func, miny, minx, maxy, maxx, stateonsentence, stateoffsentence, color)
    button.draw(miny, minx, maxy, maxx, name, color)
    button2[name] = {}
    button2[name]["name"] = name
    button2[name]["func"] = func
    button2[name]["miny"] = miny
    button2[name]["minx"] = minx
    button2[name]["maxy"] = maxy
    button2[name]["maxx"] = maxx
    button2[name]["stateonsentence"] = stateonsentence
    button2[name]["stateoffsentence"] = stateoffsentence
end

function doorbutton.setTable(name, door, miny, minx, maxy, maxx, stateopensentence, stateclosesentence, color)
    button.draw(miny, minx, maxy, maxx, name, color)
    button2[name] = {}
    button2[name]["name"] = name
    button2[name]["func"] = door
    button2[name]["miny"] = miny
    button2[name]["minx"] = minx
    button2[name]["maxy"] = maxy
    button2[name]["maxx"] = maxx
    button2[name]["opensentence"] = stateopensentence
    button2[name]["closesentence"] = stateclosesentence
end

function Touch()
    local _, _, x, y, _, _ = event.pull("touch")
    for _, data in pairs(button2) do
        if y >= data["miny"] and  y <= data["maxy"] then
        if x >= data["minx"] and x <= data["maxx"] then
            button.draw(data["miny"], data["minx"], data["maxy"], data["maxx"], data["name"], Red)
            Func = data["func"]
            Stateonsentence = data["stateonsentence"]
            Stateoffsentence = data["stateoffsentence"]
            Sos = data["opensentence"]
            Scs = data["closesentence"]
            Action = data["action"]
        end
    end
end
end

function light()
    gpu.setBackground(Black)
    os.execute("cls")
    button.clear()
    conf.setlights()
    Touch()
    if Func == "doors" then door() end
    if Func == "alarm" then alarm() end
    modem.open(Port)
    modem.send(server, Port, "light", Func)
    if Func == "turn all off" then
    else Room = Func
        _, _, _, _, _, State = event.pull("modem_message")
        conf.statelights(State, server)
    end
end

function door()
    gpu.setBackground(Black)
    X, Y = gpu.getResolution()
    gpu.fill(1, 1, X, Y, " ")
    X, Y = nil
    button.clear()
    conf.setdoors()
    Touch()
    if Func == "lights" then light() end
    if Func == "alarm" then alarm() end
    modem.open(Port)
    modem.send(server, Port, "door", Func)
    Doorname = Func
    local _, _, _, _, _, status = event.pull("modem_message")
    conf.statedoors(status)
end

function alarm()
    gpu.setBackground(Black)
    os.execute("cls")
    button.clear()
    conf.setalarm()
    modem.broadcast(Port, "alarm")
    local _, _, _, _, _, status = event.pull("modem_message")
    conf.statealarm(status)
end

function lock.code(miny, minx, color)
    local maxx = minx + 12
    local maxy = miny + 11
    Backx = minx + 9
    Backy = miny + 9
    gpu.setBackground(Black)
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
    gpu.setBackground(Black)
    lock.Touch(minx, miny)
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
        gpu.setBackground(Green2)
        for _, data in pairs(code) do
            if X == data["x"] and Y == data["y"] then
                Num = data["number"]
                gpu.set(data["x"], data["y"], data["number"])
            end
        end
        if Num ~= nil or X == Backx and Y == Backy then break end
    end
    if X == Backx and Y == Backy then gpu.set(Backx, Backy, unicode.char(0x2190)) end
    gpu.setBackground(Green)
    if X == Backx and Y == Backy then os.sleep(0.5) gpu.set(Backx, Backy, unicode.char(0x2190)) else gpu.set(x2, y2, "*") end
    if Num ~= nil then
        os.sleep(0.5)
        gpu.set(X, Y, Num)
    end
end
function lock.Touch(minx, miny)
    ::GetD1::
    lock.digit(minx+ 3, miny + 1)
    D1 = Num
    gpu.set(Backx, Backy, unicode.char(0x2190))
    ::GetD2::
    lock.digit(minx + 5, miny + 1)
    D2 = Num
    if X == Backx and Y == Backy then gpu.set(minx + 3, miny + 1, " ") goto GetD1 end
    ::GetD3::
    lock.digit(minx+ 7, miny + 1)
    D3 = Num
    if X == Backx and Y == Backy then gpu.set(minx + 5, miny + 1, " ") goto GetD2 end
    lock.digit(minx+ 9, miny + 1)
    D4 = Num
    if X == Backx and Y == Backy then gpu.set(minx + 7, miny + 1, " ") goto GetD3 end
    Pass = D1..D2..D3..D4
end
function lock.codecheck(check, miny, minx)
    gpu.setBackground(Green)
    if check == "correct" then gpu.setForeground(Green2) computer.beep(500) computer.beep(1000) end
    if check == "wrong" then gpu.setForeground(Red) computer.beep(200) computer.beep(100) end
    gpu.set(minx + 3, miny + 1, "* * * *")
    Num, D1, D2, D3, D4, Pass = nil
    gpu.setForeground(White)
end

function lock.doorcode(action, miny, minx)
    lock.code(miny, minx, Green)
    modem.send(server, Port, "door", Doorname, action, Pass)
    local _, _, _, _, _, codecheck, check = event.pull("modem_message")
    if codecheck == "correct" then
        lock.codecheck(codecheck, miny, minx)
        conf.checkdooraction(check, miny)
    end
    if codecheck == "wrong" then lock.codecheck(codecheck, miny, minx) os.sleep(1) lock.doorcode(action, miny, minx) end
end

function lock.alarmcode(action, miny, minx)
    lock.code(miny, minx, Green)
    modem.send(server, Port, "alarm", nil, action, Pass)
    local _, _, _, _, _, codecheck, check = event.pull("modem_message")
    if codecheck == "correct" then
        lock.codecheck(codecheck, miny, minx)
        conf.checkalarm(check, miny)
    end
    if codecheck == "wrong" then
        lock.codecheck(codecheck, miny, minx)
        os.sleep(1)
        lock.alarmcode(action, miny, minx)
    end
end

while true do
    gpu.setBackground(Black)
    os.execute("cls")
    button.clear()
    conf.setmenu()
    Touch()
    if Func == "lights" then
        light()
    end
    if Func == "doors" then
        door()
    end
    if Func == "alarm" then
        alarm()
    end
    os.sleep(2)
end
