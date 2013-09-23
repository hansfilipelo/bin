#!/bin/bash

FOLDER_FROM=$1
FOLDER_TO=pwd
touch ~/filelist.txt

find "$FOLDER_FROM" -name *.avi > ~/filelist.txt
find "$FOLDER_FROM" -name *.mkv >> ~/filelist.txt

FILES=~/filelist.txt

while read line
do
	cp $line ./
done < $FILES

rm $FILES
