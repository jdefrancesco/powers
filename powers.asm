; Source: powers.asm - quickest way to determine if a number is a power 
;					   of two
; Author: Joey DeFrancesco
;
; Build:
;	nasm -felf -g -F stabs powers.asm
;	gcc powers.o -o powers
; 
; Notes:
;	Limit input value: - 2147483647

BITS 32

[Section .data] ; initialized data

PromptMsg: db "Enter digit: ", 0x00
InPrompt:  db '%d', 0x00
OutFmtString: db "%d is a power of two!",0x0A, 0x00
FailString:	db "Sorry, %d is not a power of two.",0x0A, 0x00

[Section .bss] ; uninitialized data

IntVal resd 1 	; reserve double word for input by user

[Section .text] ; code

; importing function from glibc
extern printf
extern puts
extern scanf

	global main ; entry point 

main:

	nop  ; to keep gdb happy

	; prolog  (C calling convention)
	push ebp 
	mov  ebp, esp
	push ebx
	push esi
	push edi

	; printf() - output string
	push PromptMsg
	call printf 
	add esp, 4	; clean stack, one arg
	
	; scanf() - get input from user
	push IntVal
	push InPrompt
	call scanf
	add esp, 8

	; Determine if number is indeed a power of two.
	; (x AND (x-1)) == 0, then x is power of two else it is not
	mov eax, [IntVal]
	dec eax
	and dword eax, [IntVal]	
	cmp eax, 0
	jz .Success


.Fail:  ; not a power of two

	; printf()
	push dword [IntVal]
	push FailString 
	call printf
	add esp, 8 ; fixed.

	jmp .Exit

.Success: ; input was a power of two

	; printf() - display success string
	push dword [IntVal]
	push OutFmtString
	call printf
	add esp, 8 

.Exit:
	; Epilog (C calling convention)
	pop edi
	pop esi
	pop ebx
	mov esp, ebp
	pop ebp
	ret	; return control to linux


; End

