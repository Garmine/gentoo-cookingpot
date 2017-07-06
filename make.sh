#!/bin/bash

set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 image.iso"
	exit 1
fi

if [ -e $1 ]; then
	echo "$1 already exists!"
	# TODO prompt for overwrite
	exit 1
fi

renice -n 19 $$



echo
echo "-------------------------------------------------------------------------------"
echo "Making squashfs..."
rm -f iso-new/image.squashfs
mksquashfs sqfs-new/ iso-new/image.squashfs



echo
echo "-------------------------------------------------------------------------------"
echo "Making initrd..."
rm -f iso-new/isolinux/gentoo.igz
( 
	cd initrd-new
	find . \
		| cpio --quiet --dereference -o -H newc \
		| xz -9 --check=crc32 \
		> ../iso-new/isolinux/gentoo.igz
)



echo
echo "-------------------------------------------------------------------------------"
echo "Making ISO image..."
rm -f .wip.iso
(
	cd iso-new
	xorriso -as mkisofs \
		-D -R -J -joliet-long -l \
		-b isolinux/isolinux.bin \
		-c isolinux/boot.cat \
		-iso-level 3 -no-emul-boot -partition_offset 16 -boot-load-size 4 -boot-info-table \
		-isohybrid-mbr /usr/lib/syslinux/bios/isohdpfx.bin \
		-o ../.wip.iso .
)
mv .wip.iso $1



echo
echo "-------------------------------------------------------------------------------"
echo "Done."

