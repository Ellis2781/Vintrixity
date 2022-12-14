override prefix := /home/kc/Vintrixity/Vintrixity//build/sysroot/System
override exec_prefix := ${prefix}

override ACBINDIR := ${exec_prefix}/bin
override ACDATAROOTDIR := ${prefix}/share
override ACINCLUDEDIR := ${prefix}/include

DESTDIR ?=

override BUILDDIR := /home/kc/Vintrixity/Vintrixity/src/limine
override BINDIR := $(BUILDDIR)/bin

override SRCDIR := /home/kc/Vintrixity/Vintrixity/src/limine

override SPACE := $(subst ,, )
override COMMA := ,

MKESCAPE = $(subst $(SPACE),\ ,$(1))
SHESCAPE = $(subst ','\'',$(1))
NASMESCAPE = $(subst ','"'$(COMMA) \"'\"$(COMMA) '"',$(1))

define DEFAULT_VAR =
    ifeq ($(origin $1),default)
        override $(1) := $(2)
    endif
    ifeq ($(origin $1),undefined)
        override $(1) := $(2)
    endif
endef

override BUILD_BIOS := 
override BUILD_UEFI_X86_64 := 
override BUILD_UEFI_IA32 := 
override BUILD_UEFI_AARCH64 := 
override BUILD_CD_EFI := no
override BUILD_PXE := no
override BUILD_CD := no
override BUILD_LIMINE_DEPLOY := no

override WERROR := 
export WERROR

$(eval $(call DEFAULT_VAR,CC,gcc))
export CC

override MKDIR_P := /sbin/mkdir -p
export MKDIR_P

override INSTALL := /bin/install -c
export INSTALL

override INSTALL_PROGRAM := ${INSTALL}
export INSTALL_PROGRAM

override INSTALL_DATA := ${INSTALL} -m 644
export INSTALL_DATA

override GREP := /sbin/grep
export GREP

override SED := /sbin/sed
export SED

override AWK := gawk
export AWK

CPPFLAGS ?= 
export CPPFLAGS
CFLAGS ?= --sysroot=/home/kc/Vintrixity/Vintrixity//build/sysroot
export CFLAGS
LDFLAGS ?= 
export LDFLAGS
LIBS ?= 
export LIBS

CROSS_CFLAGS ?= -g -O2 -pipe -Wall -Wextra
export CROSS_CFLAGS
CROSS_LDFLAGS ?= 
export CROSS_LDFLAGS

override LIMINE_VERSION := e9ab448

override STAGE1_FILES := $(shell find '$(call SHESCAPE,$(SRCDIR))/stage1' -type f -name '*.asm')

.PHONY: all
all: limine-version $(BUILD_UEFI_X86_64) $(BUILD_UEFI_IA32) $(BUILD_UEFI_AARCH64) $(BUILD_BIOS)
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin'

$(call MKESCAPE,$(BINDIR))/limine-hdd.h: $(call MKESCAPE,$(BINDIR))/limine-hdd.bin
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	cd '$(call SHESCAPE,$(BINDIR))' && '$(call SHESCAPE,$(SRCDIR))/host/hgen.sh' >limine-hdd.h

$(call MKESCAPE,$(BINDIR))/limine-deploy: $(call MKESCAPE,$(BINDIR))/Makefile $(call MKESCAPE,$(SRCDIR))/host/limine-deploy.c $(call MKESCAPE,$(BINDIR))/limine-hdd.h
	cp '$(call SHESCAPE,$(SRCDIR))/host/limine-deploy.c' '$(call SHESCAPE,$(BINDIR))/'
	$(MAKE) -C '$(call SHESCAPE,$(BINDIR))' limine-deploy

$(call MKESCAPE,$(BINDIR))/limine-version: $(call MKESCAPE,$(BINDIR))/Makefile $(call MKESCAPE,$(SRCDIR))/host/limine-version.c
	$(SED) 's/@LIMINE_VERSION@/e9ab448/g' <'$(call SHESCAPE,$(SRCDIR))/host/limine-version.c' >'$(call SHESCAPE,$(BINDIR))/limine-version.c'
	$(MAKE) -C '$(call SHESCAPE,$(BINDIR))' limine-version

$(call MKESCAPE,$(BINDIR))/Makefile: $(call MKESCAPE,$(SRCDIR))/host/Makefile $(call MKESCAPE,$(SRCDIR))/host/.gitignore
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	cp '$(call SHESCAPE,$(SRCDIR))/host/Makefile' '$(call SHESCAPE,$(SRCDIR))/host/.gitignore' '$(call SHESCAPE,$(BINDIR))/'

.PHONY: limine-deploy
limine-deploy:
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/limine-deploy'

.PHONY: limine-version
limine-version:
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/limine-version'

.PHONY: clean
clean: limine-bios-clean limine-uefi-ia32-clean limine-uefi-x86-64-clean limine-uefi-aarch64-clean
	rm -rf '$(call SHESCAPE,$(BINDIR))' '$(call SHESCAPE,$(BUILDDIR))/stage1.stamp'

.PHONY: install-data
install-data: all
	$(INSTALL) -d '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))'
	$(INSTALL) -d '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine'
ifeq ($(BUILD_BIOS),limine-bios)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/limine.sys' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
ifneq ($(BUILD_CD),no)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/limine-cd.bin' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
ifneq ($(BUILD_CD_EFI),no)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
ifneq ($(BUILD_PXE),no)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/limine-pxe.bin' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
ifeq ($(BUILD_UEFI_AARCH64),limine-uefi-aarch64)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/BOOTAA64.EFI' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
ifeq ($(BUILD_UEFI_X86_64),limine-uefi-x86-64)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/BOOTX64.EFI' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
ifeq ($(BUILD_UEFI_IA32),limine-uefi-ia32)
	$(INSTALL_DATA) '$(call SHESCAPE,$(BINDIR))/BOOTIA32.EFI' '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine/'
endif
	$(INSTALL) -d '$(call SHESCAPE,$(DESTDIR)$(ACINCLUDEDIR))'
	$(INSTALL_DATA) '$(call SHESCAPE,$(SRCDIR))/limine.h' '$(call SHESCAPE,$(DESTDIR)$(ACINCLUDEDIR))/'

.PHONY: install-strip
install-strip: install-data
	$(INSTALL) -d '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))'
	$(INSTALL_PROGRAM) -s '$(call SHESCAPE,$(BINDIR))/limine-version' '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))/'
ifneq ($(BUILD_LIMINE_DEPLOY),no)
	$(INSTALL_PROGRAM) -s '$(call SHESCAPE,$(BINDIR))/limine-deploy' '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))/'
endif

.PHONY: install
install: install-data
	$(INSTALL) -d '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))'
	$(INSTALL_PROGRAM) '$(call SHESCAPE,$(BINDIR))/limine-version' '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))/'
ifneq ($(BUILD_LIMINE_DEPLOY),no)
	$(INSTALL_PROGRAM) '$(call SHESCAPE,$(BINDIR))/limine-deploy' '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))/'
endif

.PHONY: uninstall
uninstall:
	rm -f '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))/limine-version'
	rm -f '$(call SHESCAPE,$(DESTDIR)$(ACBINDIR))/limine-deploy'
	rm -rf '$(call SHESCAPE,$(DESTDIR)$(ACDATAROOTDIR))/limine'
	rm -f '$(call SHESCAPE,$(DESTDIR)$(ACINCLUDEDIR))/limine.h'

$(call MKESCAPE,$(BUILDDIR))/stage1.stamp: $(STAGE1_FILES) $(call MKESCAPE,$(BUILDDIR))/decompressor-build/decompressor.bin $(call MKESCAPE,$(BUILDDIR))/common-bios/stage2.bin.gz
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	cd '$(call SHESCAPE,$(SRCDIR))/stage1/hdd' && nasm bootsect.asm  -fbin -DBUILDDIR="'"'$(call NASMESCAPE,$(BUILDDIR))'"'" -o '$(call SHESCAPE,$(BINDIR))/limine-hdd.bin'
ifneq ($(BUILD_CD),no)
	cd '$(call SHESCAPE,$(SRCDIR))/stage1/cd'  && nasm bootsect.asm  -fbin -DBUILDDIR="'"'$(call NASMESCAPE,$(BUILDDIR))'"'" -o '$(call SHESCAPE,$(BINDIR))/limine-cd.bin'
endif
ifneq ($(BUILD_PXE),no)
	cd '$(call SHESCAPE,$(SRCDIR))/stage1/pxe' && nasm bootsect.asm  -fbin -DBUILDDIR="'"'$(call NASMESCAPE,$(BUILDDIR))'"'" -o '$(call SHESCAPE,$(BINDIR))/limine-pxe.bin'
endif
	cp '$(call SHESCAPE,$(BUILDDIR))/common-bios/limine.sys' '$(call SHESCAPE,$(BINDIR))/'
	touch '$(call SHESCAPE,$(BUILDDIR))/stage1.stamp'

.PHONY: limine-bios
limine-bios: common-bios decompressor
	$(MAKE) '$(call SHESCAPE,$(BUILDDIR))/stage1.stamp'
ifneq ($(BUILD_LIMINE_DEPLOY),no)
	$(MAKE) limine-deploy
endif

$(call MKESCAPE,$(BINDIR))/limine-cd-efi.bin: $(if $(BUILD_UEFI_IA32),$(call MKESCAPE,$(BUILDDIR))/common-uefi-ia32/BOOTIA32.EFI) $(if $(BUILD_UEFI_X86_64),$(call MKESCAPE,$(BUILDDIR))/common-uefi-x86-64/BOOTX64.EFI) $(if $(BUILD_UEFI_AARCH64),$(call MKESCAPE,$(BUILDDIR))/common-uefi-aarch64/BOOTAA64.EFI)
ifneq ($(BUILD_CD_EFI),no)
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	rm -f '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin'
	dd if=/dev/zero of='$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' bs=512 count=2880 2>/dev/null
	( mformat -i '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' -f 1440 :: && \
	  mmd -D s -i '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' ::/EFI && \
	  mmd -D s -i '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' ::/EFI/BOOT && \
	  ( ( [ -f '$(call SHESCAPE,$(BUILDDIR))/common-uefi-aarch64/BOOTAA64.EFI' ] && \
	      mcopy -D o -i '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' '$(call SHESCAPE,$(BUILDDIR))/common-uefi-aarch64/BOOTAA64.EFI' ::/EFI/BOOT ) || true ) && \
	  ( ( [ -f '$(call SHESCAPE,$(BUILDDIR))/common-uefi-x86-64/BOOTX64.EFI' ] && \
	      mcopy -D o -i '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' '$(call SHESCAPE,$(BUILDDIR))/common-uefi-x86-64/BOOTX64.EFI' ::/EFI/BOOT ) || true ) && \
	  ( ( [ -f '$(call SHESCAPE,$(BUILDDIR))/common-uefi-ia32/BOOTIA32.EFI' ] && \
	      mcopy -D o -i '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin' '$(call SHESCAPE,$(BUILDDIR))/common-uefi-ia32/BOOTIA32.EFI' ::/EFI/BOOT ) || true ) \
	) || rm -f '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin'
endif

.PHONY: limine-cd-efi
limine-cd-efi:
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/limine-cd-efi.bin'

$(call MKESCAPE,$(BINDIR))/BOOTX64.EFI: $(call MKESCAPE,$(BUILDDIR))/common-uefi-x86-64/BOOTX64.EFI
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	cp '$(call SHESCAPE,$(BUILDDIR))/common-uefi-x86-64/BOOTX64.EFI' '$(call SHESCAPE,$(BINDIR))/'

.PHONY: limine-uefi-x86-64
limine-uefi-x86-64:
	$(MAKE) common-uefi-x86-64
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/BOOTX64.EFI'

$(call MKESCAPE,$(BINDIR))/BOOTIA32.EFI: $(call MKESCAPE,$(BUILDDIR))/common-uefi-ia32/BOOTIA32.EFI
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	cp '$(call SHESCAPE,$(BUILDDIR))/common-uefi-ia32/BOOTIA32.EFI' '$(call SHESCAPE,$(BINDIR))/'

.PHONY: limine-uefi-ia32
limine-uefi-ia32:
	$(MAKE) common-uefi-ia32
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/BOOTIA32.EFI'

$(call MKESCAPE,$(BINDIR))/BOOTAA64.EFI: $(call MKESCAPE,$(BUILDDIR))/common-uefi-aarch64/BOOTAA64.EFI
	$(MKDIR_P) '$(call SHESCAPE,$(BINDIR))'
	cp '$(call SHESCAPE,$(BUILDDIR))/common-uefi-aarch64/BOOTAA64.EFI' '$(call SHESCAPE,$(BINDIR))/'

.PHONY: limine-uefi-aarch64
limine-uefi-aarch64:
	$(MAKE) common-uefi-aarch64
	$(MAKE) '$(call SHESCAPE,$(BINDIR))/BOOTAA64.EFI'

.PHONY: limine-bios-clean
limine-bios-clean: common-bios-clean decompressor-clean

.PHONY: limine-uefi-x86-64-clean
limine-uefi-x86-64-clean: common-uefi-x86-64-clean

.PHONY: limine-uefi-ia32-clean
limine-uefi-ia32-clean: common-uefi-ia32-clean

.PHONY: limine-uefi-aarch64-clean
limine-uefi-aarch64-clean: common-uefi-aarch64-clean

.PHONY: dist
dist:
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)"
	$(MKDIR_P) '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)"
	cp -r '$(call SHESCAPE,$(SRCDIR))'/.git '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)"/
	cd '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)" && git checkout .
	cd '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)" && ./bootstrap
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/common/term/.git"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/freestanding-headers/.git"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries/.git"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries/.gitignore"

	libgcc_needed="i686 x86_64-no-red-zone aarch64"; \
	for f in $$libgcc_needed; do \
		mv '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries/libgcc-$$f.a" '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries/libgcc-$$f.a.save"; \
	done; \
	rm '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries"/*.a; \
	for f in $$libgcc_needed; do \
		mv '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries/libgcc-$$f.a.save" '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/libgcc-binaries/libgcc-$$f.a"; \
	done

	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/limine-efi/.git"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/limine-efi/.gitignore"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/cross-detect/.git"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/cross-detect/.gitignore"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/.git"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/.gitignore"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/.github"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/autom4te.cache"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/cross-detect/autom4te.cache"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/test"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/screenshot.png"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/bochsrc"
	echo "$(LIMINE_VERSION)" > '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)/version"
	cd '$(call SHESCAPE,$(BUILDDIR))' && tar -Jcf "limine-$(LIMINE_VERSION).tar.xz" "limine-$(LIMINE_VERSION)"
	cd '$(call SHESCAPE,$(BUILDDIR))' && tar -zcf "limine-$(LIMINE_VERSION).tar.gz" "limine-$(LIMINE_VERSION)"
	rm -rf '$(call SHESCAPE,$(BUILDDIR))'/"limine-$(LIMINE_VERSION)"

.PHONY: distclean
distclean: clean
	rm -rf ovmf* config.log config.status GNUmakefile config.h cross-files

.PHONY: maintainer-clean
maintainer-clean: distclean
	cd '$(call SHESCAPE,$(SRCDIR))' && rm -rf common/term freestanding-headers libgcc-binaries limine-efi cross-detect configure build-aux *'~' autom4te.cache *.tar.xz *.tar.gz

.PHONY: common-uefi-x86-64
common-uefi-x86-64:
	$(MAKE) -C '$(call SHESCAPE,$(SRCDIR))/common' all \
		CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk' \
		TARGET=uefi-x86-64 \
		BUILDDIR='$(call SHESCAPE,$(BUILDDIR))/common-uefi-x86-64'

.PHONY: common-uefi-x86-64-clean
common-uefi-x86-64-clean:
	rm -rf '$(call SHESCAPE,$(BUILDDIR))/common-uefi-x86-64'

.PHONY: common-uefi-aarch64
common-uefi-aarch64:
	$(MAKE) -C '$(call SHESCAPE,$(SRCDIR))/common' all \
		CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/aarch64-toolchain.mk' \
		TARGET=uefi-aarch64 \
		BUILDDIR='$(call SHESCAPE,$(BUILDDIR))/common-uefi-aarch64'

.PHONY: common-uefi-aarch64-clean
common-uefi-aarch64-clean:
	rm -rf '$(call SHESCAPE,$(BUILDDIR))/common-uefi-aarch64'

.PHONY: common-uefi-ia32
common-uefi-ia32:
	$(MAKE) -C '$(call SHESCAPE,$(SRCDIR))/common' all \
		CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/i686-toolchain.mk' \
		TARGET=uefi-ia32 \
		BUILDDIR='$(call SHESCAPE,$(BUILDDIR))/common-uefi-ia32'

.PHONY: common-uefi-ia32-clean
common-uefi-ia32-clean:
	rm -rf '$(call SHESCAPE,$(BUILDDIR))/common-uefi-ia32'

.PHONY: common-bios
common-bios:
	$(MAKE) -C '$(call SHESCAPE,$(SRCDIR))/common' all \
		CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/i686-toolchain.mk' \
		TARGET=bios \
		BUILDDIR='$(call SHESCAPE,$(BUILDDIR))/common-bios'

.PHONY: common-bios-clean
common-bios-clean:
	rm -rf '$(call SHESCAPE,$(BUILDDIR))/common-bios'

.PHONY: decompressor
decompressor:
	$(MAKE) -C '$(call SHESCAPE,$(SRCDIR))/decompressor' all \
		CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/i686-toolchain.mk' \
		BUILDDIR='$(call SHESCAPE,$(BUILDDIR))/decompressor-build'

.PHONY: decompressor-clean
decompressor-clean:
	rm -rf '$(call SHESCAPE,$(BUILDDIR))/decompressor-build'

.PHONY: test-clean
test-clean:
	$(MAKE) -C test clean
	rm -rf test_image test.hdd test.iso

ovmf-x64:
	$(MKDIR_P) ovmf-x64
	cd ovmf-x64 && curl -o OVMF-X64.zip https://efi.akeo.ie/OVMF/OVMF-X64.zip && 7z x OVMF-X64.zip

ovmf-aa64:
	mkdir -p ovmf-aa64
	cd ovmf-aa64 && curl -o OVMF-AA64.zip https://efi.akeo.ie/OVMF/OVMF-AA64.zip && 7z x OVMF-AA64.zip

ovmf-ia32:
	$(MKDIR_P) ovmf-ia32
	cd ovmf-ia32 && curl -o OVMF-IA32.zip https://efi.akeo.ie/OVMF/OVMF-IA32.zip && 7z x OVMF-IA32.zip

.PHONY: test.hdd
test.hdd:
	rm -f test.hdd
	dd if=/dev/zero bs=1M count=0 seek=64 of=test.hdd
	parted -s test.hdd mklabel gpt
	parted -s test.hdd mkpart primary 2048s 100%

.PHONY: mbrtest.hdd
mbrtest.hdd:
	rm -f mbrtest.hdd
	dd if=/dev/zero bs=1M count=0 seek=64 of=mbrtest.hdd
	echo -e "o\nn\np\n1\n2048\n\nt\n6\na\nw\n" | fdisk mbrtest.hdd -H 16 -S 63

.PHONY: ext2-test
ext2-test:
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-bios
	$(MAKE) limine-deploy
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.ext2 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	$(BINDIR)/limine-deploy test.hdd
	qemu-system-x86_64 -net none -smp 4   -hda test.hdd -debugcon stdio

.PHONY: fat12-test
fat12-test:
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-bios
	$(MAKE) limine-deploy
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 12 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	$(BINDIR)/limine-deploy test.hdd
	qemu-system-x86_64 -net none -smp 4   -hda test.hdd -debugcon stdio

.PHONY: fat16-test
fat16-test:
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-bios
	$(MAKE) limine-deploy
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 16 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	$(BINDIR)/limine-deploy test.hdd
	qemu-system-x86_64 -net none -smp 4   -hda test.hdd -debugcon stdio

.PHONY: legacy-fat16-test
legacy-fat16-test:
	$(MAKE) test-clean
	$(MAKE) mbrtest.hdd
	fdisk -l mbrtest.hdd
	$(MAKE) limine-bios
	$(MAKE) limine-deploy
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show mbrtest.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 16 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	$(BINDIR)/limine-deploy mbrtest.hdd
	qemu-system-i386 -cpu pentium2 -m 16M -M isapc -net none   -hda mbrtest.hdd -debugcon stdio

.PHONY: fat32-test
fat32-test:
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-bios
	$(MAKE) limine-deploy
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 32 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	$(BINDIR)/limine-deploy test.hdd
	qemu-system-x86_64 -net none -smp 4   -hda test.hdd -debugcon stdio

.PHONY: iso9660-test
iso9660-test:
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-bios
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	$(MKDIR_P) test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	xorriso -as mkisofs -b boot/limine-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table test_image/ -o test.iso
	qemu-system-x86_64 -net none -smp 4   -cdrom test.iso -debugcon stdio

.PHONY: full-hybrid-test
full-hybrid-test:
	$(MAKE) ovmf-x64
	$(MAKE) ovmf-ia32
	$(MAKE) test-clean
	$(MAKE) all
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	$(MKDIR_P) test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	xorriso -as mkisofs -b boot/limine-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot boot/limine-cd-efi.bin -efi-boot-part --efi-boot-image --protective-msdos-label test_image/ -o test.iso
	$(BINDIR)/limine-deploy test.iso
	qemu-system-x86_64 -m 512M -M q35 -bios ovmf-x64/OVMF.fd -net none -smp 4   -cdrom test.iso -debugcon stdio
	qemu-system-x86_64 -m 512M -M q35 -bios ovmf-x64/OVMF.fd -net none -smp 4   -hda test.iso -debugcon stdio
	qemu-system-x86_64 -m 512M -M q35 -bios ovmf-ia32/OVMF.fd -net none -smp 4   -cdrom test.iso -debugcon stdio
	qemu-system-x86_64 -m 512M -M q35 -bios ovmf-ia32/OVMF.fd -net none -smp 4   -hda test.iso -debugcon stdio
	qemu-system-x86_64 -m 512M -M q35 -net none -smp 4   -cdrom test.iso -debugcon stdio
	qemu-system-x86_64 -m 512M -M q35 -net none -smp 4   -hda test.iso -debugcon stdio

.PHONY: pxe-test
pxe-test:
	$(MAKE) test-clean
	$(MAKE) limine-bios
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	$(MKDIR_P) test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	qemu-system-x86_64  -smp 4  -netdev user,id=n0,tftp=./test_image,bootfile=boot/limine-pxe.bin -device rtl8139,netdev=n0,mac=00:00:00:11:11:11 -debugcon stdio

.PHONY: uefi-x86-64-test
uefi-x86-64-test:
	$(MAKE) ovmf-x64
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-uefi-x86-64
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 32 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sudo $(MKDIR_P) test_image/EFI/BOOT
	sudo cp $(BINDIR)/BOOTX64.EFI test_image/EFI/BOOT/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	qemu-system-x86_64 -m 512M -M q35 -bios ovmf-x64/OVMF.fd -net none -smp 4   -hda test.hdd -debugcon stdio

.PHONY: uefi-aa64-test
uefi-aa64-test:
	$(MAKE) ovmf-aa64
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-uefi-aarch64
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/aarch64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 32 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sudo $(MKDIR_P) test_image/EFI/BOOT
	sudo cp $(BINDIR)/BOOTAA64.EFI test_image/EFI/BOOT/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	qemu-system-aarch64 -m 512M -M virt -cpu cortex-a72 -bios ovmf-aa64/OVMF.fd -net none -smp 4 -device ramfb -device qemu-xhci -device usb-kbd  -hda test.hdd -serial stdio

.PHONY: uefi-ia32-test
uefi-ia32-test:
	$(MAKE) ovmf-ia32
	$(MAKE) test-clean
	$(MAKE) test.hdd
	$(MAKE) limine-uefi-ia32
	$(MAKE) -C test CROSS_FILE='$(call SHESCAPE,$(BUILDDIR))/cross-files/x86_64-toolchain.mk'
	rm -rf test_image/
	mkdir test_image
	sudo losetup -Pf --show test.hdd > loopback_dev
	sudo partprobe `cat loopback_dev`
	sudo mkfs.fat -F 32 `cat loopback_dev`p1
	sudo mount `cat loopback_dev`p1 test_image
	sudo mkdir test_image/boot
	sudo cp -rv $(BINDIR)/* test_image/boot/
	sudo cp -rv test/* test_image/boot/
	sudo $(MKDIR_P) test_image/EFI/BOOT
	sudo cp $(BINDIR)/BOOTIA32.EFI test_image/EFI/BOOT/
	sync
	sudo umount test_image/
	sudo losetup -d `cat loopback_dev`
	rm -rf test_image loopback_dev
	qemu-system-x86_64 -m 512M -M q35 -bios ovmf-ia32/OVMF.fd -net none -smp 4   -hda test.hdd -debugcon stdio
