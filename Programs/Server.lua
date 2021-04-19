Sides = require("sides")
Colors = require("colors")
local conf = {}
local light = {}
local door = {}

local pathtoconf = "/home/Serverconf.lua"

dofile(pathtoconf)

for _, data in pairs(Conf.Logmessages) do
    if data[2] == nil then
        data[2] = ""
    end
end

-- Setup of the lights and doors

function conf.setlights()
    for _, data in pairs(Conf.Lights) do
        light.setTable(data[1], data[2], data[3], data[4])
    end
end

function conf.setdoors()
    for _, data in pairs(Conf.Doors) do
        door.setTable(data[1], data[2], data[3], data[4], data[5])
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
local write = {}
local lights = {}
local doors = {}

gpu.setResolution(Conf.Resolution[1], Conf.Resolution[2])
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

sign.running(1, 1, 160, 5, Conf.Serverrunningmessage)
term.setCursor(1, 6)

function write.log(message)
    Log = io.open(Conf.Logfile, "a")
    if filesystem.exists(Conf.Logfile) == true then
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
    modem.send(Sender, Conf.Port, State)
    write.log(Sender .. "       " .. Conf.Logmessages.Checklightmessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Checklightmessage[2])
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
    if action == "turn on" and Currstate == 255 then Check = "turned on" write.log(Sender .. "       " .. Conf.Logmessages.Turnonlightmessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Turnonlightmessage[2])
    else if action == "turn off" and Currstate == 0 then Check = "turned off" write.log(Sender .. "       " .. Conf.Logmessages.Turnofflightmessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Turnofflightmessage[2])
    else Check = "failed" end end
    modem.send(Sender, Conf.Port, Check)
end

function light.turnalloff()
    for _, data in pairs(lights) do
        rs.setBundledOutput(data["side"], data["color"], 0)
    end
    write.log(Sender .. "       " .. Conf.Logmessages.Turnalllightsoffmessage[1])
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
    if door == "garage door" then Open = rs.getBundledOutput(Conf.Garage.Garageopenside, Conf.Garage.Garageopencolor) Close = rs.getBundledOutput(Conf.Garage.Garagecloseside, Conf.Garage.Garageclosecolor)
        if Open == 255 and Close == 0 then State = "opened" end
        if Open == 0 and Close == 255 then State = "closed" end
        modem.send(Sender, Conf.Port, State)
        write.log(Sender .. "       " .. Conf.Logmessages.Checkgaragemessage[1])
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
        modem.send(Sender, Conf.Port, State)
        write.log(Sender .. "       " .. Conf.Logmessages.Checkdoormessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Checkdoormessage[2])
    end
end

function door.lockhouse(pass)
    if pass == Conf.Passcodes.Lockhousepass then
        rs.setBundledOutput(Conf.Garage.Garageopenside, Conf.Garage.Garageopencolor, 0) rs.setBundledOutput(Conf.Garage.Garagecloseside, Conf.Garage.Garageclosecolor, 255)
        for _, data in pairs(doors) do
            rs.setBundledOutput(data["side"], data["color"], 0)
        end
        alarm.action("enable alarm")
        modem.send(Sender, Conf.Port, "correct")
        write.log(Sender .. "       " .. Conf.Logmessages.Lockhousemessage[1])
    else modem.send(Sender, Conf.Port, "wrong")
    end
end

function door.action(door, action, pass)
    if door == "garage door" then
        if pass == Conf.Passcodes.Garagepass then
            if action == "open" then rs.setBundledOutput(Conf.Garage.Garagecloseside, Conf.Garage.Garageclosecolor, 0) rs.setBundledOutput(Conf.Garage.Garageopenside, Conf.Garage.Garageopencolor, 255) modem.send(Sender, Conf.Port, "correct", "was opened") alarm.action("disable alarm", Conf.Passcodes.Alarmpass) write.log(Sender .. "       " .. Conf.Logmessages.Opengaragemessage[1]) end
            if action == "close" then rs.setBundledOutput(Conf.Garage.Garageopenside, Conf.Garage.Garageopencolor, 0) rs.setBundledOutput(Conf.Garage.Garagecloseside, Conf.Garage.Garageclosecolor, 255) modem.send(Sender, Conf.Port, "correct", "was closed") write.log(Sender .. "       " .. Conf.Logmessages.Closegaragemessage[1]) end
        else
            modem.send(Sender, Conf.Port, "wrong")
            write.log(Sender .. "       " .. Conf.Logmessages.Actiongaragewrongcodemessage[1])
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
                if action == "close" and currstate == 0 then Check = "was closed" write.log(Sender .. "       " .. Conf.Logmessages.Closedoormessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Closedoormessage[2])
                elseif action == "open" and currstate == 255 then alarm.action("disable alarm", Conf.Passcodes.Alarmpass) Check = "was opened" write.log(Sender .. "       " .. Conf.Logmessages.Opendoormessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Opendoormessage[2])
                else Check = "failed" end
                modem.send(Sender, Conf.Port, "correct", Check)
            else modem.send(Sender, Conf.Port, "wrong")
                write.log(Sender .. "       " .. Conf.Logmessages.Actiondoorwrongcodemessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Actiondoorwrongcodemessage[2])
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
        if currstate == 0 then rs.setBundledOutput(Side, Color, 255) write.log(Sender .. "       " .. Conf.Logmessages.Opendoormessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Opendoormessage[2]) alarm.action("disable alarm", Conf.Passcodes.Alarmpass)
        elseif currstate == 255 then rs.setBundledOutput(Side, Color, 0) write.log(Sender .. "       " .. Conf.Logmessages.Closedoormessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Closedoormessage[2]) end
        modem.send(Sender, Conf.Port, "correct")
    else
        modem.send(Sender, Conf.Port, "wrong")
        write.log(Sender .. "       " .. Conf.Logmessages.Actiondoorwrongcodemessage[1] .. " " .. Logname .. " " .. Conf.Logmessages.Actiondoorwrongcodemessage[2])
    end
