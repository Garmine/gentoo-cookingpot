Gentoo Cookingpot
=================

A collection of small scripts to easily edit Gentoo (minimal) install CDs. The
scripts support the extraction of existing ISOs and the recreation of bootable
(MBR) ISOs ready to be written on USB (or other) drives.

## Usage

- Obtain a Gentoo install CD
- Extract using `./extract.sh gentoo.iso`
- Modify files (directory explanations below)
- Create a bootable iso using `./make.sh modded.iso`
- Burn the iso file (preferably using dd)
- Optionally clean the mess using `./clean.sh` (warning: deletes *every* dir!)

Directories:
- iso-ori: original contents of the iso image
- iso-new: modifiable contents of the iso image, the image root and bootloader
- sqfs-ori: original contents of `image.squashfs`
- sqfs-new: modifiable contents of `image.squashfs`, the new root partition
- initrd-ori: original contents of `gentoo.igz`
- initrd-new: modifiable contents of `gentoo.igz`, the new initramfs

Every original directory is copied using `cp -ax --reflink=always` to take
advantage of CoW filesystems such as btrfs. The original directories are then
recursively made read-only to avoid accidental modifications. The original
initrd and squashfs files are zeroed to save space (the extracted contents are
available anyways). The resulting iso file is MBR partitioned ready for
burning. Please note that the generated intermediate files (`gentoo.igz`,
`image.squashfs`) are not deleted to allow debugging in case.

## Depedencies

- Squashfs tools
- XZ
- cpio
- iso tools (mkisofs)
- xorriso (libisoburn)
- syslinux
- usual GNU tools

## TODO

- Prompt user for destruction before extraction
- Prompt user for overwriting of existing isos
- Btrfs detection
- Auto configuration utilities (serials, sshd, etc.)
- Find out something so stuff won't be owned by root
- Delete intermediate files by default
- Option to not delete intermediate files
- Option to only generate part of the iso

## Inspiration

https://forums.gentoo.org/viewtopic-t-580369.html

