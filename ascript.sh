#!/bin/bash
## This script works on my findings of a 'security feature' of the wireles$
## non-privalaged username and password is 'user'
## privalaged username and password is 'root'
## Fun-fact; The gigastone uses Telnet, and you can login as root -- is re$
## Please note: If running on a raspberry pi, keep in mind that you are wr$
## you may want to consider running this on a USB of at-least "8GB", depen$
## https://github.com/Jakesta13

# Specifiy script directory where this script is located, leave it as a peri$
# manually in the current directory. (E.g this script could be used in a c$
SCRIPT_DIR=.

# Specifiy the base direcotry where the vidoes are downloaded, for now this is a workaround.
# WARNING NOTICE: MAKE SURE YOU SPECIFY THE CORRECT DIRECTORY AS IT WILL DELETE ANYTHING THAT ISNT A BASH SCRIPT (.sh)
# Please use inital forward slahes, this is so there is no automated mistakes.
BASE_DIR=.

# Just in-case your gigastone device has a different internal IP, you can $
GIP=192.168.1.2

# Folder to put the videos in gigastone.
# Note: you don't need a inital and a  final forward slash as the script a$
# Bonus: default location is on the SDcard, you'll have to do some looking$
GDIR=Youtube

# IFTTT Private Key and Applet name.
# You can use IFTTT to get a notification when the download is done, but y$
# and create an "Applet" called "Webhooks" -- You also need to find your p$
# You can disable or change the http request at the bottom of the script, $
IFTTT_KEY=
IFTTT_Applet=

#### #### #### ####

if ping -I eth0 -c 1 -W 5 ${GIP} >/dev/null; then
  echo "we have connectivity"
  wget -O "list.txt" ftp://user:user@${GIP}/SD/.sda1/${GDIR}/list.txt
  sleep 1
  youtube-dl -a list.txt
  rm *.part
  rename 's/[^a-zA-Z0-9 .]//g' *.mp4
  rename 's/[^a-zA-Z0-9 .]//g' *.webm
  ncftpput -u user -p user ${GIP} /SD/.sda1/${GDIR}/ *
  sleep 0.5
  ls -lSh > "ADDED-`date +'%Y-%m-%d'`.txt"
  find ${BASE_DIR} ! -name "*.sh" -type f -delete
else
  sleep 5
  exec ${SCRIPT_DIR}/ascript.sh
fi
sleep 1
#Sends a HTTP request to IFTTT, to disable the feature, comment it out.
#If you want the HTTP request to be sent elseware, change the URL below.
curl -X POST https://maker.ifttt.com/trigger/${IFTTT_Applet}/with/key/${IFTTT_KEY}
sleep 0.5
curl http://${GIP}/cgi-bin/gpoweroff > /dev/null
sleep 5
exec ${SCRIPT_DIR}/ascript.sh
exit
