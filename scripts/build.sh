#!/bin/sh

export PROJECT_ROOT_DIR="${CURDIR}" #/../"
# This is the root directory of our build, by default this is located in the directory that this file is in

export SRC_DIR=${CURDIR}/src #/../src/
# The root of our source directory, by default this is located in the root directory

export BUILD_DIR=${CURDIR}/build #/../build/
# The root of our build directory, by default it is in the root directory

export SYSROOT_DIR=${CURDIR}/build/sysroot #/../build/sysroot/
# This is the sysroot of the build, located in the build directory

export BOOT_DIR=${CURDIR}/build/boot #/../build/boot/
# This is the boot partition of the build, located in the build directory as well

export SYSTEM_DIR=${SYSROOT_DIR}/System/
# This is the /System directory of the build, located in the sysroot directory

export INITRAMFS=${BUILD_DIR}/initramfs/
# This is the root of the initramfs build which will then be packaged into the initramfs file

export KERNEL_HEADERS=${BUILD_DIR}/kernel_headers/include

###################################################
#Here are some flags to help the reduce repetition#
###################################################

#DEFAULT_CC
export DEFAULT_CC=gcc

#DEFAULT_CFLAGS
export DEFAULT_CFLAGS='"--sysroot=${SYSROOT_DIR} -I${SYSROOT_DIR}/usr/include -I${KERNEL_HEADERS} -I${SYTEM_DIR}/include -L${SYSROOT_DIR}/usr/lib -L${SYSROOT_DIR}/usr/lib64 -L${SYSTEM_DIR}/lib -L${SYSTEM_DIR}/lib64"'

# DEFAULT CONFIGURE FLAGS
declare -a CONFIGURE_FLAGS
CONFIGURE_FLAGS=(
	"--prefix=${SYSTEM_DIR}" 
	"--includedir=${SYSROOT_DIR}/usr/include"
	"--includedir=${SYSROOT_DIR}/usr/include"
	"--libdir=${SYSROOT_DIR}/usr/lib" 
	"--libdir=${SYSTEM_DIR}/lib"
	'CFLAGS="${DEFAULT_CFLAGS}"'
)
DEFAULT_CONFIGURE_FLAGS=${CONFIGURE_FLAGS[@]}

# These flags are general flags, they are used in some makefiles but since they are simply variables, they may be applied to anywhere that needs these variables
declare -a DEFAULT_GENERIC_CC_FLAGS 
DEFAULT_GENERIC_CC_FLAGS=(
				'CFLAGS="${DEFAULT_CFLAGS}"' 
				'CC="${DEFAULT_CC}"'
)

# Number of jobs that make will have, can speed up the build tremendously
export JOBS=7

export DIRS="kernel limine sndio system system-utils hello-world"

export LIBS="libc"

#EXTERNAL=

#$(wildcard libs/*} #$(addprefix libs/, $(wildcard libs/*}}


if [ "$1" == "initramfs" ]
then
	# At last, external
	echo "Generating Initramfs..."
	cd ${INITRAMFS} && rm -f ./initramfs.cpio ./initramfs.cpio.gz && find . ! -name initramfs.cpio.gz | cpio -o -H newc | gzip > initramfs.cpio.gz  #ls -I initramfs.cpio.gz | cpio -o -H newc | gzip > initramfs.cpio.gz 
	cp -vp ${INITRAMFS}/initramfs.cpio.gz ${BOOT_DIR}/initramfs.cpio.gz
	echo "Done!"
elif [ "$1" == "system" ]
then		
	for src in ${DIRS}
	do 
		if [ -a ${SRC_DIR}/$src/vintrixity.mk ] ;
		then 
			echo Found vintrixity.mk
			cd ${SRC_DIR}/$src && make -f vintrixity.mk
		else
			echo Did not find vintrixity.mk in ${SRC_DIR}/$src
			exit 2
		fi
	done
elif [ "$1" == "system-libs" ]
	then
		for lib in ${LIBS}
	do 
		if [ -a ${SRC_DIR}/libs/$lib/vintrixity.mk ] ;
		then 
			echo Found vintrixity.mk in ${SRC_DIR}/libs/$lib/
			cd ${SRC_DIR}/libs/$lib/ && make -f vintrixity.mk
		else 
			echo Did not find vintrixity.mk in $lib 
			exit 2 
		fi
	done
elif [ "$1" == "headers" ]
	then
		echo "Installing Headers..."
		rm -r ${BUILD_DIR}/headers/*
		mkdir -vp ${BUILD_DIR}/headers/System/include && mv -v ${SYSTEM_DIR}/include ${BUILD_DIR}/headers/System/include && cp -rv ${KERNEL_HEADERS}/* ${BUILD_DIR}/headers/System/include
		cd ${BUILD_DIR}/headers && tar -cJf ${BUILD_DIR}/headers.tar.xz .
		echo "Done!"
else # [ -z "$1" ] || [ "--help" == "$1" ] || [ "help" == "$1" ] || [ "-h" == $1 ]
	echo "build.sh [option]
	options: initramfs system system-libs"
	exit 0;
fi

