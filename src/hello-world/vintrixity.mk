all:
	echo ${CURDIR}
	@echo Using Root Directory: $(PROJECT_ROOT_DIR)
	@echo Using Source Directory: $(SRC_DIR)
	@echo Using Build Directory: $(BUILD_DIR)
	@echo Using Sysroot Directory: $(SYSROOT_DIR) 
	@echo Using Boot Directory: $(BOOT_DIR)
	@echo Using System Directory: $(SYSTEM_DIR)

	@echo Running make
	make -j$(JOBS) CFLAGS=$(DEFAULT_CFLAGS) CC=$(DEFAULT_CC)

	make install PREFIX=$(SYSTEM_DIR)
	