end

function alarm.check()
    local currstate = rs.getBundledInput(Conf.Alarm.Alarmside, Conf.Alarm.Alarmcolor)
    if currstate >= 0 then State = "alarm triggered" end
    if currstate == 0 then State = "alarm not triggered" end
    modem.send(Sender, Conf.Port, State)
    write.log(Sender .. "       " .. Conf.Logmessages.Checkalarmmessage[1])
end

function alarm.action(action, pass, modemuse)
    if action == "enable alarm" then
        rs.setBundledOutput(Conf.Alarm.Alarmresetside, Conf.Alarm.Alarmresetcolor, 0) rs.setBundledOutput(Conf.Alarm.Alarmenableside, Conf.Alarm.Alarmenablecolor, 255)
    else
        if pass == Conf.Passcodes.Alarmpass then
            modem.send(Sender, Conf.Port, "correct")
            if action == "disable alarm" then
                rs.setBundledOutput(Conf.Alarm.Alarmenableside, Conf.Alarm.Alarmenablecolor, 0) rs.setBundledOutput(Conf.Alarm.Alarmresetside, Conf.Alarm.Alarmresetcolor, 255)
                if rs.getBundledInput(Conf.Alarm.Alarmside, Conf.Alarm.Alarmcolor) == 0 and rs.getBundledOutput(Conf.Alarm.Alarmresetside, Conf.Alarm.Alarmresetcolor) == 255 and rs.getBundledOutput(Conf.Alarm.Alarmenableside, Conf.Alarm.Alarmenablecolor) == 0 then 
                    if modemuse then modem.send(Sender, Conf.Port, "correct", "alarm disabled") write.log(Sender .. "       " .. Conf.Logmessages.Disablealarmmessage[1]) end
                end
            end
            if action == "reset alarm" then
                rs.setBundledOutput(Conf.Alarm.Alarmresetside, Conf.Alarm.Alarmresetcolor, 255) os.sleep(1) rs.setBundledOutput(Conf.Alarm.Alarmresetside, Conf.Alarm.Alarmresetcolor, 0)
                if rs.getBundledInput(Conf.Alarm.Alarmside, Conf.Alarm.Alarmcolor) == 0 then modem.send(Sender, Conf.Port, "correct", "alarm reset") write.log(Sender .. "       " .. Conf.Logmessages.Resetalarmmessage[1]) end
            end
            modem.broadcast(Conf.Port, "alarm reset")
        else
            modem.send(Sender, Conf.Port, "wrong")
            write.log(Sender .. "       " .. Conf.Logmessages.Actionalarmwrongcodemessage[1])
        end
    end
end

while true do

    Eventtype = nil
    local program = nil
    Object = nil
    local action = nil
    local pass = nil
    local side = nil

    conf.setlights()
    conf.setdoors()

    modem.open(Conf.Port)
    Eventtype, _, Sender, _, Strength, program, Object, action, pass = event.pullMultiple("modem_message", "redstone_changed")
    local side, color  = Sender, program

    if Eventtype == "redstone_changed" and Strength > 0 then
        if side == Conf.Alarm.Alarmside and color == Conf.Alarm.Alarmcolor then
            modem.broadcast(Conf.Port, "alarm triggered")
            write.log(Conf.Logmessages.Alarmtriggeredmessage[1])
        end
        goto skip
    end

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

    if program == "check server" then modem.send(Sender, Conf.Port, "server ok") write.log(Sender .. "       " .. Conf.Logmessages.Checkedservermessage[1])
    elseif program == "light" then
        if action == nil and Object ~= "turn all off" then light.check(Object)
        elseif Object == "turn all off" then light.turnalloff()
        elseif action ~= nil and Object ~= "turn all off" then light.action(Object, action)
        end
    elseif program == "door" then
        if action == nil and Object ~= "lock house" then door.check(Object)
        elseif Object == "lock house" then door.lockhouse(pass)
        else door.action(Object, action, pass)
        end
    elseif program == "alarm" then
        if action == nil then alarm.check()
        else alarm.action(action, pass, true)
        end
    elseif program == "code" then
        door.code(Object, pass)
    end

    ::skip::

    sign.running(1, 1, 160, 5, Conf.Serverrunningmessage)

end
