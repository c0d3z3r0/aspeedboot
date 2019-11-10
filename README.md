# aspeed bootloader

## What is it?

This is a minimal bootloader for starting a Linux kernel on ASPEED SoCs.
Currently only AST2400 is implemented.

The initialization code (`platform*.S`) comes from the ASPEED SDK. Some
other parts were borrowed from `u-boot` and `u-bmc`.

## Limitations

Since the goal was to only do the minimal requirements to boot a Linux kernel, the bootloader
has a very limited feature set. At least the following features are not supported:

* no ATAGS support
* no cmdline support: kernel built-in / devicetree only
* no initramfs support: All drivers needed at boot time must be built-in. If you really need a initramfs, you
may include one in your kernel by specifying `CONFIG_INITRAMFS_SOURCE` in the kernel config.
* no devicetree loading support: A devicetree can either be built-in or appended to the kernel
image (see kernel config `CONFIG_ARM_APPENDED_DTB`).
* ...

## License

Copyright (C) 2019 Michael Niewöhner

This is open source software. Refer to the license header in each covered file.
See `licenses/` for the full licenses.
