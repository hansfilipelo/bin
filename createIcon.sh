#!/bin/sh

#  createIcon.sh
#  
#
#  Created by Hans-Filip Elo on 2013-12-02.
#

if [ -z "$1" -o "$1" == "--help" -o "$1" == "-h" ]
then
	echo " "
    	echo "Usage: "
    	echo "  createIcon.sh FILE.png"
    	echo " "
    	echo "FILE has to be a square formed PNG."
	echo " "
    	exit
fi

INFILE=$1
TEMP="${INFILE//.png/}"
DIR=$TEMP.iconset

mkdir $DIR

# Create necessary PNG-files
sips --resampleWidth 1024 $INFILE --out $DIR/icon_512x512@2x.png

sips --resampleWidth 512 $INFILE --out $DIR/icon_512x512.png
sips --resampleWidth 512 $INFILE --out $DIR/icon_256x256@2x.png

sips --resampleWidth 256 $INFILE --out $DIR/icon_256x256.png
sips --resampleWidth 256 $INFILE --out $DIR/icon_128x128@2x.png

sips --resampleWidth 128 $INFILE --out $DIR/icon_128x128.png

sips --resampleWidth 64 $INFILE --out $DIR/icon_32x32@2x.png

sips --resampleWidth 32 $INFILE --out $DIR/icon_32x32.png
sips --resampleWidth 32 $INFILE --out $DIR/icon_16x16@2x.png

sips --resampleWidth 32 $INFILE --out $DIR/icon_16x16.png

# Convert to icons
iconutil -c icns $DIR

# Remove files not needed
rm -r $DIR
