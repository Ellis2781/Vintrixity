all:
	make
	./busybox --install $(SYSTEM_DIR)/sbin
