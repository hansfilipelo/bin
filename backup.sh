#!/bin/bash

service=/usr/sbin/service
# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

source backup.conf

#echo "" 
#echo "Closing services"
#echo "" 
#$service transmission-daemon stop
#$service openvpn stop

echo " "
echo "Written by /home/fille/backup.sh"
echo "-------------------------------------"
echo "rsync starting"
date "+%Y-%m-%d %H:%M"

# Backup of main storage
for FS in lagret privat os home
do
	echo "$FS"
	rsync -q -a --update --delete --exclude=".*" /mnt/storage/$FS root@$REMOTEHOST:/mnt/storage
	
	if [ $? == 0 ]
	then
		echo "$FS complete"
	else
		echo "$FS FAILED!"
	fi
done

# backup configuration


echo "Backup finished"
date "+%Y-%m-%d %H:%M"
echo "-------------------------------------"

#echo "" 
#echo "Starting services"
#echo "" 
#$service openvpn start
#$service transmission-daemon start

