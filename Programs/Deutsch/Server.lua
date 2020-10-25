local sides = require("sides")
local colors = require("colors")
local conf = {}
local light = {}
local door = {}
local write = {}
local lights = {}
local doors = {}

local Port = 4 -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this server
local Logfile = "/home/log.txt" -- The location where the Logfile will be stored
local Serverrunningmessage = "Der Server läuft gerade" -- The message the server will display while it is running

-- Passcodes (the other ones for the doors are set via the setTable function)
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
local Alarmenablecolor = colors.lime
local Alarmresetside = sides.left
local Alarmresetcolor = colors.lightblue


-- Configuration of the lights and doors
function conf.setlights()
    light.setTable("Esszimmer", sides.front, colors.orange)
end

function conf.setdoors()
    door.setTable("Haustür", sides.left, colors.lime, "1234")
end

function conf.setlogmessage()
    Checkedservermessage = Sender .. "       hat sich mit dem Server verbunden"
    if Object ~= nil then
        Checklightmessage = Sender .. "       hat den Status der Lampe " .. Object .. " abgefragt"
        Turnalllightsoffmessage = Sender .. "       hat in allen Räumen das Licht eingeschaltet"
        Checkdoormessage = Sender .. "       hat den Status der Tür " .. Object .. " abgefragt"
        Checkgaragemessage = Sender .. "       hat den Status des Garagentores abgefragt"
        Actiondoorwrongcodemessage = Sender .. "       hat den flaschen Code eingegeben, um eine Aktion bei der Tür " .. Object .. " auszuführen"
        Checkalarmmessage = Sender .. "       hat den Status des Alarms abgefragt"
        Actiongaragewrongcodemessage = Sender .. "       hat den falschen Code eingegeben, um eine Aktion beim Garagentor auszuführen"
        Actionalarmwrongcodemessage = Sender .. "       hat den falschen Code eingegeben, um eine Aktion beim Alarm auszuführen"
        if SAction ~= nil then
            Actionlightmessage = Sender .. "       hat das Licht im Raum " .. Object .. " " .. SAction
            Actiondoormessage = Sender .. "       hat die Tür " .. Object .. " " .. SAction
            Actiongaragemessage = Sender .. "       hat das Garagentor " .. SAction
            Actionalarmmessage = Sender .. "       hat den Alarm " .. SAction
        end
    end
end

local term = require("term")
local component = require("component")
local rs = component.redstone
local gpu = component.gpu
local modem = component.modem
local event = require("event")
local filesystem = require("filesystem")
local unicode = require("unicode")
local sign = {}

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

-- Functions for the program and the program itself

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

function light.setTable(room, side, color)
    lights[room] = {}
    lights[room]["room"] = room
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
    conf.setlogmessage()
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
    if action == "turn on" and Currstate == 255 then Check = "turned on" SAction = "eingeschaltet"
    else if action == "turn off" and Currstate == 0 then Check = "turned off" SAction = "ausgeschaltet"
    else Check = "failed" end end
    modem.send(Sender, Port, Check)
    conf.setlogmessage()
    write.log(Actionlightmessage)
    SAction = nil
end

function light.turnalloff()
    for _, data in pairs(lights) do
        rs.setBundledOutput(data["side"], data["color"], 0)
    end
    conf.setlogmessage()
    write.log(Turnalllightsoffmessage)
end

function door.setTable(name, side, color, pass)
    doors[name] = {}
    doors[name]["name"] = name
    doors[name]["side"] = side
    doors[name]["color"] = color
    doors[name]["pass"] = pass
end

function door.check(door)
    if door == "garage door" then Open = rs.getBundledOutput(Garageopenside, Garageopencolor) Close = rs.getBundledOutput(Garagecloseside, Garageclosecolor)
        if Open == 255 and Close == 0 then State = "opened" end
        if Open == 0 and Close == 255 then State = "closed" end
        modem.send(Sender, Port, State)
        conf.setlogmessage()
        write.log(Checkgaragemessage)
    else
        for _, data in pairs(doors) do
            if door == data["name"] then
                Side = data["side"]
                Color = data["color"]
            end
        end
        local currstate = rs.getBundledOutput(Side, Color)
        if currstate == 255 then State = "closed" end
        if currstate == 0 then State = "opened" end
        modem.send(Sender, Port, State)
        conf.setlogmessage()
        write.log(Checkdoormessage)
    end
