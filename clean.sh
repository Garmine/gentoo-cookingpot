#!/bin/bash

set -e

if mount | grep -q $(realpath ./iso); then
	echo "Unmounting iso..."
	umount iso
fi

echo "Deleting work directories..."
rm -rf iso iso-new iso-ori sqfs-new sqfs-ori initrd-ori initrd-new .wip.iso

