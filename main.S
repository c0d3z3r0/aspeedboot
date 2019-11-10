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

xfer:
	// r0: uart to write to
	// r7: flash addr
	// r8: mem addr
	// r9: size
	// r10: FMC
	// r11: string to print
	mov r13, lr

	// Start DMA load of kernel
	str r7, [r10, #0x84]
	str r8, [r10, #0x88]
	// The DMA size is the actual size -4 according to the datasheet
	ldr r1, [r9]
	sub r1, r1, #4
	str r1, [r10, #0x8C]
	mov r1, #0x1
	str r1, [r10, #0x80]

	// Wait for DMA to complete
2:
	ldr r1, [r10, #0x8C]
	cmp r1, #0x0
	bne 2b


	mov r1, #0x0
	str r1, [r10, #0x80]
	mov pc, r13


	.globl _main
_main:
	ldr r10, =0x1e620000  // Static memory controller (FMC)

	// Start DMA load of kernel
	ldr r7,  =kernel_start
	// Load the kernel higher than 0x40008000 + size to avoid an extra relocation
	ldr r8,  =0x41000000
	ldr r9,  =kernel_size
	bl xfer

	// Start DMA load of DTB
	ldr r7,  =dtb_start
	ldr r8,  =CONFIG_DTB_START
	ldr r9,  =dtb_size
	bl xfer

	// Start DMA load of initrd
	ldr r7,  =initrd_start
	ldr r8,  =CONFIG_INITRD_START
	ldr r9,  =initrd_size
	bl xfer

	mov r0, #0x0
	sub r1, r0, #0x1
	ldr r2,  =CONFIG_DTB_START
	mov r3, #0x0
	mov r4, #0x0
	mov r5, #0x0
	mov r6, #0x0
	mov r7, #0x0
	mov r8, #0x0
	mov r9, #0x0
	mov r10, #0x0
	mov r11, #0x0
	mov r12, #0x0
	mov r13, #0x0
	mov r14, #0x0
	ldr pc, =0x41000000
