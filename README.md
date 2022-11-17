# Vintrixity

Status: Very Early Alpha, experimental, the build system should be somewhat working

Vintrixity is an open source, linux based operating system that attempts to be as simple, clean, and efficient as possible.

My inspiration for designing this os stemmed from the BSD vs linux dilemma. BSD-like oses just have a level of simplicity that makes life so much easier. BSD has every single thing packaged into a nice neat bundle of software. Also, I particularly like the style of BSD config files. 

My future plans are: porting the linux kernel to run atop the seL4 microkernel (This is similar to what l4linux and gnu hurd have done and if done correctly, could provide quite a safe enviornment), use Kconfig to manage systemwide settings, use debian's dpkg software to allow installing "third party" programs like gogole chrome directly from the debian repos (this may be a difficult task due to the difference in structure from debian), allowing software to be built along with the OS in addition to the software in the source directory, fun additions like a shakespearean language addon or mach-o and exe file formats, encrypted files and file systems, installation packages that contain scripts to upgrade an existing systems System directory. This would contain updates to the software found in system-utils which will end up in the /System directory, the Nano-X window system and using a single library object to bundle a group of system libraries (libbsd, maybe libx11, etc).

Ideas/Inspirations
	- Adding a tool to manage all of the system related utilities 
	- The /System directoy is an inspiration from Apple's popular OS, Mac OS. Having all system related utilities in a single directory rather than having them spread throughout the entire system sounded appropriate.

Compiling software can be a nightmare!
Stay tuned!


To build you must first set the directory of your source code.
```
export CURDIR=/home/kc/Vintrixity/Vintrixity/
```
Then you must start building your system libraries
```
./scripts/build.sh system-libs
```

After that then you can build the entire system
```
./scripts/build.sh system
```

Finally, build the initramfs
```
./scripts/build.sh initramfs
```

Then you can boot into your system with qemu. 
```
qemu-system-x86_64 -kernel build/boot/vmlinuz -initrd build/initramfs/initramfs.cpio.gz /dev/zero -append rdinit="/sbin/sh" -m 2G
```

You can then make an img file by doing the following commands
```
dd if=/dev/zero of=build/os.img bs=1M count=2000
```

At this point you can partition your image.
Make sure to make your efi partition at least 500 MB and to include a linux root partition.

```
cfdisk build/os.img
```

```
sudo losetup -Pf build/os.img
lsblk
```

Find your device that you just mounted, mine is loop11. Now it is time to format our partitions. You may choose to format your file system as anything, there are plenty of drivers that you may use.
```
sudo mkfs.fat -F32 /dev/loop11p1
sudo mkfs.ext4 /dev/loop11p2
```

Now mount our partitions
```
sudo mount /dev/loop11p1 /mnt/vintrixity/boot
sudo mount /dev/loop11p2 /mnt/vintrixity/sysroot
```

We can now copy our builds onto our image.
```
mkdir -p /mnt/vintrixity/boot/ && cp -r build/boot/* /mnt/vintrixity/boot/
mkdir -p /mnt/vintrixity/sysroot/ && cp -r build/sysroot/* /mnt/vintrixity/sysroot/
```

You may then unmount it and run the simulate script
```
sudo umount /mnt/vintrixity/boot/
sudo umount /mnt/vintrixity/sysroot/
```

You may choose to boot directly from your kernel or to boot from your img.

Use this to boot from your img (For me booting the kernel from the bootloader does not seem to work)
```
qemu-system-x86_64 -drive file=build/os.img,format=raw -monitor stdio -bios /usr/share/ovmf/x64/OVMF.fd -m 8G
```
This img that you have can be cloned and used to boot on other systems that have uefi.

Or you may choose to boot directly from the kernel and initramfs.
```
./tools/simulate
```
