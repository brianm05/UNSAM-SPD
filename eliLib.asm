.8086
.model small
.stack 100h

.data


		;variables utilizadas en la libreria
.code

public random
public lectura

lectura proc
		;recibe en ah el modo de trabajo (0 para indefinido, 1 para definido por cantidad de caracteres)
		;recibe en al el parametro modificador segun el modo
			; MODO 0 (0 corta con 0dh, 1 corta con 24h, si no es ninguno de esos cortará con el ascii del caracter ingresado en al)
			; MODO 1 se ingresará la cantidad de lecturas que realizará la funcion
		;recibe en dx el offset de la variable donde se guardará el texto

		push cx
		push bx
		push ax
		push si
		push dx

		xor cx, cx
		mov bx, dx
		mov si, bx
		add si, 255
		cmp ah, 0
		je modo0
		mov cl, al
carga:	mov ah, 1
		int 21h
		mov byte ptr [bx], al
		inc bx 
		loop carga
		jmp finLectura

modo0: 
		cmp al, 0
		je finEnter
		cmp al, 1
		je finPesos
		mov dl, al
		jmp continuar

finEnter:
		mov dl, 0dh
		jmp continuar
finPesos:
		mov dl, 24h
		jmp continuar

continuar:

		mov ah, 1
		int 21h
		cmp al, dl
		je finLectura
		cmp bx, si
		je finLectura
		mov [bx], al
		inc bx
		jmp continuar

finlectura:

		pop dx
		pop si
		pop ax
		pop bx
		pop cx
		ret
	lectura endp


;=======================================================================
; PROCESO ALEATORIO - Devuelve en AL un número del 0 al 9 usando los 
; milisegundos del la función TIME$
;=======================================================================
random proc
		push cx
		push dx
		mov ah, 2ch
		int 21h
		xor ax, ax
		mov al, dl
		mov cl, 0ah
		div cl
		xor ah, ah
		pop dx
		pop cx
		ret
random endp

;=======================================================================




end ;asi terminamos la libreria
