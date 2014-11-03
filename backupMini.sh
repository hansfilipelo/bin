#!/bin/bash

echo "Starting backup..."
echo $(date '+%Y-%m-%d %H:%M')
echo "---------------"
rsync -raz --update --delete fille@10.0.0.25:~ /mnt/storage/home
echo "---------------"
echo "Finished"
echo $(date '+%Y-%m-%d %H:%M')


