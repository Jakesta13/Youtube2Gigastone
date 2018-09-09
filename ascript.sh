#!/bin/bash
## This script works on my findings of a 'security feature' of the wireless SDcard reader "Gigastone"
## non-privalaged username and password is 'user'
## privalaged username and password is 'root'
## Fun-fact; The gigastone uses Telnet, and you can login as root -- is readonly though.
## Please note: If running on a raspberry pi, keep in mind that you are writing to the SD card every time,
## you may want to consider running this on a USB of at-least "8GB", depending on what you use-case is (E.g 5Min videos vs 30Min videos).
## https://github.com/Jakesta13
### Settings

# Specifiy base directory where this script is located, leave it as a period if you only plan to start the script
# manually in the current directory. (E.g this script could be used in a cron timer, or in rc.local)
BASE_DIR=.

# Just in-case your gigastone device has a different internal IP, you can adjust here.
GIP=192.168.1.2

# Folder to put the videos in gigastone.
# Note: you don't need a inital and a  final forward slash as the script adds it as a prefix and suffix.
# Bonus: default location is on the SDcard, you'll have to do some looking to have it on a USB -- Gigastone isnt too reliable on USBs though.
GDIR=Youtube

# IFTTT Private Key and Applet name.
# You can use IFTTT to get a notification when the download is done, but you need to set up an account with them
# and create an "Applet" called "Webhooks" -- You also need to find your private key in the documentation for it.
# You can disable or change the http request at the bottom of the script, see the comment.
IFTTT_KEY=
IFTTT_Applet=

if ping -I eth0 -c 1 -W 5 ${GIP} >/dev/null; then
  echo "we have connectivity"
  wget -O "list.txt" ftp://user:user@${GIP}/SD/.sda1/${GDIR}/list.txt
  sleep 1
  youtube-dl -a list.txt
  rm *.part
  rename 's/[^a-zA-Z0-9 .]//g' *.mp4
  ncftpput -u user -p user ${GIP} /SD/.sda1/${GDIR}/ *
  rm *.mp4 *.txt
else
  sleep 5
  exec ${BASE_DIR}/ascript.sh
fi
sleep 1
curl http://${GIP}/cgi-bin/gpoweroff > /dev/null
sleep 0.5
#Sends a HTTP request to IFTTT, to disable the feature, comment it out.
#If you want the HTTP request to be sent elseware, change the URL below.
curl -X POST https://maker.ifttt.com/trigger/${IFTTT_APPLET}/with/key/${IFTTT_KEY}
sleep 5
exec ${BASE_DIR}/ascript.sh
exit
