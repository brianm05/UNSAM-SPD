.8086
.model small
.stack 100h

.data

	bienvenidaText db "Bienvenido al Piedra, Papel o Tijera",0dh,0ah,24h
	piedraText db "[1] Piedra.",0dh,0ah,24h
	papelText db "[2] Papel.",0dh,0ah,24h
	tijeraText db "[3] Tijera.",0dh,0ah,24h
	cpu db "CPU: ",24h
	piedra db "Piedra",0dh,0ah,24h
	papel db "Papel",0dh,0ah,24h
	tijera db "Tijera",0dh,0ah,24h
	empateText db "EMPATASTE!",0dh,0ah,24h
	ganasteText db "GANASTE!",0dh,0ah,24h
	perdisteText db "PERDISTE!",0dh,0ah,24h

	eleccion db 0
	eleccionCPU db 0,24h
	result db 0,24h
	aux db 0,24h
	
.code

extrn imprimirColor:proc
extrn imprimirTexto:proc
extrn random:proc

public pptFunc


pptFunc proc 	
	call mostrarBienvenida

	;Guardamos la eleccion del usuario
	mov ah, 8
	int 21h
	mov eleccion,al

	call mostrarCarga

	call cargaCPU

	call mostrarCargaCPU

	call resultado

	call mostrarResultado
	ret
pptFunc endp

;Imprime en pantalla la bienvenida al juego y las opciones.
mostrarBienvenida proc
	push si

	lea si, bienvenidaText
	push si
	call imprimirTexto

	lea si, piedraText
	push si
	call imprimirTexto

	lea si, papelText
	push si
	call imprimirTexto

	lea si, tijeraText
	push si
	call imprimirTexto

	pop si
	ret
mostrarBienvenida endp

;Imprime en pantalla la eleccion (en palabras).
mostrarCarga proc
		push dx
		push ax

		;En 'dx' esta el offset de userName
		mov ah,9
		int 21h

		mov ah,2
		mov dx,':'
		int 21h

		mov ah,2
		mov dx,' '
		int 21h

	 	cmp eleccion,'1'
	 	je piedraUser

	 	cmp eleccion,'2'
	 	je papelUser

		cmp eleccion,'3'
	 	je tijeraUser

	piedraUser:
		lea si, piedra
		push si
		call imprimirTexto
		jmp finFunc
	papelUser:
		lea si, papel
		push si
		call imprimirTexto
		jmp finFunc
	tijeraUser:
		lea si, tijera
		push si
		call imprimirTexto
		jmp finFunc
	finFunc:

		pop ax
		pop dx
		ret 
mostrarCarga endp

;Guarda en la varible 'eleccionCPU' un numero aleatorio del 1 al 3 como caracter ascii.
cargaCPU proc
		push ax
	;generarNum genera un numero aleatorio usando la funcion random, se ejectua hasta conseguir un numero distinto de 0.
	generarNum:
		call random
		cmp al,0
		je generarNum

	mayorQueTres: ;Verifica que el numero generado esta entre 1 y 3. Si el numero es mas grande que 3, se le restan 3.
		cmp al,3
		ja restar

		jmp finNum

	restar:
		sub al,3
		jmp mayorQueTres

	finNum:	;Una vez que el numero entre 1 y 3 fue generado, se le suman 48 para obtener el caracter ascii. Se retorna por AL.
		add al,48
		mov eleccionCPU,al
		pop ax
		ret
cargaCPU endp

;Imprime en pantalla la eleccion (en palabras).
mostrarCargaCPU proc
		push dx
		push ax

		;Mostramos "cpu: " antes de imprimir la eleccionCPU.
		mov ah,9
		mov dx,offset cpu
		int 21h

		cmp eleccionCPU,'1'
		je piedraCPU
		cmp eleccionCPU,'2'
		je papelCPU
		cmp eleccionCPU,'3'
		je tijeraCPU

	piedraCPU:
		lea si, piedra
		push si
		call imprimirTexto
		jmp finCPU
	papelCPU:
		lea si, papel
		push si
		call imprimirTexto
		jmp finCPU
	tijeraCPU:
		lea si, tijera
		push si
		call imprimirTexto
		jmp finCPU
	finCPU:
		pop ax
		pop dx
		ret
mostrarCargaCPU endp


;Compara la eleccion del usuario y de CPU. Guarda en la variable 'result' el resultado. 0:Empataste - 1:Ganaste - 2:Perdiste
resultado proc
	push ax
	mov ah,eleccion
	
	compara:

		cmp ah,eleccionCPU
		je Empate

		cmp ah,'1'
		je comparaPiedra
		cmp ah,'2'
		je comparaPapel
		cmp ah,'3'
		je comparaTijera

	comparaPiedra:
		cmp eleccionCPU,'2'
		je Perdiste
		cmp eleccionCPU,'3'
		je Ganaste

	comparaPapel:
		cmp eleccionCPU,'1'
		je Ganaste
		cmp eleccionCPU,'3'
		je Perdiste

	comparaTijera:
		cmp eleccionCPU,'2'
		je Ganaste
		cmp eleccionCPU,'1'
		je Perdiste

	Empate:
		mov al,0
		jmp finResult
	Ganaste:
		mov al,1
		jmp finResult
	Perdiste:
		mov al,2
		jmp finResult

	finResult:
		mov result,al
		pop ax
		ret
resultado endp

;Comprueba el resultado del juego y lo imprime en pantalla (con palabras).
mostrarResultado proc
		push dx
		push bx
		push cx

		cmp result,0
		je empateImp
		
		cmp result,1
		je ganasteImp
		
		cmp result,2
		je perdisteImp

	ganasteImp:
		mov bl,02h	;left=background color ||	right=foreground color || VER LISTA DE COLORES
		mov cl,08h	;cantidad de caracteres
		call imprimirColor

		lea si, ganasteText
		push si
		call imprimirTexto

		jmp FinFuncion
	perdisteImp:
		mov bl,04h	;left=background color ||	right=foreground color || VER LISTA DE COLORES
		mov cl,09h	;cantidad de caracteres
		call imprimirColor

		lea si, perdisteText
		push si
		call imprimirTexto

		jmp FinFuncion
	empateImp:
		mov bl,08h	;left=background color ||	right=foreground color || VER LISTA DE COLORES
		mov cl,0ah	;cantidad de caracteres
		call imprimirColor

		lea si, empateText
		push si
		call imprimirTexto

		jmp FinFuncion
	FinFuncion:
		pop cx
		pop bx
		pop dx
		ret
mostrarResultado endp

end