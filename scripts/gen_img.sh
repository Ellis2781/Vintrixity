#!/bin/sh

# Requires you to be out of a docker contiainer and root privillage.

# Here is the general process of making a bootable image.
# First an iso file is made.
# Second, the iso file is partitioned with an EFI partition (ESP: /System/boot/) and a larger linux root partition
# Third, the EFI iso partition is formatted with the FAT file system and the root partition is formatted with ext4.
# Fourth, the partitions are mounted onto the disk
# Fith, the files in the build are copied onto the iso image.
# Lastly, the iso is unmounted and you can boot into the system using the simulate script or qemu.

while true
do
	read -r -p "This script will require root privilege. Do you wish to continue? [Y/n]" CONTINUE

	case $CONTINUE in
	      [yY][eE][sS]|[yY])
		    read "What size should the image be?" IMG
		    dd if=/dev/zero of=build/os.img bs=1M count=${IMG}
		    echo "Partitioning..."
		    cfdisk build/os.img
		    exit 0;
	            ;;
	      [nN][oO]|[nN])
	            exit 0;
	            ;;
	      *)
	esac
done

#read -r -p "Yes [Y/n]" CONTINUE
#dd if=/dev/zero of=os.iso bs=1M count=2000

