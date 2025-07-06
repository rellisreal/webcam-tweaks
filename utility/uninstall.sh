#!/bin/bash 

#Check Root Perms
if [[ "$EUID" = 0 ]]; then
  break
#Obtain sudo privilege    
else
  /bin/echo "Re-execute script with sudo"
  exit 1 
fi
scriptpath="/usr/local/bin/camera_settings.sh" 
systempath='/etc/systemd/system/camera-settings.service'
timerpath='/etc/systemd/system/camera-settings.timer'
declare -a FOUND_ITEMS=()

systemname=$(basename "$systempath"); timername=$(basename "$timerpath");scriptname=$(basename "$scriptpath")
test -f "$systempath" && FOUND_ITEMS+=($systempath)
test -f "$timerpath" && FOUND_ITEMS+=($timerpath) 
test -f "$scriptpath" && FOUND_ITEMS+=($scriptpath)

for path in "${FOUND_ITEMS[@]}" 
do
  echo $path
  case "$path" in 
    "$systempath")
      echo "Stopping&Disabling $systemname"
      $(systemctl stop "$systemname"); $(systemctl disable "$systemname") 
      echo "Deleting $systemname"
      rm "$systempath"
      ;; 
    "$timerpath")
      echo "Stopping&Disabling $timername" 
      $(systemctl stop "$timername"); $(systemctl disable "$timername")
      echo "Deleting $timername"
      rm "$timerpath"
      ;;
    "$scriptpath")
      rm "$scriptpath"
      ;;
    *)
       echo -n "Filepath Error $path"
       exit 1
  esac 
done 

systemctl daemon-reload
systemctl reset-failed

exit 0 

