#!/bin/bash

LOGG="/home/fille/Loggar/unrar.eloeldh.se"
FROM="/home/unrar.eloeldh.se/cgi-bin/fromFile.txt"
TO="/home/unrar.eloeldh.se/cgi-bin/toFile.txt"
TEMP1="/home/fille/temp1.txt"
TEMP2="/home/fille/temp2.txt"
TEMP3="/home/fille/temp3.txt"
TEMP4="/home/fille/temp4.txt"
QUOTE="/home/unrar.eloeldh.se/cgi-bin/citattecken"
touch $LOGG 
touch $TEMP1
touch $TEMP2
touch $TEMP3
touch $TEMP4
exec >> $LOGG 2>&1

echo ""
echo "---------------------------"
echo "New run"
date "+%Y-%m-%d %H:%M"
echo ""

if [ -s $FROM  ] && [ -s $TO ]
then
	paste $QUOTE $FROM $QUOTE | tr -d '\011' >> $TEMP1 
	paste $QUOTE $TO $QUOTE | tr -d '\011' >> $TEMP2
	
	paste $TEMP1 $TEMP2 >> $TEMP3
	
	while read line
	do
    		echo $line >> $TEMP4
	done <$TEMP3

	while read line
	do
#		/home/fille/scripts/unrar_from_to.sh $line
		echo $line
	done <$TEMP4
else
	echo "Nothing to unrar"
fi

echo "---------------------------"

#rm $FROM
#rm TO
rm $TEMP1
rm $TEMP2
rm $TEMP3
rm $TEMP4

cat /dev/null > $FROM
cat /dev/null > $TO

