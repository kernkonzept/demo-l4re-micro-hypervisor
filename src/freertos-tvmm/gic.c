#include "gic.h"

void gic_setup_interrupt(uint32_t irq_id)
{
        // set IGROUPRn
        gic_set(GIC_DIST_BASE + 0x80 + (irq_id/32)*4, (1 << (irq_id % 32)));
	// set ISENABELRn
	gic_set(GIC_DIST_BASE + 0x100 + (irq_id/32)*4, (1 << (irq_id % 32)));
	// set ITARGETSn
	gic_set(GIC_DIST_BASE + 0x800 + (irq_id/4)*4, (0x01 << 8*(irq_id%4)));
	// set ICFGRn to level sensitive
	// TODO should be bitclear
	gic_write(GIC_DIST_BASE + 0xc00 + (irq_id/16)*4, 0);
}

void gic_setup(void)
{
  // we need to use system register access. uvmm does not provide mmio for cpu
  // interface
  asm volatile("mcr p15, 0, %0, c12, c12, 5" // ICC_SRE
               : : "r" (0x7));

	// timer interrupt: dts irq 11 -> irq_id 27
	gic_setup_interrupt(27);
	// enable Group 1 interrupts
	asm volatile("mcr p15, 0, %0, c12, c12, 7" : : "r" (1)); // ICC_IGRPEN1
	// set ICC_PRM
	asm volatile("mcr p15, 0, %0, c4, c6, 0" : : "r"(0xff));

	// configure distributor control register, enable group 1NS irqs
	gic_write(GIC_DIST_BASE, 0x2);
}

uint32_t gic_get_irq(void)
{
	// read IAR
  uint32_t v;
  asm volatile("mrc p15, 0, %0, c12, c12, 0" : "=r"(v));
  return v;
}

void gic_ack_irq(uint32_t irq_id)
{
	// set EOIR
	asm volatile("mcr p15, 0, %0, c12, c12, 1" : : "r"(irq_id));
}
