#!/bin/sh

# Define variables
VMLIST=/tmp/vmlist.txt
touch $VMLIST

LOG=/tmp/miniserver_suspend.txt
touch $LOG
exec > $LOG 2>&1


# Gets id of all running VMs
vim-cmd vmsvc/getallvms | tail -n +2 > $VMLIST

while read line
do
	vim-cmd vmsvc/power.suspend $(echo $line | awk '{print $1}')
	if [ $? == 0 ]
	then
		echo "Successfully suspended $(echo $line | awk '{print $2}') "
	else
		echo "Suspending $(echo $line | awk '{print $2}') failed!"
	fi
done < $VMLIST

rm $VMLIST

