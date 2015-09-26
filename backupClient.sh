#!/bin/bash

backupHost="server02"
backupUser="fille"
remotePath="/mnt/storage/home"
localPath="/home/fille/"

echo "Starting backup..."
echo $(date '+%Y-%m-%d %H:%M')
echo "---------------"
rsync -raz --update --delete $localPath $backupUser@$backupHost:$remotePath
echo "---------------"
echo "Finished"
echo $(date '+%Y-%m-%d %H:%M')


