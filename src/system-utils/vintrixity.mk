include ../Makefile
all:
	make
	./busybox --install $(SYSTEM_DIR)/sbin

	#cd kconfig-frontends && ./configure $(DEFAULT_CONFIGURE_FLAGS) && make CFLAGS=$(DEFAULT_CFLAGS) && make CFLAGS=$(DEFAULT_CFLAGS) install 

	cp -rv initramfs/* $(INITRAMFS)
	./busybox --install $(INITRAMFS)/sbin
