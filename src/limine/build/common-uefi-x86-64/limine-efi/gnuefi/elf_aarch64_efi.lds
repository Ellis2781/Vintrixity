OUTPUT_FORMAT(elf64-littleaarch64)
OUTPUT_ARCH(aarch64)
ENTRY(_start)

PHDRS
{
    text    PT_LOAD    FLAGS((1 << 0) | (1 << 2)) ;
    data    PT_LOAD    FLAGS((1 << 1) | (1 << 2)) ;
    dynamic PT_DYNAMIC FLAGS((1 << 1) | (1 << 2)) ;
}

SECTIONS
{
    . = 0;
    __image_base = .;
    __image_size = __image_end - __image_base;

    .text : {
        *(.pe_header)
        . = ALIGN(0x1000);

        *(.text .text.*)
        . = ALIGN(0x1000);
    } :text

    __text_start = __image_base + 0x1000;
    __text_size = SIZEOF(.text) - 0x1000;
    __text_end = __text_start + __text_size;

    .data.sbat : {
        *(.data.sbat)
        . = ALIGN(0x1000);
    } :data

    PROVIDE(__sbat_sizev = 1);

    __sbat_start = __text_end;
    __sbat_size = SIZEOF(.data.sbat);
    __sbat_end = __sbat_start + __sbat_size;

    .data.reloc : {
        *(.data.reloc)
        . = ALIGN(0x1000);
    } :data

    __reloc_start = __sbat_end;
    __reloc_size = SIZEOF(.data.reloc);
    __reloc_end = __reloc_start + __reloc_size;

    .data : {
        *(.rodata .rodata.*)
        *(.data .data.*)
        *(.bss .bss.*)
        *(COMMON)
    } :data

    .rela : {
        *(.rela .rela.*)
    } :data

    .got : {
        *(.got .got.*)
    } :data

    .dynamic : {
        *(.dynamic)
        . = ALIGN(0x1000);
    } :data :dynamic

    __data_start = __reloc_end;
    __data_size = SIZEOF(.data) + SIZEOF(.rela) + SIZEOF(.got) + SIZEOF(.dynamic);
    __data_end = __data_start + __data_size;

    __image_end = __data_end;

    /DISCARD/ : {
        *(.eh_frame)
        *(.note .note.*)
    }
}
