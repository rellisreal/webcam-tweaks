#!/bin/bash

#Check Root Perms
if [[ "$EUID" = 0 ]]; then
    break
#Obtain sudo privilege    
else
  /bin/echo "Re-execute script with sudo"
  exit 1 
fi

#Create systemmd files 
/bin/echo "Creating camera_settings.sh and moving into /usr/local/bin"
sudo /bin/echo '
#!/bin/bash

# Script made, to automate the painful process of automating the brightness/exposure settings of my Logitech HD Pro Webcam C920.

# Different settings are applied based off time of day.

HOUR=$(date +%H)

if [ $HOUR -ge 6 ] && [ $HOUR -le 18 ]; then
    v4l2-ctl --set-ctrl=auto_exposure=1
    v4l2-ctl --set-ctrl=exposure_time_absolute=300
    v4l2-ctl --set-ctrl=brightness=255
    v4l2-ctl --set-ctrl=gain=50
    v4l2-ctl --set-ctrl=contrast=150
    echo "Daytime settings applied!!!"
else 
    v4l2-ctl --set-ctrl=brightness=255
    v4l2-ctl --set-ctrl=auto_exposure=3
    v4l2-ctl --set-ctrl=exposure_time_absolute=156
    v4l2-ctl --set-ctrl=gain=0
    v4l2-ctl --set-ctrl=contrast=128
    echo "Nighttime settings applied!!!"
fi 
' > /usr/local/bin/camera_settings.sh 


/bin/echo "Creating camera-settings.service and moving it into /etc/systemd/system"
sudo /bin/echo ' 
[Unit]
Description=Adjust Camera Settings Using v4l2-ctl
After=multi-user.target 
Documentation = man::v4l2-ctl(1)

[Service]
Type=oneshot
ExecStart=/bin/bash /usr/local/bin/camera_settings.sh 

[Install]
WantedBy=multi-user.target 
' > /etc/systemd/system/camera-settings.service 

/bin/echo "Creating camera-settings.timer and moving it into /etc/systemd/system"
sudo /bin/echo ' 
[Unit]
Description=Update camera settings hourly

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
' > /etc/systemd/system/camera-settings.timer


#Run/Enable the service
$(systemctl enable "camera-settings.service") 
$(systemctl start "camera-settings.service") 

#Run/Enable the timer 
$(systemctl enable "camera-settings.timer") 
$(systemctl start "camera-settings.timer") 


