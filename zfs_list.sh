#!/bin/bash
FS=/tmp/zfs.txt

/sbin/zfs list | head -n 2 > $FS
echo "--" >> $FS
/sbin/zpool status | tail -n 8 | head -n 2 >> $FS

