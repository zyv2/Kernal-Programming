

## Setup
```
nasm
IDE / vim
qemu-system-0x86_0x64
make (optional)
```

### Bootloader

```c

[BITS 16] ; real mode

load:
	mov al, '!' ; our char
	mov bx, 0 ; page num idk
	mov cx, 0x3 ; how many times to print it
	mov ah, 0Ah ; call write_char()
	int 0x10
	
	jmp % ; jmp to the same instruction
	
times 512 - (% - %%) db 0 ; fill the rest with zeros

; our signature
db 0x55
db 0xaa

```















