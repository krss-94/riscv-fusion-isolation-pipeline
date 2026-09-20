OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY
{
    MEM (rwx) : ORIGIN = 0x80000000, LENGTH = 128K
}
SECTIONS
{
    .text.init : { *(.text.init) } > MEM
    .text : { *(.text) *(.text.*) } > MEM
    .rodata : { *(.rodata) *(.rodata.*) } > MEM
    .data : { *(.data) *(.data.*) } > MEM
    .bss : { . = ALIGN(4); __bss_start = .; *(.bss) *(.bss.*) *(COMMON); __bss_end = .; } > MEM
    . = ALIGN(16);
    __heap_start = .;
    __heap_end = ORIGIN(MEM) + LENGTH(MEM) - 4096;
    _stack_top = ORIGIN(MEM) + LENGTH(MEM);
}
