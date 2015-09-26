#!/bin/bash

backupHost="server02"
backupUser="fille"
remotePath="/mnt/storage/home"
localPath="/home/fille/"
excludeList="/home/fille/src/bin/backup.exclude"

echo "Starting backup..."
echo $(date '+%Y-%m-%d %H:%M')
echo "---------------"
rsync -raz --update --delete --exclude-from $excludeList $localPath $backupUser@$backupHost:$remotePath
echo "---------------"
echo "Finished"
echo $(date '+%Y-%m-%d %H:%M')


