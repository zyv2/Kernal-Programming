[bits 16] ; Real Mode


boot:	mov al, 'A' ; char to be printed
	mov bh, 00h ; page number??
	mov cx, 4   ; number of times to print
	mov ah, 0ah ; printchar()
	int 0x10    ; intrrupt

times 510 - ($ - $$) db 0 ; fill the rest of mbr struct with 0s
; until the last two bytes 
db 0x55
db 0xAA
