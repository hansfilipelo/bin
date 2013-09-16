#!/bin/bash

LOGG=/home/fille/Loggar/backup_conf.txt

echo " " >> $LOGG
echo "Written by /home/fille/backup_conf.sh" >> $LOGG
echo "------------------------------------------------" >> $LOGG
echo "Configuration syncing now" >> $LOGG
date "+%Y-%m-%d %H:%M" >> $LOGG

echo "" >> $LOGG
echo "Stopping services" >> $LOGG
#ssh root@lagret "service plexmediaserver stop" >> $LOGG
#ssh root@lagret "service netatalk stop" >> $LOGG
ssh root@lagret "/etc/init.d/samba stop" >> $LOGG
#ssh root@lagret "service transmission-daemon stop" >> $LOGG
#ssh root@lagret "service openvpn stop" >> $LOGG
echo "" >> $LOGG

# Replicate config files to lagret
#rsync -q -r /etc/netatalk/* root@lagret:/etc/netatalk/ >> $LOGG
rsync -q -r /etc/samba/* root@lagret:/etc/samba/ >> $LOGG
rsync -q -r /var/lib/plexmediaserver/* root@lagret:/var/lib/plexmediaserver/ >> $LOGG
rsync -q -r /etc/transmission-daemon/* root@lagret:/etc/transmission-daemon/ >> $LOGG
rsync -q -r /etc/openvpn/* root@lagret:/etc/openvpn/ >> $LOGG

if [ $? == 0 ]
then
	echo "Conf synced" >> $LOGG
else
	echo "CONF FAILED!" >> $LOGG
fi

# Backup of homes (including Plex media library)
rsync -q -a --exclude '.bash_history' /home/* root@lagret:/home/ >> $LOGG

if [ $? == 0 ]
then
        echo "Homes complete" >> $LOGG
else
        echo "HOMES FAILED!" >> $LOGG
fi

echo "" >> $LOGG
echo "Starting services" >> $LOGG
#ssh root@lagret "service plexmediaserver start" >> $LOGG
#ssh root@lagret "service netatalk start" >> $LOGG
ssh root@lagret "/etc/init.d/samba start" >> $LOGG
#ssh root@lagret "service transmission-daemon start" >> $LOGG
#ssh root@lagret "service openvpn start" >> $LOGG
echo "" >> $LOGG

date "+%Y-%m-%d %H:%M" >> $LOGG
echo "------------------------------------------------" >> $LOGG
