.PHONY: all clean libs

#include paths.mk
# These variables are meant to be used throughout the entire project
# This file is meant to be included from a directory above this one.

CURDIR := $(CURDIR)

PROJECT_ROOT_DIR := $(CURDIR)/../
# This is the root directory of our build, by default this is located in the directory that this file is in

SRC_DIR := $(CURDIR)/../src/
# The root of our source directory, by default this is located in the root directory

BUILD_DIR := $(CURDIR)/../build/
# The root of our build directory, by default it is in the root directory

SYSROOT_DIR := $(CURDIR)/../build/sysroot/
# This is the sysroot of the build, located in the build directory

BOOT_DIR := $(CURDIR)/../build/boot/
# This is the boot partition of the build, located in the build directory as well

SYSTEM_DIR := $(SYSROOT_DIR)/System/
# This is the /System directory of the build, located in the sysroot directory

INITRAMFS := $(BUILD_DIR)/initramfs/
# This is the root of the initramfs build which will then be packaged into the initramfs file


KERNEL_HEADERS := $(BUILD_DIR)/kernel_headers

###################################################
#Here are some flags to help the reduce repetition#
###################################################

#DEFAULT_CC
DEFAULT_CC := gcc

#DEFAULT_CFLAGS
DEFAULT_CFLAGS := --sysroot=$(SYSROOT_DIR) -I$(SYSROOT_DIR)/usr/include -I$(KERNEL_HEADERS) -I$(SYTEM_DIR)/include -L$(SYSROOT_DIR)/usr/lib -L$(SYSROOT_DIR)/usr/lib64 -L$(SYSTEM_DIR)/lib -L$(SYSTEM_DIR)/lib64

# DEFAULT CONFIGURE FLAGS
DEFAULT_CONFIGURE_FLAGS := --prefix=$(SYSTEM_DIR) --includedir=$(SYSROOT_DIR)/usr/include CFLAGS=$(DEFAULT_CFLAGS) --includedir=$(SYSROOT_DIR)/usr/include --libdir=$(SYSROOT_DIR)/usr/lib --libdir=$(SYSTEM_DIR)/lib

# These flags are general flags, they are used in some makefiles but since they are simply variables, they may be applied to anywhere that needs these variables
DEFAULT_GENERIC_CC_FLAGS := CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC)

# Gets a list of all directories that include a vintrixity.mk file and then builds all of them excluding the libs directory because it is built seperately 
# Since the kernel is the first thing to be built, it is at the start of the list
DIRS := kernel limine sndio system system-utils hello-world # $(filter-out libs/,$(wildcard */))

LIBS := $(wildcard libs/*) #$(addprefix libs/, $(wildcard libs/*))

# Number of jobs that make will have, can speed up the build tremendously
JOBS := 1

# This is going to have to be seperated into a loop that keeps switching directories that it uses make in


all:
	echo $(wildcard libs/*)
	for lib in $(LIBS); \
	do \
		if [ -a $$lib/vintrixity.mk ] ; \
		then \
			echo Found vintrixity.mk in $$lib ; \
			cd $$lib && make -f vintrixity.mk PROJECT_ROOT_DIR=$(PROJECT_ROOT_DIR) SRC_DIR=$(SRC_DIR) BUILD_DIR=$(BUILD_DIR) SYSROOT_DIR=$(SYSROOT_DIR) BOOT_DIR=$(BOOT_DIR) SYSTEM_DIR=$(SYSTEM_DIR) DEFAULT_CFLAGS="$(DEFAULT_CFLAGS)" DEFAULT_CC=$(DEFAULT_CC) JOBS=$(JOBS) DEFAULT_CONFIGURE_FLAGS="$(DEFAULT_CONFIGURE_FLAGS)"; else ; \
			echo Did not find vintrixity.mk in $$lib ; \
			exit 2 ; \
		fi; \
	

	
	for src in $(DIRS); \
	do \
		if [ -a $(CURDIR)/$$src/vintrixity.mk ] ; \
		then \
			echo Found vintrixity.mk ; \
			cd $(CURDIR)/$$src && make -f vintrixity.mk PROJECT_ROOT_DIR=$(PROJECT_ROOT_DIR) SRC_DIR=$(SRC_DIR) BUILD_DIR=$(BUILD_DIR) SYSROOT_DIR=$(SYSROOT_DIR) BOOT_DIR=$(BOOT_DIR) SYSTEM_DIR=$(SYSTEM_DIR) DEFAULT_CONFIGURE_FLAGS=$(DEFAULT_CONFIGURE_FLAGS) DEFAULT_CFLAGS=$(DEFAULT_CFLAGS) DEFAULT_CC=$(DEFAULT_CC) JOBS=$(JOBS) ; \
		else \
			echo Did not find vintrixity.mk in $(CURDIR)/$$src ; \
			exit 2 ; \
		fi; \
	done

	# At last, external

	@echo "Generating Initramfs..."
	cd $(INITRAMFS) && rm -f ./initramfs.cpio ./initramfs.cpio.gz && ls -I initramfs.cpio | cpio -ov > initramfs.cpio && gzip ./initramfs.cpio
	cp -vp $(INITRAMFS)/initramfs.cpio.gz $(BOOT_DIR)/initramfs.cpio.gz
	@echo "Done!"
