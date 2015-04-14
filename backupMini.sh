#!/bin/bash

#tmpfile=/tmp/minibackup.txt
#touch $TMP
#exec >> $TMP 2>&1


echo "Starting backup..."
echo $(date '+%Y-%m-%d %H:%M')
echo "---------------"
rsync -raz --update --delete --exclude "Copy" fille@10.0.0.25:~ /mnt/storage/home
echo "---------------"
echo "Finished"
echo $(date '+%Y-%m-%d %H:%M')

#cat $TMP | mail -s "minibackup report from $(hostname)" hansfilipelo@gmail.com
#rm $TMP

