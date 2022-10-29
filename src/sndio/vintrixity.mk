all:
	./configure --prefix=$(SYSTEM_DIR) CC=clang CFLAGS="-static -fPIE -pie -Wall" --bindir=$(SYSTEM_DIR)/sbin
	make -j$(JOBS)
	make install -j$(JOBS)
