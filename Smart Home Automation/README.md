![alt text](https://cdn.ttgtmedia.com/rms/onlineImages/iota-smart_home.jpg)
## These are the Smart Home Automation Programs!
[How to install](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#how-to-install) <br>
[Tips and Tricks](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#tips-and-tricks) <br>
[Fixes and Bugs](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#fixes-and-bugs)

### How to install
If you want to install this program in your Minecraft world, make sure that you got OpenOs, an Internet Card and a Network Card installed. <br>
Then paste the following commands: <br>

Run this command on your server:
> wget https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/TabletOS "/home/Smart Server.lua" <br> 
<br>

And run this command on your Client (Tablet/Remote Console or Touchscreen PC's)
> wget https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/TabletOS "/home/Smart Screen" <br>
<br>

### Tips and Tricks
If u want the program to autostart after you turned on the computer, you have to edit the profile.lua file in the <i><b>etc</b></i> directory. <br>
To edit the file while you are in the home directory type:
> edit /etc/profile.lua <br> 
<br>

There delete the line:
>dofile("/etc/motd") <br>
<br>

And add the line:
>os.execute(path to your file f.e. "/home/Smart Server")

<br>

### Fixes and Bugs
- [ ] Finishing up this Readme file
- [ ] Finishing up the code
- [x] Starting to program the code

