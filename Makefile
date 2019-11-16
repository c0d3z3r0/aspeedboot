#
# aspeed bootloader
#
# This is open source software, governed by the BSD 3-Clause License.
#
# Original work:
# Copyright 2018 the u-root Authors
#
# Derived work:
# Copyright (C) 2019 Michael Niewöhner <foss@mniewoehner.de>


.PHONY: all clean

DEBUG ?= 0

CROSS_COMPILE ?= arm-none-eabi-
CC := $(CROSS_COMPILE)gcc
OBJCOPY := $(CROSS_COMPILE)objcopy


all: boot.bin

boot.elf: start.S platform_g4.S main.S
	$(CC) -DDEBUG=$(DEBUG) -Wall -Wl,-T boot.ld -Wl,--no-dynamic-linker -nostdlib -I $(CURDIR) -o $@ $^

boot.bin: boot.elf
	$(OBJCOPY) --only-section=.text -O binary $< $@

clean:
	$(RM) boot.elf boot.bin
