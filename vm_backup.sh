#!/bin/sh

# Defining log
LOG=/home/fille/Loggar/miniserver.txt
touch $LOG
exec >> $LOG 2>&1


echo ""
echo "Starting backup $(date "+%Y-%m-%d %H:%M")"
echo "----------------------------"
# Suspend machines on miniserver
ssh root@miniserver "/suspend.sh"
ssh root@miniserver "cat /tmp/miniserver_suspend.txt"
ssh root@miniserver "rm /tmp/miniserver_suspend.txt"

echo ""
# Backup machines 
scp -r root@miniserver:/vmfs/volumes/830_1/ /mnt/storage/vms/
if [ $? == 0 ]
then
	echo "830_1 succeeded."
else 
	echo "830_1 failed!"
fi

scp -r root@miniserver:/vmfs/volumes/830_2/ /mnt/storage/vms/
if [ $? == 0 ]
then
	echo "830_2 succeeded."
else
	echo "830_2 failed!"
fi

echo ""
# Starting machines on miniserver
ssh root@miniserver "/start.sh"
ssh root@miniserver "cat /tmp/miniserver_start.txt"
ssh root@miniserver "rm /tmp/miniserver_start.txt"
echo "----------------------------"
echo "Backup finished $(date "+%Y-%m-%d %H:%M")"

