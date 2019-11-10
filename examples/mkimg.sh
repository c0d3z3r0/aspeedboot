#!/bin/sh

rm flash.img
dd if=/dev/zero | tr '\000' '\377' | dd iflag=fullblock bs=1M count=32 of=flash.img
dd conv=notrunc if=boot.bin of=flash.img
dd conv=notrunc bs=64k if=zImage of=flash.img seek=1
#dd conv=notrunc bs=64k if=ubi.img of=$@ seek=$$(($$(grep SIZE= platform/ubmc-flash-layout.dtsi | cut -d= -f2) / 65536))
