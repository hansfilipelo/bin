#!/bin/bash

locations="/var/lib/libvirt/images /ssd2"
VMs=$(virsh -c qemu:///system list | tail -n +3 | grep \n | awk {'print $2'})
remoteHost=10.0.0.5

echo "Shutting down VMs"
date '+%Y-%m-%d %H:%M'
echo "--------------"


for domain in $VMs
do
	virsh -c qemu:///system shutdown $domain
done

# Wait for VMs to shutdown. 
sleep 10

echo ""
echo "Rsyncing VMs"
date '+%Y-%m-%d %H:%M'
echo "--------------"

for location in $locations
do
	rsync -raz --update --delete $location $remoteHost:/mnt/storage/vms/
done


echo ""
echo "Starting VMs"
date '+%Y-%m-%d %H:%M'
echo "--------------"


for domain in $VMs
do
	virsh -c qemu:///system start $domain
done

echo ""
echo "Done!"
date '+%Y-%m-%d %H:%M'

