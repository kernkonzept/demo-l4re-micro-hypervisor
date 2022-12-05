#ifndef GIC_H
#define GIC_H

#include "FreeRTOS.h"

#define gic_acc(off) \
	(*((uint32_t*)(off)))
#define gic_read(off, var) \
	var = *((uint32_t*)(off))
#define gic_write(off, val) \
	*((uint32_t*)(off)) = (val)
#define gic_set(off, bit) \
	*((uint32_t*)(off)) |= (bit)

//#define GIC_DIST_BASE			0x50800000
#define GIC_DIST_BASE			0xf0000000

void gic_setup_interrupt(uint32_t irq_id);
void gic_setup(void);
uint32_t gic_get_irq(void);
void gic_ack_irq(uint32_t irq_id);

#endif
