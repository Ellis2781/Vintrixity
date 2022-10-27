include ../Makefile

all:
	./bootstrap
	./configure $(DEFAULT_CONFIGURE_FLAGS) --enable-uefi-x86_64
	make
	mkdir -p $(BOOT_DIR)/EFI/BOOT
	cp -v bin/BOOTX64.EFI $(BOOT_DIR)/EFI/BOOT
	cp -v limine.cfg $(BOOT_DIR)/EFI/BOOT
	make install
