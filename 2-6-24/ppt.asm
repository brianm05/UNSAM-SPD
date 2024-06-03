.8086
.model small
.stack 100h
.data
	eleccion db 0,24h
	eleccionCPU db 0,24h
	result db 0,24h

	bienvenida db "Bienvenido al menu.",0dh,0ah,24h
	error db "Opcion no valida.",0dh,0ah,24h
	adios db "Adios.",0dh,0ah,24h

	salir  db "[0] Para salir.",0dh,0ah,24h
	juego1 db "[1] Piedra, papel y tijera.",0dh,0ah,24h
	juego2 db "[2] El juego de los numeros.",0dh,0ah,24h

.code

						;Estructura y funcinamiento del programa:
						;La funcion cargaNombre (actualmente en la libreria 'pptlib') sirve para guardar el nombre del usuario.
						;La funcion limpiarPantalla (actualmente en la libreria 'pptlib') sirve para limpiar la pantalla y reacomodar el cursor.
						;Usamos la etiqueta 'menu' para que el usuario eliga la opcion que desee. Una vez elegida la opcion usamos las otras etiquetas
							;para navegar por las distintas opciones. En cada "sub"-etiqueta se hacen llamados a funciones que hay un una librearia externa.
						;Se usa la interrupcion 10h para el color del texto y limpiar la pantalla (agregado a la interrupcion 21h para mostrar por pantalla).
						;En la libreria externa esta incluida la funcion Random que es utilizada para generar la eleccion del piedra, papel o tijera.


;Funciones que estan dentro de la misma libreria 'pptlib' pero son mas genericas.
;================================
	extrn cargaNombre:proc
	extrn limpiarPantalla:proc
;================================


;FUNCIONES EXTERNAS PARA EL JUEGO DE PIEDRA, PAPEL O TIJERA
;================================
	extrn bienvenidaPPT:proc
	extrn cargaUser:proc
	extrn mostrarCarga:proc
	extrn cargaCPU:proc
	extrn mostrarCargaCPU:proc
	extrn resultado:proc
	extrn mostrarResultado:proc
;================================


	main proc
		mov ax, @data
		mov ds, ax


		call limpiarPantalla

		call cargaNombre

	menu:
		;Mostrar mensaje por pantalla.
		mov ah,2
		mov dl,0dh
		int 21h

		;COLORES	0=black	1=blue	2=green	3=aqua	4=red			5=purple	6=yellow		7=white			8=gray	
		;			9=light blue	A=light green	B=light aqua	C=light red	D=light purple	E=light yellow	F=bright white
		mov ah,09h
		mov bl,06h	;left=background color ||	right=foreground color
		mov cl,13h	;cantidad de caracteres
		int 10h

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
	 	mov eleccion,al


		call limpiarPantalla
	 	;Saltar a la eleccion del usuario.
	 	cmp al,'0'
	 	je finProc
	 	cmp al,'1'
	 	je ppt
	 	cmp al,'2'
	 	je nums


	 	mov ah,09h
		mov bl,04h	;left=background color ||	right=foreground color
		mov cl,11h	;cantidad de caracteres
		int 10h

		;Mostrar mensaje por pantalla.
		mov ah,9
		mov dx,offset error
		int 21h
		jmp menu

	 ppt:
		call bienvenidaPPT

		;La funcion cargaUser retorna en AL la eleccion del usuario
		call cargaUser
	 	mov eleccion,al

		;Espera en AL la eleccion del usuario e imprime en pantalla la eleccion (en palabras).
	 	mov al,eleccion
	 	call mostrarCarga

		;Retorna en AL un numero aleatorio del 1 al 3 como caracter ascii.
		call cargaCPU
		mov eleccionCPU,al

		;Espera en AL la eleccion del CPU e imprime en pantalla la eleccion (en palabras).
		mov al,eleccionCPU
	 	call mostrarCargaCPU


	 	mov ah,eleccion
	 	mov al,eleccionCPU
	 	;Espera en AH la eleccion del usuario y espera en AL la eleccion CPU.
	 	;Retorna en AL el resultado. 0:Empataste - 1:Ganaste - 2:Perdiste
	 	call resultado 
	 	mov result,al

	 	mov al,result
		;Espera en AL el resultado del juego y lo imprime en pantalla con palabras.
	 	call mostrarResultado

	 	jmp menu

	 nums:

	 	;CODIGO DEL JUEGO DE LOS NUMEROS
		jmp menu

	 finProc:

		mov ah,09h
		mov bl,0f0h	;left=background color ||	right=foreground color
		mov cl,06h	;Cantidad de caracteres.
		int 10h

		mov ah,9
		mov dx,offset adios
		int 21h

		mov ax, 4c00h
		int 21h

	main endp
end main
