local sides = require("sides")
local colors = require("colors")
local conf = {}
local light = {}
local door = {}

local Port = 4 -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this server
local Logfile = "/home/log.txt" -- The location where the Logfile will be stored
local Serverrunningmessage = "Der Server läuft gerade" -- The message the server will display while it is running

-- Passcodes (the other ones for the doors are set via the setTable function)
local Lockhousepass = "1234"
local Garagepass = "1234"
local Alarmpass = "1234"

-- Garage Redstoneconfiguration
local Garageopenside = sides.left
local Garageopencolor = colors.black
local Garagecloseside = sides.left
local Garageclosecolor = colors.yellow

-- Alarm Redstoneconfiguration
local Alarmside = sides.left
local Alarmcolor = colors.red
local Alarmenableside = sides.left
local Alarmenablecolor = colors.orange
local Alarmresetside = sides.left
local Alarmresetcolor = colors.lightblue

-- Configuration of the lights and doors
function conf.setlights()
    light.setTable("garage", "Garage", sides.front, colors.yellow)
    light.setTable("kitchen", "Küche", sides.front, colors.white)
    light.setTable("dining room", "Esszimmer", sides.front, colors.orange)
    light.setTable("bathroom down", "Bad unten", sides.front, colors.silver)
    light.setTable("office", "Büro", sides.front, colors.brown)
    light.setTable("bathroom up", "Bad oben", sides.front, colors.cyan)
    light.setTable("wardrobe", "Kleiderschrank", sides.front, colors.black)
end

function conf.setdoors()
    door.setTable("front door", "Haustür", sides.left, colors.lime, "1234")
end

-- Configuration of the logmessages

function conf.setlogmessage()
    Checkedservermessage = Sender .. "       hat sich mit dem Server verbunden"
    if Object ~= nil then
        Checklightmessage = Sender .. "       hat den Status des Lichtes " .. Logname .. " abgefragt"
        Turnalllightsoffmessage = Sender .. "       hat in allen Räumen das Licht eingeschaltet"
        Checkdoormessage = Sender .. "       hat den Status der Tür " .. Logname .. " abgefragt"
        Checkgaragemessage = Sender .. "       hat den Status des Garagentores abgefragt"
        Actiondoorwrongcodemessage = Sender .. "       hat den flaschen Code eingegeben, um eine Aktion bei der Tür " .. Logname .. " auszuführen"
        Checkalarmmessage = Sender .. "       hat den Status des Alarms abgefragt"
        Actiongaragewrongcodemessage = Sender .. "       hat den falschen Code eingegeben, um eine Aktion beim Garagentor auszuführen"
        Actionalarmwrongcodemessage = Sender .. "       hat den falschen Code eingegeben, um eine Aktion beim Alarm auszuführen"
        Turnonlightmessage = Sender .. "       hat das Licht im Raum " .. Logname .. " eingeschaltet"
        Turnofflightmessage = Sender .. "       hat das Licht im Raum " .. Logname .. " ausgeschaltet"
        Lockhousemessage = Sender .. "       hat das Haus abgeschlossen."
        Opendoormessage = Sender .. "       hat die Tür " .. Logname .. " geöffnet"
        Closedoormessage = Sender .. "       hat die Tür " .. Logname .. " geschlossen"
        Opengaragemessage = Sender .. "       hat das Garagentor geöffnet"
        Closegaragemessage = Sender .. "       hat das Garagentor geschlossen"
        Disablealarmmessage = Sender .. "       hat den Alarm deaktiviert"
        Resetalarmmessage = Sender .. "       hat den Alarm zurückgesetzt"
    end
end

-- Program itself, Nothing to configure below

local term = require("term")
local component = require("component")
local rs = component.redstone
local gpu = component.gpu
local modem = component.modem
local event = require("event")
local filesystem = require("filesystem")
local unicode = require("unicode")
local sign = {}
local write = {}
local lights = {}
local doors = {}

gpu.setResolution(160, 50)
term.clear()

local alarm = {}


