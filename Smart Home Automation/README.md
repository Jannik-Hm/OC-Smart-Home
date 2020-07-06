![alt text](https://cdn.ttgtmedia.com/rms/onlineImages/iota-smart_home.jpg)
## These are the Smart Home Automation Programs!
[How to install](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#how-to-install) <br>
[Tips and Tricks](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#tips-and-tricks) <br>
[Fixes and Bugs](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#fixes-and-bugs) <br>
[Problems?](https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/README.md#problems)
<br>

### How to install
If you want to install this program in your Minecraft world, make sure that you got OpenOS, an Internet Card, a Network Card and a Tier 3 Gpu installed. <br>
Then paste the following commands: <br>

Run this command on your server:
> wget -f https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/ServerOS "/home/Smart Server.lua" <br> 
<br>

And run this command on your Client PC (Tablet/Remote Console or Touchscreen PC's):
> wget -f https://github.com/Agent-Husky/OpenComputers/blob/master/Smart%20Home%20Automation/TabletOS "/home/Smart Screen" <br>

PS: Note that if you are using Tablets, the colors wont be as good as with the Remote Console (Tier 3 Tablets use Tier 2 Screens) connected to Servers and you will need to use Wireless Network Cards in your Tablets and your Main Server.
<br>
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
>os.execute(path to your file f.e. "/home/Smart Server.lua")

<br>

### Fixes and Bugs
- [ ] Finishing up this Readme file
- [ ] Finishing up the code
- [x] Starting to program the code

<br>

### Problems?
You have a problem? Go to the [Issues](https://github.com/Agent-Husky/OpenComputers/issues) section and take a look if somebody else has had the same problem before. <br>
If you dont find anybody with the same issue, just [open a new one](https://github.com/Agent-Husky/OpenComputers/issues/new/choose).

[![Watch the video](https://img.youtube.com/vi/v=8IycdrAkHE8&t/maxresdefault.jpg)](https://youtu.be/v=8IycdrAkHE8&t)
