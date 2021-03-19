local component = require("component")
local gpu = component.gpu
local term = require("term")
local unicode = require("unicode") 
local computer = require("computer")

local black = 0x000000

local maxx = 160
local maxy = 50

local yvers = 7
local versnum = 5
local ylang = yvers + versnum + 3
local langnum = 2
local ydown = ylang + langnum + 3

local version = {}
local program = {}
local draw = {}
local lang = {}
local language = {}

function draw.rectangle(miny, minx, maxy, maxx, text)
    gpu.setBackground(black)
    gpu.set(minx, miny, unicode.char(0x2552))
    gpu.set(minx + 1, miny, string.rep(unicode.char(0x2550), maxx - minx - 1))
    gpu.set(maxx, miny, unicode.char(0x2555))
    local frameheight = maxy - miny - 2
    gpu.fill(minx, miny + 1, 1, frameheight, unicode.char(0x2502))
    gpu.fill(maxx, miny + 1, 1, frameheight, unicode.char(0x2502))
    gpu.set(minx, maxy - 1, unicode.char(0x2514))
    gpu.set(minx + 1, maxy - 1, string.rep(unicode.char(0x2500), maxx - minx - 1))
    gpu.set(maxx, maxy - 1, unicode.char(0x2518))
    local y = (miny + maxy) / 2
    local x = math.ceil((maxx - minx - #text) / 2) + minx
    gpu.set(x, y, text)
end

function version.setTable(name, number, link, autorunlink, filename)
    program[name] = {}
    program[name]["name"] = name
    program[name]["number"] = number
    program[name]["link"] = link
    program[name]["autorunlink"] = autorunlink
    program[name]["filename"] = filename
end

function language.setTable(language, number, link)
    lang[language] = {}
    lang[language]["language"] = language
    lang[language]["number"] = number
    lang[language]["link"] = link
end

version.setTable("Server", "1", "https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Server.lua", "https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Profiles/serverprofile.lua", "Server.lua")
version.setTable("Screen", "2", "https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Screen.lua", "https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Profiles/screenprofile.lua", "Screen.lua")
version.setTable("Codepad.lua", "3")

gpu.setResolution(maxx, maxy)
gpu.fill(1, 1, maxx, maxy, " ")
draw.rectangle(1, 1, 6, maxx, "Welcome to the Smart Home Installer!")

gpu.set(2, yvers, "What Service do you want to install?")

gpu.set(2, yvers + 1, "1 for the Server")
gpu.set(2, yvers + 2, "2 for the Screen/Remote Console")
gpu.set(2, yvers + 3, "3 for the Codepad")

term.setCursor(2, yvers + 5)
local answer = io.read()

if answer == "3" then
    ydown = ylang
    else
    gpu.set(2, ylang, "Which language do you want to use?")
        gpu.set(2, ylang + 1, "1 to choose the English language")
        gpu.set(2, ylang + 2, "2, um die deutsche Sprache auszuwählen")

        term.setCursor(2, ylang + 3)
        Langanswer = io.read()

        language.setTable("english", "1", "English.lua")
        language.setTable("german", "2", "Deutsch.lua")
end

for _, data in pairs(program) do
    if answer == data["number"] then
        if answer == "3" then
            gpu.set(2, ydown, "Downloading Codepad.lua...")
            os.execute("wget -f -Q https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Codepad/Codepad.lua /bin/Codepad.lua")
            gpu.set(2, ydown + 1, "Downloading Codepadconf.lua...")
            os.execute("wget -f -Q https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Codepad/Codepadconf.lua /home/Codepadconf.lua")
            gpu.set(2, ydown + 2, "Downloading profile.lua...")
            os.execute("wget -f -Q https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Profiles/codepadprofile.lua /etc/profile.lua")
            gpu.set(2, ydown + 4, "Downloads finished")
            Ydown2 = ydown + 6
        else
            for _, data2 in pairs(lang) do
                if Langanswer == data2["number"] then
                    gpu.set(2, ydown, "Downloading "..data["name"].."...")
                    os.execute("wget -f -Q "..data["link"].." /bin/"..data["filename"])
                    gpu.set(2, ydown + 1, "Downloading Configuration...")
                    os.execute("wget -f -Q " .. "https://raw.githubusercontent.com/Agent-Husky/OC-Smart-Home/publish-code/Programs/Configurations/" .. data.name .. "/" .. data2["link"].. " /home/" .. data.name .. "conf.lua")
                    gpu.set(2, ydown + 2, "Downloading profile.lua...")
                    os.execute("wget -f -Q "..data["autorunlink"].." /etc/profile.lua")
                    gpu.set(2, ydown + 4, "Downloads finished")
                    Ydown2 = ydown + 6
                end
            end
        end
    end
end

gpu.set(2, Ydown2, "Do you want to reboot this machine and start the program? (Y/N)")
term.setCursor(2, Ydown2 + 1)
answer = io.read()
answer = string.upper(answer)

gpu.set(2, Ydown2 + 2, "Thank you for using the Smart Home System made by Agent_Husky.")

term.setCursor(1, Ydown2 + 4)

if answer == "Y" or answer == "YES" then
    gpu.set(2, Ydown2 + 4, "Rebooting...")
    computer.shutdown(true)
end
