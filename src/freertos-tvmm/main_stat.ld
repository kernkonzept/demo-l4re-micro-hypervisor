       
OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm",
              "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)
PHDRS
{
  ro PT_LOAD;
  rw PT_LOAD;
}
SECTIONS
{
  PROVIDE (__executable_start = SEGMENT_START("text-segment", 0x00010000));
  . = __executable_start + SIZEOF_HEADERS;
  /DISCARD/ :
  { *(.note.gnu.build-id)
  *(.hash)
  *(.gnu.hash)
  *(.dynsym)
  *(.dynstr)
  *(.gnu.version)
  *(.gnu.version_d)
  *(.gnu.version_r)
  *(.rel.init)
  *(.rela.init)
  *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)
  *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)
  *(.rel.fini)
  *(.rela.fini)
  *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)
  *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)
  *(.rel.data.rel.ro* .rel.gnu.linkonce.d.rel.ro.*)
  *(.rela.data.rel.ro* .rela.gnu.linkonce.d.rel.ro.*)
  *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)
  *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)
  *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)
  *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)
  *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)
  *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)
  *(.rel.ctors)
  *(.rela.ctors)
  *(.rel.dtors)
  *(.rela.dtors)
  *(.rel.got)
  *(.rela.got)
  *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)
  *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)
  *(.rel.plt)
  *(.rela.plt)
  *(.plt) }
  .text :
  {
    _stext = .;
    _prog_img_start = _stext;
    *(.text.init)
    *(.init)
    *(.vectors)
    *(.text .text.* .gnu.linkonce.t.*)
    KEEP (*(.text.*personality*))
    *(.glue_7t) *(.glue_7)
    *(.gnu.warning)
  } :ro = 0
  .init :
  {
    KEEP (*(.init))
  } =0x90909090
  .fini :
  {
    KEEP (*(.fini))
  } = 0x9090
  . = ALIGN(0x40);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);
  .rol4re_elf_aux : {
    KEEP (*(.rol4re_elf_aux))
  } : ro : l4re_aux
  .rodata : { *(.rodata .rodata.* .gnu.linkonce.r.*) } : ro
  .rodata1 : { *(.rodata1) }
  .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) }
  __exidx_start = .;
  .ARM.exidx : { *(.ARM.exidx* .gnu.linkonce.armexidx.*) }
  __exidx_end = .;
  .eh_frame_hdr : { *(.eh_frame_hdr) } :ro
  .eh_frame : ONLY_IF_RO
  {
    KEEP (*(.eh_frame))
  } :ro
  .gcc_except_table : ONLY_IF_RO { *(.gcc_except_table .gcc_except_table.*) }
  . = ALIGN(CONSTANT(MAXPAGESIZE));
  . = ALIGN (CONSTANT (MAXPAGESIZE)) - ((CONSTANT (MAXPAGESIZE) - .) & (CONSTANT (MAXPAGESIZE) - 1)); . = DATA_SEGMENT_ALIGN (CONSTANT (MAXPAGESIZE), CONSTANT (COMMONPAGESIZE));
  PROVIDE (_sdata = .);
  .eh_frame : ONLY_IF_RW
  {
    KEEP (*(.eh_frame))
  } :rw
  .gcc_except_table : ONLY_IF_RW { *(.gcc_except_table .gcc_except_table.*) } :rw
  .tdata : { *(.tdata .tdata.* .gnu.linkonce.td.*) } :rw : tls
  .tbss : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) }
  .preinit_array :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } : rw
  .init_array :
  {
     PROVIDE_HIDDEN (__init_array_start = .);
     KEEP (*(SORT(.init_array.*)))
     KEEP (*(.init_array))
     PROVIDE_HIDDEN (__init_array_end = .);
  }
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(.fini_array))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE_HIDDEN (__fini_array_end = .);
  }
  . = ALIGN(4K);
  .ctors :
  {
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  } :rw
  . = ALIGN(4);
  .dtors :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  }
  .got : { *(.got.plt) *(.igot.plt) *(.got) *(.igot) }
  .data :
  {
    *(.data .data.* .gnu.linkonce.d.*)
    KEEP (*(.gnu.linkonce.d.*personality*))
    SORT(CONSTRUCTORS)
  }
  .data1 : { *(.data1) }
  _edata = .; PROVIDE (edata = .);
  __bss_start = .;
  .bss :
  {
   *(.dynbss)
   *(.bss .bss.* .gnu.linkonce.b.*)
   *(COMMON)
   . = ALIGN(. != 0 ? 32 / 8 : 1);
  }
  . = ALIGN(32 / 8);
  . = ALIGN(32 / 8);
  _end = .; PROVIDE (end = .);
  . = DATA_SEGMENT_END (.);
  . = ALIGN(CONSTANT(MAXPAGESIZE));
  .stab 0 : { *(.stab) } :NONE
  .stabstr 0 : { *(.stabstr) }
  .stab.excl 0 : { *(.stab.excl) }
  .stab.exclstr 0 : { *(.stab.exclstr) }
  .stab.index 0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment 0 : { *(.comment) }
  .debug 0 : { *(.debug) }
  .line 0 : { *(.line) }
  .debug_srcinfo 0 : { *(.debug_srcinfo) }
  .debug_sfnames 0 : { *(.debug_sfnames) }
  .debug_aranges 0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev 0 : { *(.debug_abbrev) }
  .debug_line 0 : { *(.debug_line) }
  .debug_frame 0 : { *(.debug_frame) }
  .debug_str 0 : { *(.debug_str) }
  .debug_loc 0 : { *(.debug_loc) }
  .debug_macinfo 0 : { *(.debug_macinfo) }
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames 0 : { *(.debug_varnames) }
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges 0 : { *(.debug_ranges) }
  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.interp) }
}
