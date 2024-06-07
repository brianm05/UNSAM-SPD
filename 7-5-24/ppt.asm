.8086
.model small
.stack 100h
.data
	userName db 255 dup (24h),24h

	eleccion db 0,24h
	eleccionCPU db 0,24h
	result db 0,24h

	adios db "Adios.",0dh,0ah,24h



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
	extrn limpiarPantalla:proc
	extrn cargaNombre:proc
	extrn imprimirColor:proc
	extrn menu:proc
	extrn error:proc
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

		lea si,userName
		push si
		call cargaNombre

		mov ah,9
		mov dx,offset userName
		int 21h

	menuLabel:
		;La funcion "menu" retorna un numero (la eleccion del usuario) en el registro 'AL'.
		call menu
		mov eleccion,al

		call limpiarPantalla

	 	;Saltar a la eleccion del usuario.
	 	cmp al,'0'
	 	je finProc
	 	cmp al,'1'
	 	je ppt
	 	cmp al,'2'
	 	je nums

	 	;Si no se cumple ninguna comparacion anterior significa que el caracter ingresado no es reconocido como opcion. Por lo que se muestra un mensaje de error. 
	 	call error
		jmp menuLabel


	 ppt:
		call bienvenidaPPT

		;La funcion cargaUser retorna en AL la eleccion del usuario
		call cargaUser
	 	mov eleccion,al

		;Espera en AL la eleccion del usuario e imprime en pantalla la eleccion (en palabras).
	 	mov al,eleccion
	 	lea dx,userName
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

	 	jmp menuLabel

	 nums:

	 	;CODIGO DEL JUEGO DE LOS NUMEROS
		jmp menuLabel

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