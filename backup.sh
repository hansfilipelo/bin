#!/bin/bash

LOGG=/home/fille/Loggar/backup.txt
touch $LOGG
exec >> $LOGG 2>&1

echo " "
echo "Written by /home/fille/backup.sh"
echo "-------------------------------------"
echo "rsync starting"
date "+%Y-%m-%d %H:%M"

# Backup of main storage
for FS in lagret privat os
do
	rsync -q -a --update --delete --exclude=".*" /mnt/storage/$FS/* root@lagret:/mnt/storage/$FS/
	
	if [ $? == 0 ]
	then
		echo "$FS complete"
	else
		echo "$FS FAILED!"
	fi
done

echo "Backup finished"
date "+%Y-%m-%d %H:%M"
echo "-------------------------------------"

