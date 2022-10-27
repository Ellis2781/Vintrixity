#include paths.mk
# These variables are meant to be used throughout the entire project
# This file is meant to be included from a directory above this one.

PROJECT_ROOT_DIR := $(CURDIR)/../../
# This is the root directory of our build, by default this is located in the directory that this file is in

SRC_DIR := $(CURDIR)/../../src/
# The root of our source directory, by default this is located in the root directory

BUILD_DIR := $(CURDIR)/../../build/
# The root of our build directory, by default it is in the root directory

SYSROOT_DIR := $(CURDIR)/../../build/sysroot/
# This is the sysroot of the build, located in the build directory

BOOT_DIR := $(CURDIR)/../../build/boot/
# This is the boot partition of the build, located in the build directory as well

SYSTEM_DIR := $(SYSROOT_DIR)/System/
# This is the /System directory of the build, located in the sysroot directory

###################################################
Here are some flags to help the reduce repetition
###################################################

#DEFAULT_CFLAGS
DEFAULT_CFLAGS := "--sysroot=$(SYSROOT_DIR) -I$(SYSROOT_DIR)/usr/include"

# DEFAULT CONFIGURE FLAGS
DEFAULT_CONFIGURE_FLAGS := --prefix=$(SYSTEM_DIR) --includedir=SYSROOT_DIR/usr/include CFLAGS=$(DEFAULT_CFLAGS) --includedir=$(SYSROOT_DIR)/usr/include --libdir=$(SYSROOT_DIR)/usr/lib --libdir=$(SYSTEM_DIR)/lib

# These flags are general flags, they are used in some makefiles but since they are simply variables, they may be applied to anywhere that needs these variables
DEFAULT_GENERIC_CC_FLAGS := CFLAGS=$(DEFAULT_CFLAGS) CC=clang

# Gets a list of all directories that include a vintrixity.mk file and then builds all of them 
DIRS := $(wildcard */)

# This is going to have to be seperated into a loop that keeps switching directories that it uses make in
all:
	for p in  $(DIRS); \
	do \
		if [ -a $(CURDIR)/$$p/vintrixity.mk ] ; \
		then \
			echo Found vintrixity.mk ; \
			cd $(CURDIR)/$$p && make -f vintrixity.mk PROJECT_ROOT_DIR=$(PROJECT_ROOT_DIR) SRC_DIR=$(SRC_DIR) BUILD_DIR=$(BUILD_DIR) SYSROOT_DIR=$(SYSROOT_DIR) BOOT_DIR=$(BOOT_DIR) SYSTEM_DIR=$(SYSTEM_DIR) DEFAULT_CONFIGURE_FLAGS=$(DEFAULT_CONFIGURE_FLAGS) DEFAULT_CFLAGS=$(DEFAULT_CFLAGS) ; \
		else \
			echo Did not find vintrixity.mk in $(CURDIR)/$$p ; \
			exit 2 ; \
		fi; \
	done

