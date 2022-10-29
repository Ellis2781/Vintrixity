#!/bin/sh

# Requires you to be out of a docker contiainer and root privillage.

# Here is the general process of making a bootable image.
# First an iso file is made.
# Second, the iso file is partitioned with an EFI partition (ESP: /System/boot/) and a larger linux root partition
# Third, the EFI iso partition is formatted with the FAT file system and the root partition is formatted with ext4.
# Fourth, the partitions are mounted onto the disk
# Fith, the files in the build are copied onto the iso image.
# Lastly, the iso is unmounted and you can boot into the system using the simulate script or qemu.

dd if=/dev/zero of=os.iso bs=1M count=2000

