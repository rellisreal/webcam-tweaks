# Auto-Adjust Camera Settings

### Purpose: 
Script made, to automate the painful process of the brightness/exposure settings of my Logitech HD Pro Webcam C920

Brightness and exposure settings have to be adjusted due to the lighting cycles in my room.

### Function: 
Creates a .SH script under /usr/local/bin, a systemctl service that executes the script. And a timer that executes once per Hour. 

The script itself checks the current hour and will either apply "Day-Time" settings or "Night-Time" settings, based off the hour. 

### Adjustments:
After the installation, directly editing the /usr/localbin/camera_settings.sh script will allow you to customise the v4l2 commands being applied. 
