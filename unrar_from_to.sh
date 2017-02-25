#!/bin/bash

folder_from=$1
folder_to=$2
files=/tmp/filelist.txt

echo $folder_from
echo $folder_to

# If folder doesn't exist - create it
mkdir -p $folder_to

find $folder_from -name *.rar > $files

cd $folder_to

while read line
do
	unrar e -o- -c- $line
done < $files

rm $files
