[BITS 16] ; Real Mode
[ORG 0x7c00] ; Setting where should this be loaded in memory (not guaranteed)


main:
	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax ; stack setup
	mov sp, 0x7c00 ; downwards growth

	call .print_banner
	
.loop:	
	mov di, buffer
	call skinny_scanf


	mov di, buffer
	mov si, cm_hi
	call skinny_strcmp
	jc .print_hi

	mov si, cm_hi2
	call skinny_strcmp
	jc .print_hi2 

	mov si, cm_help
	call skinny_strcmp
	jc .print_help	
	
	mov si, cm_sleep
	call skinny_strcmp
	jc .print_sleep

	; if not supported command is entered
	jmp .print_error
	


; User stuff
.print_banner:
	mov si, banner
	call skinny_printf
	jmp .loop
.print_hi:
	mov si, answer1
	call skinny_printf
	jmp .loop

.print_hi2:
	mov si, answer2
	call skinny_printf
	jmp .loop
.print_help:
	mov si, help
	call skinny_printf 
	jmp .loop
.print_error:
	mov si, error
	call skinny_printf
	jmp .loop
.print_sleep:
	mov si, sleep
	call skinny_printf
	jmp .loop

; Print Massages To The SCREEN
; NEEDs SI Setup
skinny_printf:
.setup:
	mov bl, 0xF ; Color (wont work on the emulator but there is some workarounds)
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

; READ USER STUFF
; NEEDs DI setup
skinny_scanf:
	; index counter
	xor cl, cl
.loop:
	mov ah, 0x00
	int 0x16 ; wait key press
	
	; compare with backspace
	cmp al, 0x08
	jz .backspace
	
	; compare with enter
	cmp al, 0x0D
	jz .done
	
	; buffer safety
	; only allow enter/backspace
	cmp cl, 63
	jz .loop
	
	; print  normal char to screen
	mov ah, 0x0e
	int 0x10
	
	; store in a the buffer for later
	stosb
	; increase the index to watch out for memory
	inc cl	
	jmp .loop
	
.backspace:
	; if the user is backspacing when nothing is written do nothin
	cmp cl, 0x00
	jz .loop

	; print backspace (move cursor backwards 1)
	mov al, 0x08
	mov ah, 0x0e
	int 0x10
	
	; delete char pointed to by the cursor
	mov al, ' '
	int 0x10

	; backspace again to balance the cursor to right place
	mov al, 0x08
	int 0x10
	
	
	dec di ; decrese pointer to buffer by one
	mov byte [di], 0 ; zero the byte
	dec cl ; decrease the index counter

	jmp .loop
	
.done:
	; null termenation
	mov al, 0
	sotsb
	
	; mov cursor to a new line
	mov al, 0x0D
	mov ah, 0x0e
	int 0x10

	mov al, 0x0a
	int 0x10
	
	ret

; Util Strings compare function
; take first arg into edi
; take second arg into esi
; return : setting the CF to 0 or 1
skinny_strcmp:

.loop:
	mov al, [di]
	mov bl, [si]
	cmp al, bl
	jnz .not_equal
	cmp al, 0
	jz .equal
	inc edi
	inc esi
	jmp .loop
.not_equal:
	clc ; set CF to 0
	ret
.equal:
	stc ; set CF to 1
	ret
	

; DATA
cm_hi    db  "say_hi", 0x00
cm_hi2   db  "SAY_HI", 0x00
cm_help  db  "help", 0x00
cm_sleep db  "sleep", 0x00

answer1  db  "Do you think I work for you?", 0x0D, 0x0A, 0x00
answer2  db  "OK OK relax dont yell, can you tell me your name first?", 0x0D, 0x0A, 0x00

banner db "Hello, BTW im not a 0xDEADBEEF..Why did you wake me up?!", 0x0D, 0x0A, 0x00
help db "Listen Here, this is me helping you: say_hi, help, sleep", 0x0D, 0x0A, 0x00
error db "No Try Again"         , 0x0D, 0x0A, 0x00
sleep db "What A Waste Of Time.", 0x0D, 0x0A, 0x00

buffer times 16 db 0

; End DATA
times 510 - ($ - $$) db 0 ; fill the rest of mbr struct with 0s
; until the last two bytes 
db 0x55
db 0xAA