end

function door.action(door, action, pass)
    if door == "garage door" then
        if pass == Garagepass then
            if action == "open" then rs.setBundledOutput(Garagecloseside, Garageclosecolor, 0) rs.setBundledOutput(Garageopenside, Garageopencolor, 255) modem.send(Sender, Port, "correct", "was opened") SAction = "geöffnet" end
            if action == "close" then rs.setBundledOutput(Garageopenside, Garageopencolor, 0) rs.setBundledOutput(Garagecloseside, Garageclosecolor, 255) modem.send(Sender, Port, "correct", "was closed") SAction = "geschlossen" end
            conf.setlogmessage()
            write.log(Actiongaragemessage)
        else
            modem.send(Sender, Port, "wrong")
            conf.setlogmessage()
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
                if action == "close" then Strength = 255 end
                if action == "open" then Strength = 0 end
                rs.setBundledOutput(Side, Color, Strength)
                local currstate = rs.getBundledOutput(Side, Color)
                if action == "close" and currstate == 255 then Check = "was closed" SAction = "geschlossen"
                else if action == "open" and currstate == 0 then Check = "was opened" SAction = "geöffnet"
                else Check = "failed" end end
                modem.send(Sender, Port, "correct", Check)
                conf.setlogmessage()
                write.log(Actiondoormessage)
            else modem.send(Sender, Port, "wrong")
                conf.setlogmessage()
                write.log(Actiondoorwrongcodemessage)
            end
        end
    end
    SAction = nil
end

function alarm.check()
    local currstate = rs.getBundledInput(Alarmside, Alarmcolor)
    if currstate >= 0 then State = "alarm triggered" end
    if currstate == 0 then State = "alarm not triggered" end
    modem.send(Sender, Port, State)
    conf.setlogmessage()
    write.log(Checkalarmmessage)
end

function alarm.action(action, pass)
    if pass == Alarmpass then
        modem.send(Sender, Port, "correct")
        local currstate = rs.getBundledInput(Alarmside , Alarmcolor)
        if currstate >= 0 and action == "disable alarm" then
            rs.setBundledOutput(Alarmenableside, Alarmenablecolor, 0) rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 255)
            if rs.getBundledInput(Alarmside, Alarmcolor) == 0 and rs.getBundledOutput(Alarmresetside, Alarmresetcolor) == 255 and rs.getBundledOutput(Alarmenableside, Alarmenablecolor) == 0 then modem.send(Sender, Port, "correct", "alarm disabled") SAction = "deaktiviert" end
        end
        if currstate >= 0 and action == "reset alarm" then
            rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 255) os.sleep(1) rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 0)
            if rs.getBundledInput(Alarmside, Alarmcolor) == 0 then modem.send(Sender, Port, "correct", "alarm reset") SAction = "zurückgesetzt" end
        end
        conf.setlogmessage()
        write.log(Actionalarmmessage)
    else
        modem.send(Sender, Port, "wrong")
        conf.setlogmessage()
        write.log(Actionalarmwrongcodemessage)
    end
    SAction = nil
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

    if program == "check server" then modem.send(Sender, Port, "server ok") conf.setlogmessage() write.log(Checkedservermessage) end

    if program == "light" then
        if action == nil and Object ~= "turn all off" then light.check(Object) end
        if Object == "turn all off" then light.turnalloff() end
        if action ~= nil and Object ~= "turn all off" then light.action(Object, action)
        end
    end

    if program == "door" then
        if action == nil then door.check(Object)
        else door.action(Object, action, pass)
        end
    end

    if program == "alarm" then
        if action == nil then alarm.check()
        else alarm.action(action, pass)
        end
    end

    sign.running(1, 1, 160, 5, Serverrunningmessage)

end
