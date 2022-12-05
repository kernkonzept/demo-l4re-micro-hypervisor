	.extern main
	.global _start
	.global vPortYieldProcessor
	.global vPortIRQHandler
	.global vPortSwitchContext

	.section ".vectors", "ax"

.balign 64
_start:
	b		reset
	b		hang_undef_instr
	b		vPortYieldProcessor
	b		hang_fetch_abort
	b		hang_data_abort
	b		hang
	b		FreeRTOS_IRQ_Handler
	b		hang_FIQ

hang:
	b		hang
hang_undef_instr:
	b		hang_undef_instr
hang_fetch_abort:
	b		hang_fetch_abort
hang_data_abort:
	b		hang_data_abort
hang_FIQ:
	b		hang_FIQ

reset:
	# set VBAR
	ldr		r0, =_start
	mcr		p15, 0, r0, c12, c0, 0
	# load stack base
	ldr		r0, =.Lstack
	bic		r0, r0, #7
	# set IRQ stack
	msr		cpsr_c, 0xd2
	mov		sp, r0
	sub		r0, r0, #256
	# set application stack
	msr		cpsr_c, 0xd3
	mov		sp, r0
	bl		main

FreeRTOS_IRQ_Handler:
	/* Return to the interrupted instruction. */
	SUB		lr, lr, #4

	/* Push the return address and SPSR. */
	PUSH	{lr}
	MRS		lr, SPSR
	PUSH	{lr}

	/* Change to supervisor mode to allow reentry. */
	CPS		#19

	/* Push used registers. */
	PUSH	{r0-r4, r12}

	/* Call the interrupt handler. */
	PUSH	{r0-r3, lr}
	LDR		r1, =vPortIRQHandler
	BLX		r1
	mov		r4, r0
	POP		{r0-r3, lr}

	/* Did the interrupt request a context switch?  r1 holds the address of
	ulPortYieldRequired and r0 the value of ulPortYieldRequired for future
	use. */
	CMP		r4, #0
	BNE		switch_before_exit

exit_without_switch:
	/* No context switch.  Restore used registers, LR_irq and SPSR before
	returning. */
	POP		{r0-r4, r12}
	CPS		#18
	POP		{LR}
	MSR		SPSR_cxsf, LR
	POP		{LR}
	MOVS	PC, LR

switch_before_exit:
	/* Restore used registers, LR-irq and SPSR before saving the context
	to the task stack. */
	POP		{r0-r4, r12}
	CPS		#18
	POP		{LR}
	MSR		SPSR_cxsf, LR
	POP		{LR}
	b		vPortSwitchContext


.bss
.balign 16
.space 4096
.Lstack:
