.8086
.model small
.stack 100h

.data
	pedirNombre db "Ingrese su nombre.",0dh,0ah,24h

	bienvenida db "Bienvenido al menu.",0dh,0ah,24h
	salir  db "[0] Para salir.",0dh,0ah,24h
	juego1 db "[1] Piedra, papel y tijera.",0dh,0ah,24h
	juego2 db "[2] El juego de los numeros.",0dh,0ah,24h
	mensajeError db "Opcion no valida.",0dh,0ah,24h


.code

public cargaNombre

public imprimirColor
public menu
public error


;Pide el nombre.
cargaNombre proc
	push bp
	mov bp, sp

	push bx
	push ax
	push dx
	push si

	mov si, ss:[bp+2]

	mov ah,9
	mov dx,offset pedirNombre
	int 21h

	mov bx, 0
	carga:
		mov ah, 1
		int 21h
		cmp al, 0dh
		je finCarga
		mov [si],al

		inc si
	jmp carga

	finCarga:

	mov byte ptr[si],':'
	inc si
	mov byte ptr[si],' '
	inc si
	mov byte ptr[si],'$'

	pop si
	pop dx
	pop ax
	pop bx
	pop bp
	ret 2
cargaNombre endp


;La funcion "menu" retorna un numero (la eleccion del usuario) en el registro 'AL'.
menu proc
	push dx

	;Imprmir salto de linea.
	mov ah,2
	mov dl,0dh
	int 21h

	mov bl,06h	;left=background color ||	right=foreground color
	mov cl,13h	;cantidad de caracteres de "Bienvenido al menu."
	call imprimirColor

	;Mostrar mensaje por pantalla.
	mov ah,9
	mov dx,offset bienvenida
	int 21h

	;Mostrar mensaje por pantalla.
	mov ah,9
	mov dx,offset salir
	int 21h

	;Mostrar mensaje por pantalla.
	mov ah,9
	mov dx,offset juego1
	int 21h

	;Mostrar mensaje por pantalla.
	mov ah,9
	mov dx,offset juego2
	int 21h

	;Guardar eleccion del usuario.
	mov ah,8 	;	8->sin eco
 	int 21h
 	;mov eleccion,al  ;LA ELECCION YA QUEDO GUARDADO EN 'AL'

 	pop dx
	ret
menu endp

error proc
	 
	mov bl,04h	;left=background color ||	right=foreground color
	mov cl,11h	;cantidad de caracteres
	call imprimirColor

	;Mostrar mensaje por pantalla.
	mov ah,9
	mov dx,offset mensajeError
	int 21h
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

end