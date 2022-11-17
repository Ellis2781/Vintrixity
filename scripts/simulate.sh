#!/bin/sh

qemu-system-x86_64 -kernel build/boot/vmlinuz -initrd build/initramfs/initramfs.cpio.gz /dev/zero -append rdinit=/sbin/sh
