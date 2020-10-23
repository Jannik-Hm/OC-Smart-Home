local sides = require("sides")
local colors = require("colors")
local conf = {}
local light = {}
local door = {}

local Port = 4 -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this server
local Logfile = "/home/log.txt"

-- Passcodes
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
    light.setTable("dining room", sides.front, colors.orange)
end

function conf.setdoors()
    door.setTable("front door", sides.left, colors.lime, "1234")
end

local term = require("term")
local component = require("component")
local rs = component.redstone
local gpu = component.gpu
local modem = component.modem
local event = require("event")
local filesystem = require("filesystem")

gpu.setResolution(160, 50)
term.clear()


local lights = {}
local doors = {}
local alarm = {}
local write = {}


-- Functions for the program and the program itself

function write.log(message)
    if filesystem.exists(Logfile) == true then
        Log = io.open(Logfile, "a")
        Log:write("\n"..message)
    else
        Log = io.open(Logfile, "a")
        Log:write(message)
    end
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
    write.log(Sender .. "       has requested the state of the light " .. room)
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
    if action == "turn on" and Currstate == 255 then Check = "turned on" SAction = "turned on"
    else if action == "turn off" and Currstate == 0 then Check = "turned off" SAction = "turned off"
    else Check = "failed" end end
    modem.send(Sender, Port, Check)
    write.log(Sender .. "       " .. SAction .. " the lights in " .. room)
    SAction = nil
end

function light.turnalloff()
    for _, data in pairs(lights) do
        rs.setBundledOutput(data["side"], data["color"], 0)
    end
    write.log(Sender .. "       turned off the lights in every room")
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
        write.log(Sender.. "       requested the state of the door " .. door)
    end
end

function door.action(door, action, pass)
    if door == "garage door" then
        if pass == Garagepass then
            if action == "open" then rs.setBundledOutput(Garagecloseside, Garageclosecolor, 0) rs.setBundledOutput(Garageopenside, Garageopencolor, 255) modem.send(Sender, Port, "correct", "was opened") SAction = "opened" end
            if action == "close" then rs.setBundledOutput(Garageopenside, Garageopencolor, 0) rs.setBundledOutput(Garagecloseside, Garageclosecolor, 255) modem.send(Sender, Port, "correct", "was closed") SAction = "closed" end
            write.log(Sender .. "       " .. SAction .. " the garage door")
        else
            modem.send(Sender, Port, "wrong")
            write.log(Sender .. "       gave the wrong code to perform action on the garage door")
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
                if action == "close" and currstate == 255 then Check = "was closed" SAction = "closed"
                else if action == "open" and currstate == 0 then Check = "was opened" SAction = "opened"
                else Check = "failed" end end
                modem.send(Sender, Port, "correct", Check)
                write.log(Sender .. "       " .. SAction .. " the door " .. door)
            else modem.send(Sender, Port, "wrong")
                write.log(Sender .. "       gave the wrong code to perform action on the door " .. door)
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
    write.log(Sender .. "       requested the state of the alarm")
end

function alarm.action(action, pass)
    if pass == Alarmpass then
        modem.send(Sender, Port, "correct")
        local currstate = rs.getBundledInput(Alarmside , Alarmcolor)
        if currstate >= 0 and action == "disable alarm" then
            rs.setBundledOutput(Alarmenableside, Alarmenablecolor, 0) rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 255)
            if rs.getBundledInput(Alarmside, Alarmcolor) == 0 and rs.getBundledOutput(Alarmresetside, Alarmresetcolor) == 255 and rs.getBundledOutput(Alarmenableside, Alarmenablecolor) == 0 then modem.send(Sender, Port, "correct", "alarm disabled") SAction = "disabled" end
        end
        if currstate >= 0 and action == "reset alarm" then
            rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 255) os.sleep(1) rs.setBundledOutput(Alarmresetside, Alarmresetcolor, 0)
            if rs.getBundledInput(Alarmside, Alarmcolor) == 0 then modem.send(Sender, Port, "correct", "alarm reset") SAction = "reset" end
        end
        write.log(Sender .. "       " .. SAction .. " the alarm")
    else
        modem.send(Sender, Port, "wrong")
        write.log(Sender .. "       gave a wrong code to perform action on the alarm")
    end
    SAction = nil
end

while true do

    local program = nil
    local object = nil
    local action = nil
    local pass = nil

    conf.setlights()
    conf.setdoors()

    modem.open(Port)

    _, _, Sender, _, _, program, object, action, pass = event.pull("modem_message")

    door.setTable("main door", sides.left, colors.lime)

    if program == "check server" then modem.send(Sender, Port, "server ok") write.log(Sender.."connected to this server") end

    if program == "light" then
        if action == nil and object ~= "turn all off" then light.check(object) end
        if object == "turn all off" then light.turnalloff() end
        if action ~= nil and object ~= "turn all off" then light.action(object, action)
        end
    end

    if program == "door" then
        if action == nil then door.check(object)
        else door.action(object, action, pass)
        end
    end

    if program == "alarm" then
        if action == nil then alarm.check()
        else alarm.action(action, pass)
        end
    end

end