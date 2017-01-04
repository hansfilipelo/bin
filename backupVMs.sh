#!/bin/bash

locations="/var/lib/libvirt/images"
VMs=$(virsh -c qemu:///system list | tail -n +3 | grep \n | awk {'print $2'})
remoteHost=10.0.0.5

echo "Snapshoting VMs"
date '+%Y-%m-%d %H:%M'
echo "--------------"


for domain in $VMs
do
    echo "Snapshoting $domain"
    virsh -c qemu:///system "snapshot-create $domain"
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
    echo "Removing snapshots for $domain"
    snapshots=$(virsh -c qemu:///system "snapshot-list $domain" | tail -n +3 | awk '{print $1}')
    for snapshot in $snapshots
    do
        virsh -c qemu:///system snapshot-delete $domain $snapshot
    done
done

echo ""
echo "Done!"
date '+%Y-%m-%d %H:%M'

