Conf = {
    ["Resolution"] = {160, 50},
    ["Port"] = 4, -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this server
    ["Logfile"] = "/home/log.txt", -- The location where the Logfile will be stored
    ["Serverrunningmessage"] = "The Server is currently running", -- The message the server will display while it is running
    ["Passcodes"] = {
        -- Passcodes (the other ones for the doors are set via the Door Configuration)
        ["Lockhousepass"] = "1234",
        ["Garagepass"] = "1234",
        ["Alarmpass"] = "1234"
    },
    ["Logmessages"] = {
        -- ["Name of Logmessage"] = {Part before the name of the object (object not always used), Part after the name of the object (can be empty)}
        ["Checkedservermessage"] = {"connected to this server"},
        ["Checklightmessage"] = {"has requested the state of the light"},
        ["Turnalllightsoffmessage"] = {"turned off the lights in every room"},
        ["Checkdoormessage"] = {"requested the state of the door"},
        ["Checkgaragemessage"] = {"requested the state of the garage door"},
        ["Actiondoorwrongcodemessage"] = {"gave the wrong code to perform action on the door"},
        ["Checkalarmmessage"] = {"requested the state of the alarm"},
        ["Actiongaragewrongcodemessage"] = {"gave the wrong code to perform action on the garage door"},
        ["Actionalarmwrongcodemessage"] = {"gave a wrong code to perform action on the alarm"},
        ["Turnonlightmessage"] = {"turned on the lights in"},
        ["Turnofflightmessage"] = {"turned off the lights in"},
        ["Lockhousemessage"] = {"locked the house"},
        ["Opendoormessage"] = {"opened the door"},
        ["Closedoormessage"] = {"closed the door"},
        ["Opengaragemessage"] = {"opened the garage door"},
        ["Closegaragemessage"] = {"closed the garage door"},
        ["Disablealarmmessage"] = {"disabled the alarm"},
        ["Resetalarmmessage"] = {"reset the alarm"}
    },
    ["Garage"] = {
        -- Garage Redstoneconfiguration
        ["Garageopenside"] = Sides.left,
        ["Garageopencolor"] = Colors.black,
        ["Garagecloseside"] = Sides.left,
        ["Garageclosecolor"] = Colors.yellow
    },
    ["Alarm"] = {
        -- Alarm Redstoneconfiguration
        ["Alarmside"] = Sides.left,
        ["Alarmcolor"] = Colors.red,
        ["Alarmenableside"] = Sides.left,
        ["Alarmenablecolor"] = Colors.orange,
        ["Alarmresetside"] = Sides.left,
        ["Alarmresetcolor"] = Colors.lightblue
    },
    ["Lights"] = {
        -- Configuration of the lights
        -- {room, logname, side, color}
        [1] = {"garage", "garage", Sides.front, Colors.yellow},
        [2] = {"kitchen", "kitchen", Sides.front, Colors.white},
        [3] = {"dining room", "dining room", Sides.front, Colors.orange},
        [4] = {"bathroom down", "bathroom down", Sides.front, Colors.silver},
        [5] = {"office", "office", Sides.front, Colors.brown},
        [6] = {"bathroom up", "bathroom up", Sides.front, Colors.cyan},
        [7] = {"wardrobe", "wardrobe", Sides.front, Colors.black}
    },
    ["Doors"] = {
        -- Configuration of the doors
        -- {name, logname, side, color, passcode}
        [1] = {"front door", "front door", Sides.left, Colors.lime, "1234"}
    }
}