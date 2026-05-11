[BITS 16] ; Real Mode
[ORG 0x7c00] ; Setting where should this be loaded in memory (not guaranteed)


main:
	mov ax, 0x0000
	mov ds, ax
	mov si, msg ; setting up si for LODSB instruction
	call print_msg
	jmp $ ; loop (jumping into the current instruction)

print_msg:
	.setup:
		mov bl, 0xF ; RED Color
		mov bh, 0
		mov ah, 0x0e ; Teletype output
		
	.nextChar:
		lodsb ; load byte from si into al and increment siby 1
		or al, al
		jz .return
		
		int 0x10
		jmp .nextChar
	.return:
		ret
		
; DATA

msg db "Hello, World", 0

times 510 - ($ - $$) db 0 ; fill the rest of mbr struct with 0s
; until the last two bytes 
db 0x55
db 0xAA
