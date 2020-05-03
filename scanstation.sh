#!/bin/bash
#
# scanstation with samba server store function
# ============================================
# needed hardware: 
#  * USB scanner 
#  * 1x led gpio output (active high)
#  * 3x button gpio inputi (active low)
# needed software: 
#  * wiringpi (gpio tool)
#  * Scanner: https://wiki.debian.org/Scanner
#  * smbclient, graphicsmagick-imagemagick-compat

SCANTMP="/dev/shm"
#SCANTMP="/tmp/scan"
SMB_USER="username"
SMB_PASS="pass"
SMB_PATH="//192.168.0.1/data" 
#SMB_PATH need pdf subfolder

mkdir $SCANTMP

# 1: status led 
# 7: red button, shutdown
# 2: yellow button, scan
# 3: green button, save
gpio mode 1 out
gpio write 1 0
gpio mode 7 in
gpio mode 7 up
gpio mode 2 in
gpio mode 2 up
gpio mode 3 in
gpio mode 3 up

while true
do
	GPIO=`gpio read 2`
	if [ $GPIO = 0 ]; then
		DATE=`date +%Y%m%d-%H%M%S`
		DAY=`date +%Y%m%d`
		echo run scan ...
		gpio write 1 1
		scanimage -p --mode Color --resolution 150 --format tiff -l 0 -t 0 -x 210 -y 297 > ${SCANTMP}/scan150-${DATE}.tiff
		#convert -rotate 180 -compress jpeg -quality 52 /dev/shm/scan150.tiff /data/pdf/scan-$DATE.pdf
		gpio write 1 0
		echo " done."
	fi
	GPIO=`gpio read 3`
	if [ $GPIO = 0 ]; then
		echo creating und copy pdf ...
		gpio write 1 1
		cd $SCANTMP
		ls scan15-${DAY}*.tiff
		convert -rotate 180 -compress jpeg -quality 52 $(ls scan150-${DAY}*.tiff) scan-${DATE}.pdf
		smbclient ${SMB_PATH} -U ${SMB_USER} -c "cd pdf ; put scan-${DATE}.pdf" ${SMB_PASS} && \
		rm $SCANTMP/scan150-${DAY}*.tiff
		gpio write 1 0
		echo " done."
	fi
	GPIO=`gpio read 7`
	if [ $GPIO = 0 ]; then
		echo shutdown ...
		gpio write 1 1
		halt
	fi
	sleep 1
done
