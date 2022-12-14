include $(CROSS_FILE)

BUILDDIR ?=

override SPACE := $(subst ,, )

MKESCAPE = $(subst $(SPACE),\ ,$(1))
SHESCAPE = $(subst ','\'',$(1))
OBJESCAPE = $(subst .a ,.a' ',$(subst .o ,.o' ',$(call SHESCAPE,$(1))))

ifeq ($(call MKESCAPE,$(BUILDDIR)),)
    $(error BUILDDIR not specified)
endif

override CROSS_CFLAGS += \
    -Os \
    -std=gnu11 \
    -nostdinc \
    -ffreestanding \
    -fno-stack-protector \
    -fno-stack-check \
    -fomit-frame-pointer \
    -fno-strict-aliasing \
    -fno-lto \
    -fno-pie \
    -fno-pic \
    -m32 \
    -march=i686 \
    -mabi=sysv \
    -mno-80387 \
    -Wshadow \
    -Wvla \
    $(WERROR) \
    -MMD \
    -I../freestanding-headers \
    -I'$(call SHESCAPE,$(BUILDDIR))/tinf' \
    -I.

override CROSS_LDFLAGS += \
    -m elf_i386 \
    -nostdlib \
    -z max-page-size=0x1000 \
    -static \
    -T linker.ld

ifeq ($(CROSS_LD_HAS_NO_PIE),yes)
    override CROSS_LDFLAGS += -no-pie
endif

override C_FILES := $(shell find . -type f -name '*.c')
override ASM_FILES := $(shell find . -type f -name '*.asm')
override OBJ := $(addprefix $(call MKESCAPE,$(BUILDDIR))/, $(ASM_FILES:.asm=.o) $(C_FILES:.c=.o))
override HEADER_DEPS := $(addprefix $(call MKESCAPE,$(BUILDDIR))/, $(C_FILES:.c=.d))

.PHONY: all
all: $(call MKESCAPE,$(BUILDDIR))/decompressor.bin

$(call MKESCAPE,$(BUILDDIR))/decompressor.bin: $(OBJ) ../libgcc-binaries/libgcc-i686.a $(call MKESCAPE,$(BUILDDIR))/tinf/tinfgzip.o $(call MKESCAPE,$(BUILDDIR))/tinf/tinflate.o
	$(CROSS_LD) '$(call OBJESCAPE,$^)' $(CROSS_LDFLAGS) -o '$(call SHESCAPE,$(BUILDDIR))/decompressor.elf'
	$(CROSS_OBJCOPY) -O binary '$(call SHESCAPE,$(BUILDDIR))/decompressor.elf' '$(call SHESCAPE,$@)'

$(call MKESCAPE,$(BUILDDIR))/tinf-copied: ../tinf/*
	rm -rf '$(call SHESCAPE,$(BUILDDIR))/tinf'
	$(MKDIR_P) '$(call SHESCAPE,$(BUILDDIR))'
	cp -r ../tinf '$(call SHESCAPE,$(BUILDDIR))/'
	touch '$(call SHESCAPE,$(BUILDDIR))/tinf-copied'

$(call MKESCAPE,$(BUILDDIR))/tinf/tinfgzip.o: $(call MKESCAPE,$(BUILDDIR))/tinf-copied
	$(MKDIR_P) "$$(dirname '$(call SHESCAPE,$@)')"
	$(CROSS_CC) $(CROSS_CFLAGS) -c '$(call SHESCAPE,$(@:.o=.c))' -o '$(call SHESCAPE,$@)'

$(call MKESCAPE,$(BUILDDIR))/tinf/tinflate.o: $(call MKESCAPE,$(BUILDDIR))/tinf-copied
	$(MKDIR_P) "$$(dirname '$(call SHESCAPE,$@)')"
	$(CROSS_CC) $(CROSS_CFLAGS) -c '$(call SHESCAPE,$(@:.o=.c))' -o '$(call SHESCAPE,$@)'

-include $(HEADER_DEPS)

$(call MKESCAPE,$(BUILDDIR))/%.o: %.c $(call MKESCAPE,$(BUILDDIR))/tinf-copied
	$(MKDIR_P) "$$(dirname '$(call SHESCAPE,$@)')"
	$(CROSS_CC) $(CROSS_CFLAGS) -c '$(call SHESCAPE,$<)' -o '$(call SHESCAPE,$@)'

$(call MKESCAPE,$(BUILDDIR))/%.o: %.asm
	$(MKDIR_P) "$$(dirname '$(call SHESCAPE,$@)')"
	nasm '$(call SHESCAPE,$<)' -f elf32 -o '$(call SHESCAPE,$@)'
