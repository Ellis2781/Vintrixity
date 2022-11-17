#include ../../Makefile

all:
	./configure  --prefix=$(SYSTEM_DIR) CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC)
	make -j$(JOBS) clean
	make -j$(JOBS) CFLAGS="--sysroot=$(SYSROOT_DIR) -I$(SYSROOT_DIR)/usr/include -I$(KERNEL_HEADERS) -I$(SYTEM_DIR)/include -L$(SYSROOT_DIR)/usr/lib -L$(SYSROOT_DIR)/usr/lib64 -L$(SYSTEM_DIR)/lib -L$(SYSTEM_DIR)/lib64" 
	make install
