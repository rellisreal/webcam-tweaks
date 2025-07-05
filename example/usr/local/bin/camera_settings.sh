
#!/bin/bash

# Script made, to automate the painful process of automating the brightness/exposure settings of my Logitech HD Pro Webcam C920.

# Different settings are applied based off time of day.

HOUR=$(date +%H)

if [ $HOUR -ge 6 ] && [ $HOUR -le 18 ]; then
    v4l2-ctl --set-ctrl=auto_exposure=1
    v4l2-ctl --set-ctrl=exposure_time_absolute=300
    v4l2-ctl --set-ctrl=brightness=255
    echo "Daytime settings applied!!!"
else 
    v4l2-ctl --set-ctrl=brightness=255
    v4l2-ctl --set-ctrl=auto_exposure=3
    v4l2-ctl --set-ctrl=exposure_time_absolute=156
    echo "Nighttime settings applied!!!"
fi 

