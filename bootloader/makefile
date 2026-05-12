src  = bootloader.asm
as   = nasm
out  = boot.bin
vm   = qemu-system-x86_64
build:
	$(as) -f bin $(src) -o $(out)

run:
	$(vm) -hda $(out) -boot c


all: build run

clean: $(out)
	rm $(out)
