all:
	./configure --prefix=$(SYSTEM_DIR) CFLAGS=$(DEFAULT_CFLAGS) 
	make -j$(JOBS) CFLAGS=$(DEFAULT_CFLAGS) #$(DEFAULT_GENERIC_CC_FLAGS)
	make install -j$(JOBS)
