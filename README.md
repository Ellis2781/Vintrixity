# Vintrixity

Status: Very Early Alpha, experimental

Vintrixity is an open source, linux based operating system that attempts to be as simple as possible in implementation. 

Future Plans
	- Porting the linux kernel to run atop the seL4 microkernel. This is similar to what l4linux and gnu hurd have done and if done correctly, could provide quite a safe enviornment
	- Use Kconfig to manage systemwide settings
	- Use debian's dpkg software to allow installing "third party" programs like gogole chrome directly from the debian repos (this may be a difficult task due to the difference in structure from debian)
	- Allowing software to be built along with the OS in addition to the software in the source directory
	- Installation packages that contain a scripts to upgrade an existing systems System directory. This would contain updates to the software found in system-utils which will end up in the /System directory
	- The Nano-X window system!
	- Using a single library object to bundle a group of system libraries. (libbsd, maybe libx11, etc)

Ideas/Inspirations
	- Adding a tool to manage all of the system related utilities 
	- The /System directoy is an inspiration from Apple's popular OS, Mac OS. Having all system related utilities in a single directory rather than having them spread throughout the entire system sounded appropriate.

Compiling software can be a nightmare!
Stay tuned!
