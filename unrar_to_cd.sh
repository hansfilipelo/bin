#!/bin/bash

FOLDER_FROM=$1
FOLDER_TO=pwd

find "$FOLDER_FROM" -name *.rar >> ~/filelist.txt

FILES=~/filelist.txt

while read line
do
	unrar e $line
done < $FILES

rm $FILES
