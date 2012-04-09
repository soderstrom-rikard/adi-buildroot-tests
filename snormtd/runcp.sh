#!/bin/sh

rm -rf /lib/modules
rm -rf /lib/libgfortran*
rm -rf /lib/libthread*
rm -rf /lib/libstdc*

SUBDIR=`ls / | grep -v mnt | grep -v proc | grep -v sys | grep -v usr`

for i in $SUBDIR
do
	cp -ar $i /mnt
	echo "copy $i finish"
done

mkdir /mnt/mnt
mkdir /mnt/proc
mkdir /mnt/sys
mkdir /mnt/usr

echo "copy rootfs done"