function sign.running(minx, miny, maxx, maxy, message)
    gpu.set(minx, miny, unicode.char(0x2552))
    gpu.set(minx + 1, miny, string.rep(unicode.char(0x2550), maxx - minx - 1))
    gpu.set(maxx, miny, unicode.char(0x2555))
    local frameheight = maxy - miny - 1
    gpu.fill(minx, miny + 1, 1, frameheight, unicode.char(0x2502))
    gpu.fill(maxx, miny + 1, 1, frameheight, unicode.char(0x2502))
    gpu.set(minx, maxy, unicode.char(0x2514))
    gpu.set(minx + 1, maxy, string.rep(unicode.char(0x2500), maxx - minx - 1))
    gpu.set(maxx, maxy, unicode.char(0x2518))
    local y = (miny + maxy) / 2
    local x = math.ceil((maxx - minx - #message) / 2) + minx
    gpu.set(x, y, message)
end

sign.running(1, 1, 160, 5, Serverrunningmessage)
term.setCursor(1, 6)

function write.log(message)
    Log = io.open(Logfile, "a")
    if filesystem.exists(Logfile) == true then
        Log:write("\n"..message)
    else
        Log:write(message)
    end
    print(message)
    Log:close()
end

function light.setTable(room, logname, side, color)
    lights[room] = {}
    lights[room]["room"] = room
    lights[room]["logname"] = logname
    lights[room]["side"] = side
    lights[room]["color"] = color
end

function light.clearTable()
    lights = {}
end

function light.check(room)
    for _, data in pairs(lights) do
        if room == data["room"] then
            Currstate = rs.getBundledOutput(data["side"], data["color"])
        end
    end
    if Currstate == 255 then State = "on" end
    if Currstate == 0 then State = "off" end
    modem.send(Sender, Port, State)
    write.log(Checklightmessage)
end

function light.action(room, action)
    if action == "turn on" then Strength = 255 end
    if action == "turn off" then Strength = 0 end
    for _, data in pairs(lights) do
        if room == data["room"] then
            rs.setBundledOutput(data["side"], data["color"], Strength)
            Currstate = rs.getBundledOutput(data["side"], data["color"])
        end
    end
    if action == "turn on" and Currstate == 255 then Check = "turned on" write.log(Turnonlightmessage)
    else if action == "turn off" and Currstate == 0 then Check = "turned off" write.log(Turnofflightmessage)
    else Check = "failed" end end
    modem.send(Sender, Port, Check)
end

function light.turnalloff()
    for _, data in pairs(lights) do
        rs.setBundledOutput(data["side"], data["color"], 0)
    end
    write.log(Turnalllightsoffmessage)
end

function door.setTable(name, logname, side, color, pass)
    doors[name] = {}
    doors[name]["name"] = name
    doors[name]["logname"] = logname
    doors[name]["side"] = side
    doors[name]["color"] = color
    doors[name]["pass"] = pass
end

function door.check(door)
    if door == "garage door" then Open = rs.getBundledOutput(Garageopenside, Garageopencolor) Close = rs.getBundledOutput(Garagecloseside, Garageclosecolor)
        if Open == 255 and Close == 0 then State = "opened" end
        if Open == 0 and Close == 255 then State = "closed" end
        modem.send(Sender, Port, State)
        write.log(Checkgaragemessage)
    else
        for _, data in pairs(doors) do
            if door == data["name"] then
                Side = data["side"]
                Color = data["color"]
            end
        end
        local currstate = rs.getBundledOutput(Side, Color)
        if currstate == 0 then State = "closed" end
        if currstate == 255 then State = "opened" end
        modem.send(Sender, Port, State)
        write.log(Checkdoormessage)
    end
end

function door.lockhouse(pass)
    if pass == Lockhousepass then
        rs.setBundledOutput(Garageopenside, Garageopencolor, 0) rs.setBundledOutput(Garagecloseside, Garageclosecolor, 255)
        for _, data in pairs(doors) do
            rs.setBundledOutput(data["side"], data["color"], 0)
        end
        rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 0) rs.setBundledOutput(Alarmenableside, Alarmenablecolor, 255)
        modem.send(Sender, Port, "correct")
        write.log(Lockhousemessage)
    else modem.send(Sender, Port, "wrong")
    end
end

function door.action(door, action, pass)
    if door == "garage door" then
        if pass == Garagepass then
            if action == "open" then rs.setBundledOutput(Garagecloseside, Garageclosecolor, 0) rs.setBundledOutput(Garageopenside, Garageopencolor, 255) modem.send(Sender, Port, "correct", "was opened") alarm.action("deactivate alarm", Alarmpass) write.log(Opengaragemessage) end
            if action == "close" then rs.setBundledOutput(Garageopenside, Garageopencolor, 0) rs.setBundledOutput(Garagecloseside, Garageclosecolor, 255) modem.send(Sender, Port, "correct", "was closed") write.log(Closegaragemessage) end
        else
            modem.send(Sender, Port, "wrong")
            write.log(Actiongaragewrongcodemessage)
        end
    else
        for _, data in pairs(doors) do
            if door == data["name"] then
                Side = data["side"]
                Color = data["color"]
                Doorpass = data["pass"]
            end
        end
        if action == "no" then
        else
            if pass == Doorpass then
                if action == "close" then Strength = 0 end
                if action == "open" then Strength = 255 end
                rs.setBundledOutput(Side, Color, Strength)
                local currstate = rs.getBundledOutput(Side, Color)
                if action == "close" and currstate == 0 then Check = "was closed" write.log(Closedoormessage)
                elseif action == "open" and currstate == 255 then alarm.action("deactivate alarm", Alarmpass) Check = "was opened" write.log(Opendoormessage)
                else Check = "failed" end
                modem.send(Sender, Port, "correct", Check)
            else modem.send(Sender, Port, "wrong")
                write.log(Actiondoorwrongcodemessage)
            end
        end
    end
end

function door.code(door, pass)
    for _, data in pairs(doors) do
        if door == data["name"] then
            Doorpass = data["pass"]
            Side = data["side"]
            Color = data["color"]
        end
    end
    if pass == Doorpass then
        local currstate = rs.getBundledOutput(Side, Color)
        if currstate == 0 then rs.setBundledOutput(Side, Color, 255) write.log(Opendoormessage)
        elseif currstate == 255 then rs.setBundledOutput(Side, Color, 0) write.log(Closedoormessage) end
        modem.send(Sender, Port, "correct")
    else
        modem.send(Sender, Port, "wrong")
        write.log(Actiondoorwrongcodemessage)
    end
end

function alarm.check()
    local currstate = rs.getBundledInput(Alarmside, Alarmcolor)
    if currstate >= 0 then State = "alarm triggered" end
    if currstate == 0 then State = "alarm not triggered" end
    modem.send(Sender, Port, State)
    write.log(Checkalarmmessage)
end

function alarm.action(action, pass)
    if pass == Alarmpass then
        modem.send(Sender, Port, "correct")
        local currstate = rs.getBundledInput(Alarmside , Alarmcolor)
        if currstate >= 0 and action == "disable alarm" then
            rs.setBundledOutput(Alarmenableside, Alarmenablecolor, 0) rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 255)
            if rs.getBundledInput(Alarmside, Alarmcolor) == 0 and rs.getBundledOutput(Alarmresetside, Alarmresetcolor) == 255 and rs.getBundledOutput(Alarmenableside, Alarmenablecolor) == 0 then modem.send(Sender, Port, "correct", "alarm disabled") write.log(Disablealarmmessage) end
        end
        if currstate >= 0 and action == "reset alarm" then
            rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 255) os.sleep(1) rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 0)
            if rs.getBundledInput(Alarmside, Alarmcolor) == 0 then modem.send(Sender, Port, "correct", "alarm reset") write.log(Resetalarmmessage) end
        end
    else
        modem.send(Sender, Port, "wrong")
        write.log(Actionalarmwrongcodemessage)
    end
