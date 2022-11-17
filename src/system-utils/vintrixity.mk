all:
	make -j$(JOBS) CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC)
	./busybox --install $(SYSTEM_DIR)/sbin 

	#cd kconfig-frontends && ./configure $(DEFAULT_CONFIGURE_FLAGS) && make CFLAGS=$(DEFAULT_CFLAGS) && make CFLAGS=$(DEFAULT_CFLAGS) install 

	cp -rv initramfs/* $(INITRAMFS)
	./busybox --install $(INITRAMFS)/sbin
