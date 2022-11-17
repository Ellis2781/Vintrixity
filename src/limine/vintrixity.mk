#CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC) --enable-uefi-x86_64 


all:
	cd ${SRC_DIR}/limine
	./bootstrap
	./configure --prefix=$(SYSTEM_DIR) CFLAGS=$(DEFAULT_CFLAGS) --host=x86_64-pc-linux-gnu --enable-uefi-x86_64 #CC=$(DEFAULT_CC) --host=x86_64-pc-linux-gnu --enable-uefi-x86_64 
	make -j$(JOBS) CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC)
	mkdir -p $(BOOT_DIR)/EFI/BOOT
	cp -v bin/BOOTX64.EFI $(BOOT_DIR)/EFI/BOOT
	cp -v limine.cfg $(BOOT_DIR)
	make install -j$(JOBS) CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC)
