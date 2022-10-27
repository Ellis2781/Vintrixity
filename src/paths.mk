# This file defines variables that we use through the entire project
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

SYSTEM_DIR := ${SYSROOT_DIR}/System/
# This is the /System directory of the build, located in the sysroot directory
