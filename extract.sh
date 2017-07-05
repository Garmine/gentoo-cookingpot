#!/bin/bash

set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 image.iso"
	exit 1
fi

# TODO prompt user for destruction

renice -n 19 $$



echo
echo "-------------------------------------------------------------------------------"
echo "Extracting ISO image..."
rm -rf iso
mkdir iso iso-ori iso-new
mount -oloop,ro "$1" iso/
cp -a iso/* iso-ori/
umount iso
rm -rf iso
cp -ax --reflink=always iso-ori/. iso-new



echo
echo "-------------------------------------------------------------------------------"
echo "Extracting squashfs..."
rm -rf sqfs-ori sqfs-new
mkdir sqfs-ori sqfs-new
unsquashfs -f -d sqfs-ori/ iso-ori/image.squashfs
echo -n > iso-ori/image.squashfs
cp -ax --reflink=always sqfs-ori/. sqfs-new



echo
echo "-------------------------------------------------------------------------------"
echo "Extracting initrd..."
rm -rf initrd-ori initrd-new
mkdir initrd-ori initrd-new
( cd initrd-ori; unxz < ../iso-ori/isolinux/gentoo.igz | cpio -idv )
echo -n > iso-ori/isolinux/gentoo.igz
cp -ax --reflink=always initrd-ori/. initrd-new



echo
echo "-------------------------------------------------------------------------------"
echo "Making original files read-only..."
chmod -R 400 iso-ori sqfs-ori initrd-ori



echo
echo "-------------------------------------------------------------------------------"
echo "Done."

