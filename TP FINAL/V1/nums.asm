.8086
.model small
.stack 100h

.data

	bienvenidaText db "Bienvenido al juego de los numeros.",0dh,0ah,24h
	numeroSecreto db "7654",0dh,0ah,24h
	ganasteText db "GANASTE!",0dh,0ah,24h
	perdisteText db "PERDISTE!",0dh,0ah,24h

	num db 0
		
.code

extrn imprimirColor:proc
extrn random:proc

public numFunc


numFunc proc
		call bienvenidaNum

		mov bx,0
	numeroAleatorio:
		cmp bx,4
		je finAleatorio
		call random
		call delay
   
		add al,48

		mov numeroSecreto[bx], al
		xor al,al
		mov numeroSecreto[bx], dl
		xor dl,dl
		inc bx
		jmp numeroAleatorio

	finAleatorio:
		mov ah,9
		mov dx,offset numeroSecreto
		int 21h

		ret
numFunc endp


;Imprime por pantalla la bienvenida al juego.
bienvenidaNum proc
	push ax
	push dx

	mov ah,9
	mov dx,offset bienvenidaText
	int 21h

	pop dx
	pop ax
	ret
bienvenidaNum endp


;DELAY 500000 (7A120h).
delay proc
	push cx
	push dx
	push ax

	mov cx, 7      ;HIGH WORD.
	mov dx, 0A120h ;LOW WORD.
	mov ah, 86h    ;WAIT.
	int 15h
	
	pop ax
	pop dx
	pop cx
	ret
delay endp

RANDGEN PROC        ; generate a rand no using the system time
	RANDSTART:
	   MOV AH, 00h  ; interrupts to get system time        
	   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      
	                ; lets just take the lower bits of DL for a start..
	   MOV BH, 57   ; set limit to 57 (ASCII for 9) 
	   MOV AH, DL  
	   CMP AH, BH   ; compare with value in  DL,      
	   JA RANDSTART ; if more, regenerate. if not, continue... 

	   MOV BH, 49   ; set limit to 48 (ASCII FOR 0)
	   MOV AH, DL   
	   CMP AH, BH   ; compare with value in DL
	   JB RANDSTART ; if less, regenerate.   


	   ; if not, this is what we need 
	   mov ah, 2h   ; call interrupt to display a value in DL
	   int 21h    
	RET
RANDGEN ENDP


end