all:
	make
	./busybox --install $(SYSTEM_DIR)/sbin
	make -C kconfig-frontends $(DEFAULT_CFLAGS)
	make -C kconfig-frontends $(DEFAULT_CFLAGS) install
