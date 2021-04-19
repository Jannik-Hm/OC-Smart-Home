Conf = {
    ["Resolution"] = {160, 50},
    ["Port"] = 4, -- The port on which the communication will happen, please use the same in all devices that you want to communicate with this server
    ["Logfile"] = "/home/log.txt", -- The location where the Logfile will be stored
    ["Serverrunningmessage"] = "Der Server läuft gerade", -- The message the server will display while it is running
    ["Passcodes"] = {
        -- Passcodes (the other ones for the doors are set via the Door Configuration)
        ["Lockhousepass"] = "1234",
        ["Garagepass"] = "1234",
        ["Alarmpass"] = "1234"
    },
    ["Logmessages"] = {
        -- ["Name of Logmessage"] = {Part before the name of the object, Part after the name of the object}
        ["Checkedservermessage"] = {"hat sich mit dem Server verbunden"},
        ["Checklightmessage"] = {"hat den Status des Lichtes", "abgefragt"},
        ["Turnalllightsoffmessage"] = {"hat in allen Räumen das Licht eingeschaltet"},
        ["Checkdoormessage"] = {"hat den Status der Tür", "abgefragt"},
        ["Checkgaragemessage"] = {"hat den Status des Garagentores abgefragt"},
        ["Actiondoorwrongcodemessage"] = {"hat den flaschen Code eingegeben, um eine Aktion bei der Tür", "auszuführen"},
        ["Checkalarmmessage"] = {"hat den Status des Alarms abgefragt"},
        ["Actiongaragewrongcodemessage"] = {"hat den falschen Code eingegeben, um eine Aktion beim Garagentor auszuführen"},
        ["Actionalarmwrongcodemessage"] = {"hat den falschen Code eingegeben, um eine Aktion beim Alarm auszuführen"},
        ["Turnonlightmessage"] = {"hat das Licht im Raum", "eingeschaltet"},
        ["Turnofflightmessage"] = {"hat das Licht im Raum", "ausgeschaltet"},
        ["Lockhousemessage"] = {"hat das Haus abgeschlossen"},
        ["Opendoormessage"] = {"hat die Tür", "geöffnet"},
        ["Closedoormessage"] = {"hat die Tür", "geschlossen"},
        ["Opengaragemessage"] = {"hat das Garagentor geöffnet"},
        ["Closegaragemessage"] = {"hat das Garagentor geschlossen"},
        ["Alarmtriggeredmessage"] = {"Der Alarm wurde ausgelöst!"},
        ["Disablealarmmessage"] = {"hat den Alarm deaktiviert"},
        ["Resetalarmmessage"] = {"hat den Alarm zurückgesetzt"}
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
        [1] = {"garage", "Garage", Sides.front, Colors.yellow},
        [2] = {"kitchen", "Küche", Sides.front, Colors.white},
        [3] = {"dining room", "Esszimmer", Sides.front, Colors.orange},
        [4] = {"bathroom down", "Bad unten", Sides.front, Colors.silver},
        [5] = {"office", "Büro", Sides.front, Colors.brown},
        [6] = {"bathroom up", "Bad oben", Sides.front, Colors.cyan},
        [7] = {"wardrobe", "Kleiderschrank", Sides.front, Colors.black}
    },
    ["Doors"] = {
        -- Configuration of the doors
        -- {name, logname, side, color, passcode}
        [1] = {"front door", "Haustür", Sides.left, Colors.lime, "1234"}
    }
}