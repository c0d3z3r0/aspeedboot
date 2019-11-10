/*
 * aspeed bootloader
 *
 * This is open source software, governed by the BSD 3-Clause License.
 *
 * Original work:
 * Copyright 2018 the u-root Authors. All rights reserved
 *
 * Derived work:
 * Copyright (C) 2019 Michael Niewöhner <foss@mniewoehner.de>
 */

#include "config.h"


/*
 * DMA load from flash
 *
 * r7: flash address
 * r8: size
 * r9: memory address
 * r10: FMC
 */
dma_load:
	/* save return address */
	mov r13, lr

	/* set up DMA parameters */
	str r7, [r10, #0x84]	@ flash address
	str r9, [r10, #0x88]	@ memory address
	sub r8, r8, #4		@ DMA size = size-4 according to datasheet
	str r8, [r10, #0x8C]	@ DMA size

	/* start DMA */
	mov r1, #0x1
	str r1, [r10, #0x80]

/* wait for dma to complete */
dma_wait:
	ldr r1, [r10, #0x8C]	@ DMA size left
	cmp r1, #0x0
	bne dma_wait


	/* disable DMA */
	mov r1, #0x0
	str r1, [r10, #0x80]

	/* jump back to return address in boot */
	mov pc, r13

/* start code jumps here */
main:
	.global main

/* boot sequence */
boot:
	ldr r7, =kernel_start	@ DMA flash source address
	ldr r8, =kernel_size	@ DMA size
	ldr r9, =0x41000000	@ DMA sdram target address
	ldr r10, =0x1e620000	@ FMC

	bl dma_load

	/* kernel boot args */
	mov r0, #0
	mov r1, #-1
	mov r2, #0

	/* jump to kernel code */
	ldr pc, =0x41000000
