-- TODO: Add last config, test it in terminal and edit Screen.lua

Port = 4 -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this server
Green = 0x33DB00
Green2 = 0x33B600
Red = 0xFF0000
Black = 0x000000
White = 0xFFFFFF
Timeout = 10
Timeoutcodepad = 10

Conf = {
    ["Resolution"] = {80, 40},
    ["Port"] = 4,
    ["Green"] = 0x33DB00,
    ["Green2"] = 0x33B600,
    ["Red"] = 0xFF0000,
    ["Black"] = 0x000000,
    ["White"] = 0xFFFFFF,
    ["Timeout"] = 10,
    ["Timeoutcodepad"] = 10,
    ["yes"] = "Ja",
    ["no"] = "Nein",
    ["menu"] = {
        ["lights"] = {
            ["func"] = "lights",
            ["name"] = "Lichter",
            ["miny"] = 2,
            ["minx"] = 3,
            ["maxy"] = 7,
            ["maxx"] = 26,
            ["color"] = Green
        },
        ["doors"] = {
            ["func"] = "doors",
            ["name"] = "Türen",
            ["miny"] = 2,
            ["minx"] = 29,
            ["maxy"] = 7,
            ["maxx"] = 52,
            ["color"] = Green
        },
        ["alarm"] = {
            ["func"] = "alarm",
            ["name"] = "Alarmanlage",
            ["miny"] = 2,
            ["minx"] = 55,
            ["maxy"] = 7,
            ["maxx"] = 78,
            ["color"] = Green
        }
    },
    ["lights"] = {
        -- Light Configuration
        -- {name, func, miny, minx, maxy, maxx, stateonsentence, stateoffsentence, color}
        [1] = {"Garage", "garage", 8, 4, 11, 17, "Das Licht in der Garage ist eingeschaltet!", "Das Licht in der Garage ist ausgeschaltet!", Green},
        [2] = {"Küche", "kitchen", 8, 19, 11, 32, "Das Licht in der Küche ist eingeschaltet!", "Das Licht in der Küche ist ausgeschaltet!", Green},
        [3] = {"Esszimmer", "dining room", 8, 34, 11, 48, "Das Licht im Esszimmer ist eingeschaltet!", "Das Licht im Esszimmer ist ausgeschaltet!", Green},
        [4] = {"Bad unten", "bathroom down", 8, 50, 11, 63, "Das Licht im Bad unten ist eingeschaltet!", "Das Licht im Bad unten ist ausgeschaltet!", Green},
        [5] = {"Büro", "office", 8, 65, 11, 77, "Das Licht im Büro ist eingeschaltet!", "Das Licht im Büro ist ausgeschaltet!", Green},
        [6] = {"Bad oben", "bathroom up", 11, 22, 14, 39, "Das Licht im Bad oben ist eingeschaltet!", "Das Licht im Bad oben ist ausgeschaltet!", Green},
        [7] = {"Kleiderschrank", "wardrobe", 11, 42, 14, 59, "Das Licht im Kleiderschrank ist eingeschaltet!", "Das Licht im Kleiderschrank ist ausgeschaltet!", Green},
        [8] = {"in allen ausschalten", "turn all off", 14, 29, 17, 52, nil, nil, Green},
        ["turnoffsentence"] = "Möchten sie es ausschalten?",
        ["turnedoffsentence"] = "Das Licht wurde ausgeschaltet!",
        ["turnonsentence"] = "Möchten sie es einschalten?",
        ["turnedonsentence"] = "Das Licht wurde eingeschaltet!"
    },
    ["doors"] = {
        -- Door Configuration
        -- {name, door, miny, minx, maxy, maxx, stateopensentence, stateclosesentence, color}
        [1] = {"Haustür", "front door", 8, 15, 11, 38, "Die Haustür ist geöffnet!", "Die Haustür ist geschlossen!", Green},
        [2] = {"Garagentor", "garage door", 8, 43, 11, 66, "Das Garagentor ist geöffnet!", "Das Garagentor ist geschlossen!", Green},
        [3] = {"Haus abschließen", "lock house", 11, 29, 14, 52, "Das Haus wurde abgeschlossen und der Alarm aktiviert!", nil, Green},
        ["opensentence"] = "Möchten sie die Tür öffnen?",
        ["openedsentence"] = "Die Tür wurde geöffnet!",
        ["closesentence"] = "Möchten sie die Tür schließen?",
        ["closedsentence"] = "Die Tür wurde geschlossen!"
    },
    ["alarm"] = {
        -- Alarm Configuration
        ["triggered"] = {
            ["state"] = "Es wurde ein Alarm ausgelöst!"
        },
        ["nottriggered"] = {
            ["state"] = "Es wurde kein Alarm ausgelöst!",
            -- {name, action, miny, minx, maxy, maxx, color, check}
            ["reset"] = {"Alarm zurücksetzen", "reset alarm", 12, 17, 15, 39, Green, "Der Alarm wurde zurückgesetzt!"},
            ["disable"] = {"Alarm deaktivieren", "disable alarm", 12, 41, 15, 63, Green, "Der Alarm wurde deaktiviert!"}
        }
    }
}

return Conf