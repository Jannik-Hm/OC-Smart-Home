local shell = require("shell")
local tty = require("tty")
local fs = require("filesystem")

if tty.isAvailable() then
    if io.stdout.tty then
        io.write("\27[40m\27[37m")
        tty.clear()
    end
end

shell.setAlias("cls", "clear")
shell.setAlias("cp", "cp -i")
shell.setAlias("df", "df -h")

os.setenv("EDITOR", "/bin/edit")
os.setenv("HISTSIZE", "10")
os.setenv("HOME", "/home")
os.setenv("IFS", " ")
os.setenv("MANPATH", "/usr/man:.")
os.setenv("PAGER", "less")
os.setenv("PS1", "\27[40m\27[31m$HOSTNAME$HOSTNAME_SEPARATOR$PWD # \27[37m")
os.setenv("LS_COLORS", "di=0;36:fi=0:ln=0;33:*.lua=0;32")

shell.setWorkingDirectory(os.getenv("HOME"))

local home_shrc = shell.resolve(".shrc")
if fs.exists(home_shrc) then
    loadfile(shell.resolve("source", "lua"))(home_shrc)
end

os.execute("/bin/Codepad.lua")
