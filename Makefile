.PHONY: build clean

build:
	export CURDIR=/home/kc/Vintrixity/Vintrixity/ 
	./build.sh system
	./build.sh system-libs
	./build.sh initramfs

menuconfig:
	set CONFIG_
	kconfig-mconf Kconfig 
	echo ${CONFIG_EXTERNAL}

nconfig:
	export CONFIG_ && kconfig-nconf Kconfig

config:
	export CONFIG_ && kconfig-conf Kconfig

clean:
	#rm -r build/*
