#!/bin/bash

FOLDER_FROM=$1
FOLDER_TO=$2
LOGG="/home/fille/Loggar/unrar.eloeldh.se"
touch $LOGG
exec >> $LOGG 2>&1

echo $FOLDER_FROM
echo $FOLDER_TO

# If folder doesn't exist - create it
mkdir -p $FOLDER_TO

find $FOLDER_FROM -name *.avi > /home/fille/filelist.txt
find $FOLDER_FROM -name *.mkv > /home/fille/filelist.txt

FILES=/home/fille/filelist.txt

cd $FOLDER_TO

while read line
do
	cp $line ./
done < $FILES

rm $FILES

