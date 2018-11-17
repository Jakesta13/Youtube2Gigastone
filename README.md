# Youtube2Gigastone

This script is to allow you to download a bulk of youtube videos to a gigastone device, specifically [This one](http://www.canadiantire.ca/en/pdp/gigastone-5-200mah-power-bank-media-streaming-device-3991491p.html#srp).

This uses [Youtube-DL](https://rg3.github.io/youtube-dl/) for downloading the videos.

## Installation

* Drop this script somewhere, make it executeable.
* Configure the settings inside the script.
* Connect EITHER via WiFi or Ethernet to the Gigastone (Ethernet is faster).
* In the folder of your choosing on the Gigastone device, create a file called "list.txt" and add YouTube Video links at one per line.
* Run it and make a hot beverage, or go to bed .. either one -- duration depends on internet speed and download size.

## Dependancies
* NCFTP
* [Youtube-dl](https://rg3.github.io/youtube-dl/) - Keep this updated.
* Optional - [IFTTT](http://ifttt.com) account, for HTTP requested notifications, disable it via commening the line out, is explained in script.

## Notice
Please keep in mind that if you are running this on a Raspberry Pi it is a really good idea to run it anywhere EXCEPT the SDcard,
this script does a lot of write and deletes (Downloading videos, then deletes them after they are moved).

## To-Do
* add disable option for IFTTT compatibility rather than having to comment it out manually to disable.

The gigastone has a "Security Feature" where the usernames and passwords are spoken over plain-text, I found them out via sniffing for traffic to and
from their app to connect to it offically, it runs a Telnet and and FTP server.
As long as your wireless hotspot password set in the Gigastone device is strong, this shouldn't be too much of a problem. -- This script uses this "Feature" to upload/download over ftp to the device.
