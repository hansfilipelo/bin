#!/bin/bash

FOLDER_FROM=$1
FOLDER_TO=pwd

find "$FOLDER_FROM" -name *.avi >> ~/filelist.txt
find "$FOLDER_FROM" -name *.mkv >> ~/filelist.txt

FILES=~/filelist.txt

while read line
do
	sudo mv $line ./
done < $FILES

rm $FILES