end

while true do

    local program = nil
    Object = nil
    local action = nil
    local pass = nil


    conf.setlights()
    conf.setdoors()

    modem.open(Port)
    _, _, Sender, _, _, program, Object, action, pass = event.pull("modem_message")

    for _, data in pairs(lights) do
        if Object == data["room"] then
            Logname = data["logname"]
        end
    end

    for _, data in pairs(doors) do
        if Object == data["name"] then
            Logname = data["logname"]
        end
    end

    if Logname == nil then Logname = "" end

    conf.setlogmessage()

    if program == "check server" then modem.send(Sender, Port, "server ok") write.log(Checkedservermessage) end

    if program == "light" then
        if action == nil and Object ~= "turn all off" then light.check(Object)
        elseif Object == "turn all off" then light.turnalloff()
        elseif action ~= nil and Object ~= "turn all off" then light.action(Object, action)
        end
    end

    if program == "door" then
        if action == nil and Object ~= "lock house" then door.check(Object)
        elseif Object == "lock house" then door.lockhouse(pass)
        else door.action(Object, action, pass)
        end
    end

    if program == "alarm" then
        if action == nil then alarm.check()
        else alarm.action(action, pass)
        end
    end

    if program == "code" then
        door.code(Object, pass)
    end

    sign.running(1, 1, 160, 5, Serverrunningmessage)

end
