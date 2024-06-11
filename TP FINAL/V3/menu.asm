.8086
.model small
.stack 100h

.data

	bienvenida db "Bienvenido al menu.",0dh,0ah,24h
	salir  db "[0] Para salir.",0dh,0ah,24h
	juego1 db "[1] Piedra, papel y tijera.",0dh,0ah,24h
	juego2 db "[2] El juego de los numeros.",0dh,0ah,24h
	mensajeError db "Opcion no valida.",0dh,0ah,24h


.code


public cargaTexto
public imprimirTexto

public limpiarPantalla
public imprimirColor
public menu
public error
public random

limpiarPantalla proc
	push ax
	push bx
	push cx
	push dx

	mov ah, 06h       ; BIOS function 06h: Scroll up window
	mov al, 00h       ; Number of lines to scroll up (0 = clear entire window)
	mov bh, 07h       ; Attribute used to write blank lines (07h = light gray on black)
	mov cx, 0000h     ; Upper-left corner of window (row=0, column=0)
	mov dx, 184Fh     ; Lower-right corner of window (row=24, column=79)
	int 10h           ; Call BIOS video interrupt

	;reubicar cursor
	mov ah, 02h
	mov bh, 00h
	mov dh, 00h
	mov dl, 00h
	int 10h

	pop dx
	pop cx
	pop bx
	pop ax
	ret
limpiarPantalla endp

;Carga una variable de texto. El offset de la variable se tiene que pasar por stack desde el main (u otra funcion).
cargaTexto proc
	push bp
	mov bp, sp
	push dx
	push ax
	push bx	
	mov bx, ss:[bp+4]	;Colocamos en 'bx' el offset del texto a llenar.

		carga:
			mov ah, 01h
			int 21h

			cmp al, 0dh
			je fin_carga

			mov byte ptr [bx], al
			inc bx

			cmp bx, 255
			je fin_carga

			jmp carga
		fin_carga:		

	pop bx
	pop ax
	pop dx
	pop bp
	ret 2
cargaTexto endp

;Imprime una variable de texto. El offset de la variable se tiene que pasar por stack desde el main (u otra funcion).
imprimirTexto proc
	push bp

	mov bp, sp

	push dx
	push ax

	mov dx, ss:[bp+4]

	mov ah,9
	int 21h

	pop ax
	pop dx
	pop bp
	ret 2
imprimirTexto endp


;La funcion "menu" retorna un numero (la eleccion del usuario) en el registro 'AL'.
menu proc
	push dx
	push cx
	push bx

	;Imprmir salto de linea.
	mov ah,2
	mov dl,0dh
	int 21h

	mov bl,06h	;left=background color ||	right=foreground color
	mov cl,13h	;cantidad de caracteres de "Bienvenido al menu."
	call imprimirColor

	;Mostrar mensajes por pantalla.
	lea si, bienvenida
	push si
	call imprimirTexto

	lea si, salir
	push si
	call imprimirTexto

	lea si, juego1
	push si
	call imprimirTexto

	lea si, juego2
	push si
	call imprimirTexto

	;Guardar eleccion del usuario.
	mov ah,8 	;	8->sin eco
 	int 21h
 	;mov eleccion,al  ;LA ELECCION YA QUEDO GUARDADO EN 'AL'

 	pop bx
 	pop cx
 	pop dx
	ret
menu endp

error proc
	push bx
	push cx
	push ax
	push dx

	mov bl,04h	;left=background color ||	right=foreground color
	mov cl,11h	;cantidad de caracteres
	call imprimirColor

	;Mostrar mensajes por pantalla.
	lea si, mensajeError
	push si
	call imprimirTexto
	
	pop dx
	pop ax
	pop cx
	pop bx
	ret
error endp

;Establece Color y BackgroundColor de los proximos caracteres. Tienen que pasarle previamente, por registros, la cantidad de caracteres en 'CL'
;y el color en 'BL'. El color (en 'BL') se divide en dos (El primer caracter hexa es el BackgroundColor y el segundo caracter hexa es el Color). 
imprimirColor proc
	;COLORES	0=black	1=blue	2=green	3=aqua	4=red			5=purple	6=yellow		7=white			8=gray	
	;			9=light blue	A=light green	B=light aqua	C=light red	D=light purple	E=light yellow	F=bright white
	push ax

	mov ah,09h
	int 10h

	pop ax
	ret
imprimirColor endp

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

end
