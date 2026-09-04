/* Internal Flash/SRAM image. Sizes are supplied by the selected target. */
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = FLASH_SIZE
    RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = RAM_SIZE
}

_estack = ORIGIN(RAM) + LENGTH(RAM);
_Min_Stack_Size = 0x800;

SECTIONS
{
    .isr_vector : { KEEP(*(.isr_vector)) } > FLASH
    .text :
    {
        *(.text .text.*)
        *(.rodata .rodata.*)
        KEEP(*(.init))
        KEEP(*(.fini))
        . = ALIGN(4);
    } > FLASH
    .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } > FLASH
    .ARM.exidx :
    {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
    } > FLASH
    .preinit_array :
    {
        PROVIDE_HIDDEN(__preinit_array_start = .);
        KEEP(*(.preinit_array*))
        PROVIDE_HIDDEN(__preinit_array_end = .);
    } > FLASH
    .init_array :
    {
        PROVIDE_HIDDEN(__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        PROVIDE_HIDDEN(__init_array_end = .);
    } > FLASH
    .fini_array :
    {
        PROVIDE_HIDDEN(__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array))
        PROVIDE_HIDDEN(__fini_array_end = .);
    } > FLASH
    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data .data.*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT > FLASH
    _sidata = LOADADDR(.data);
    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss .bss.* COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM
    .noinit (NOLOAD) :
    {
        *(.noinit .noinit.*)
        . = ALIGN(8);
        _end = .;
        PROVIDE(end = .);
    } > RAM
    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        . += _Min_Stack_Size;
    } > RAM
    .ARM.attributes 0 : { *(.ARM.attributes) }
    ASSERT(_end + _Min_Stack_Size <= _estack, "RAM overflow: no room for stack")
}
