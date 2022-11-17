all:
	make -j$(JOBS) 
	make -j$(JOBS) INSTALL_MOD_PATH=$(INITRAMFS) modules_install CC=gcc
	cp arch/x86/boot/bzImage $(BOOT_DIR)/vmlinuz
	mkdir -vp $(KERNEL_HEADERS) && make INSTALL_HDR_PATH=$(KERNEL_HEADERS) headers_install
