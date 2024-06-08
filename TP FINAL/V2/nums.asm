.8086
.model small
.stack 100h

.data

	bienvenidaText db "Bienvenido al juego de los numeros.",0dh,0ah,24h
	espere db "Espere por favor...",0dh,0ah,24h
	ingreseText db "Ingrese un numero de 4 digitos.",0dh,0ah,24h
	numeroSecreto db "0000",0dh,0ah,24h
	numeroUsuario db "0000",0dh,0ah,24h
	numeroAux db "0000",0dh,0ah,24h

	ganasteText db "GANASTE!",0dh,0ah,24h
	perdisteText db "PERDISTE!",0dh,0ah,24h

	num db 0
	;ciclo dw 7FDh
	ciclo dw 0FDh
.code

extrn imprimirColor:proc
extrn random:proc
extrn limpiarPantalla:proc

public numFunc


numFunc proc

		call bienvenidaNum

		call generarNumero

		mov bx,0
	bucle:
		cmp bx,5
		je finBucle

		call ingresarNum
		call compararNums

		inc bx
		jmp bucle

	finBucle:

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

generarNumero proc
	push bx
	push ax
	push dx
		mov bx,0
	numeroAleatorio:
		cmp bx,4
		je finAleatorio

		call random
		call espereImp
		call nops
		call limpiarPantalla


		add al,48

		mov numeroSecreto[bx], al
		xor al,al
		inc bx
		jmp numeroAleatorio

	finAleatorio:
		mov ah,9
		mov dx,offset numeroSecreto
		int 21h
	pop dx
	pop ax
	pop bx
	ret
generarNumero endp

ingresarNum proc
	push ax
	push dx
	push bx
	
	inrgrese:
		mov ah,9
		mov dx,offset ingreseText
		int 21h

		mov bx,offset numeroUsuario
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
	pop dx
	pop ax
	ret
ingresarNum endp

compararNums proc
		push bx
		push cx
		push ax
		push dx
		push si

		mov si,0
	comparar:
		cmp si,4
		je finCompara
		mov al,numeroSecreto[si]
		cmp al,numeroUsuario[si]
		je imprimirVerde

		jmp imprimirRojo


	imprimirVerde:
		mov bl,02h	;left=background color ||	right=foreground color || VER LISTA DE COLORES
		mov cl,01h	;cantidad de caracteres
		call imprimirColor

		mov ah,2
		mov dl,numeroUsuario[si]
		int 21h

		inc si
		jmp comparar
	imprimirRojo:
		mov bl,04h	;left=background color ||	right=foreground color || VER LISTA DE COLORES
		mov cl,01h	;cantidad de caracteres
		call imprimirColor

		mov ah,2
		mov dl,numeroUsuario[si]
		int 21h
		inc si
		jmp comparar
	imprimirAmarillo:


	finCompara:
		mov ah,9
		;mov dx,offset numeroUsuario
		int 21h
		
		pop si
		pop dx
		pop	ax
		pop cx
		pop bx
	ret
compararNums endp

;Imprime por pantalla la bienvenida al juego.
espereImp proc
	push ax
	push dx

	mov ah,9
	mov dx,offset espere
	int 21h

	pop dx
	pop ax
	ret
espereImp endp

nops proc
	push bx
	push ax
	push cx
	push si

	;mov si,0ffah
	mov si,ciclo
	mov cx,0FFFFh
			delayLoop:
		    nop          ; No-operation (consume un ciclo de reloj)
		    nop          ; No-operation
		    nop          ; No-operation
		    nop          ; No-operation
		    dec cx       ; Decrementa CX para contar las iteraciones
		    jnz delayLoop ; Salta de nuevo a delayLoop si CX no es cero
	    dec si
	    cmp si,0
	    jne delayLoop
    
    pop si
    pop cx
	pop ax
	pop bx
    ret
nops endp




end