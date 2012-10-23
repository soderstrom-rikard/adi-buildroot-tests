#!/bin/sh

rm -rf /lib/modules
rm -rf /lib/libgfortran*
rm -rf /lib/libthread*
rm -rf /lib/libstdc*

SUBDIR=`ls / | grep -v mnt | grep -v proc | grep -v sys | grep -v usr | grep -v tmp`

for i in $SUBDIR
do
	cp -ar $i /mnt/rootfs
	echo "copy $i finish"
done

mkdir /mnt/rootfs/mnt
mkdir /mnt/rootfs/proc
mkdir /mnt/rootfs/sys
mkdir /mnt/rootfs/usr

echo "copy rootfs done"
