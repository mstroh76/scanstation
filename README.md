# scanstation
Simply scan station for SBC (NanoPi NEO) with samba fileserver store function
3 button control and simply led feedback

##  Needs
### Hardware
  * SBC computer like NanoPi, Orange Pi or Raspberry Pi 
  * USB scanner 
  * 1x led gpio output (active high)
  * 3x button gpio input (active low)
  
### Software 
  * wiringpi (gpio tool)
  * Scanner: https://wiki.debian.org/Scanner
  * smbclient, graphicsmagick-imagemagick-compat
  
##  Install
  * Store shell script in /usr/local/bin
  * Execute script in rc.local ( /usr/local/bin/scanstation & )
  
