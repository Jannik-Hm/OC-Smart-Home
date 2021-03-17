Green = 0x33DB00
Green2 = 0x33B600
Red = 0xFF0000
Black = 0x000000
White = 0xFFFFFF

Conf = {
    ["Resolution"] = {80, 40},
    ["Port"] = 4, -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this Client
    ["Timeout"] = 10,
    ["Timeoutcodepad"] = 10,
    ["yes"] = "Yes",
    ["no"] = "No",
    ["menu"] = {
        ["lights"] = {
            ["func"] = "lights",
            ["name"] = "Lights",
            ["miny"] = 2,
            ["minx"] = 3,
            ["maxy"] = 7,
            ["maxx"] = 26,
            ["color"] = Green
        },
        ["doors"] = {
            ["func"] = "doors",
            ["name"] = "Doors",
            ["miny"] = 2,
            ["minx"] = 29,
            ["maxy"] = 7,
            ["maxx"] = 52,
            ["color"] = Green
        },
        ["alarm"] = {
            ["func"] = "alarm",
            ["name"] = "Alarm",
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
        [1] = {"Garage", "garage", 8, 4, 11, 17, "The light in the garage is turned on!", "The light in the garage is turned off!", Green},
        [2] = {"Kitchen", "kitchen", 8, 19, 11, 32, "The light in the kitchen is turned on!", "The light in the kitchen is turned off!", Green},
        [3] = {"Dining Room", "dining room", 8, 34, 11, 48, "The light in the dining room is turned on!", "The light in the dining room is turned off!", Green},
        [4] = {"Bath 1F", "bathroom down", 8, 50, 11, 63, "The light in the bath 1F is turned on!", "The light in the bath 1F is turned off!", Green},
        [5] = {"Office", "office", 8, 65, 11, 77, "The light in the office is turned on!", "The light in the office is turned off!", Green},
        [6] = {"Bath 2F", "bathroom up", 11, 22, 14, 39, "The light in the bath 2F is turned on!", "The light in the bath 2F is turned off!", Green},
        [7] = {"Wardrobe", "wardrobe", 11, 42, 14, 59, "The light in the wardrobe is turned on!", "The light in the wardrobe is turned off!", Green},
        [8] = {"Turn all off", "turn all off", 14, 29, 17, 52, nil, nil, Green},
        ["turnoffsentence"] = "Do you want to turn it off?",
        ["turnedoffsentence"] = "The light was turned off!",
        ["turnonsentence"] = "Do you want to turn it on?",
        ["turnedonsentence"] = "The light was turned on!"
    },
    ["doors"] = {
        -- Door Configuration
        -- {name, door, miny, minx, maxy, maxx, stateopensentence, stateclosesentence, color}
        [1] = {"Front Door", "front door", 8, 15, 11, 38, "The front door is open!", "The front door is closed!", Green},
        [2] = {"Garage door", "garage door", 8, 43, 11, 66, "The garage door is open!", "The garage door is closed!", Green},
        [3] = {"Lock House", "lock house", 11, 29, 14, 52, "The House was locked and the alarm is activated", nil, Green},
        ["opensentence"] = "Do you want to open the door?",
        ["openedsentence"] = "The door was opened!",
        ["closesentence"] = "Do you want to close the door?",
        ["closedsentence"] = "The door was closed!"
    },
    ["alarm"] = {
        -- Alarm Configuration
        ["triggered"] = {
            ["state"] = "An alarm was triggered!",
            -- {name, action, miny, minx, maxy, maxx, color, check}
            ["reset"] = {"Reset Alarm", "reset alarm", 12, 17, 15, 39, Green, "The Alarm was reset!"},
            ["disable"] = {"Disable Alarm", "disable alarm", 12, 41, 15, 63, Green, "The alarm was disabled!"}
        },
        ["nottriggered"] = {
            ["state"] = "No alarm was triggered!"
        }
    }
}

return Conf