# Vintrixity

Status: Very Early Alpha, experimental

Vintrixity is an open source, linux based operating system that attempts to be as simple as possible in implementation. 

My inspiration for designing this os stemmed from the BSD vs linux dilemma. BSD-like oses just have a level of simplicity that makes life so much easier. BSD has every single thing packaged into a nice neat bundle of software. Also, I particularly like the style of BSD config files. 

My future plans are: porting the linux kernel to run atop the seL4 microkernel (This is similar to what l4linux and gnu hurd have done and if done correctly, could provide quite a safe enviornment), use Kconfig to manage systemwide settings, use debian's dpkg software to allow installing "third party" programs like gogole chrome directly from the debian repos (this may be a difficult task due to the difference in structure from debian), allowing software to be built along with the OS in addition to the software in the source directory, installation packages that contain a scripts to upgrade an existing systems System directory. This would contain updates to the software found in system-utils which will end up in the /System directory, the Nano-X window system and using a single library object to bundle a group of system libraries (libbsd, maybe libx11, etc).

Ideas/Inspirations
	- Adding a tool to manage all of the system related utilities 
	- The /System directoy is an inspiration from Apple's popular OS, Mac OS. Having all system related utilities in a single directory rather than having them spread throughout the entire system sounded appropriate.

Compiling software can be a nightmare!
Stay tuned!
