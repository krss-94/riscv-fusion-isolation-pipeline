OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY
{
    IMEM (rx)  : ORIGIN = 0x80000000, LENGTH = 32K
    DMEM (rwx) : ORIGIN = 0x80010000, LENGTH = 32K
}
SECTIONS
{
    .text.init : { *(.text.init) } > IMEM
    .text : { *(.text) *(.text.*) } > IMEM
    .rodata : { *(.rodata) *(.rodata.*) } > IMEM
    .data : { __data_start = .; *(.data) *(.data.*); __data_end = .; } > DMEM
    .bss : { __bss_start = .; *(.bss) *(.bss.*) *(COMMON); __bss_end = .; } > DMEM
}
