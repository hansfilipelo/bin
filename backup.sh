#!/bin/bash

LOGGFOLDER=/home/fille/loggar
LOGG=backup.txt
mkdir -p "$LOGGFOLDER"
touch "$LOGGFOLDER/$LOGG"

TMP=/tmp/tmplog.txt
touch $TMP

exec >> $TMP 2>&1

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

source backup.conf

echo "" 
echo "Closing services"
echo "" 
service transmission-daemon stop
service openvpn stop

sleep 60

echo " "
echo "Written by /home/fille/backup.sh"
echo "-------------------------------------"
echo "rsync starting"
date "+%Y-%m-%d %H:%M"

# Backup of main storage
for FS in lagret privat os home
do
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

echo "" 
echo "Starting services"
echo "" 
service openvpn start
service transmission-daemon start


cat $TMP >> "$LOGGFOLDER/$LOGG"
cat $TMP | mail -s "Backup report from lagret" hansfilipelo@gmail.com
rm $TMP

