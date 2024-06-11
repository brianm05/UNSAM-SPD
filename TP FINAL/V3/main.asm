.8086
.model small
.stack 100h
.data
	pedirNombre db "Ingrese su nombre.",0dh,0ah,24h
	userName db 255 dup (24h),24h

	eleccion db 0,24h

	;adios db "Adios, ",0dh,0ah,24h
	adios db "Adios, ",24h
	gracias db ". Gracias por su tiempo.",0dh,0ah,24h



.code

;FUNCIONES PARA MENU + FUNCIONES GENERICAS. (todas en la libreria 'menu.asm')
;================================
	extrn limpiarPantalla:proc
	extrn cargaTexto:proc
	extrn imprimirTexto:proc
	extrn imprimirColor:proc
	extrn menu:proc
	extrn error:proc
;================================


;FUNCIONES EXTERNAS PARA EL JUEGO DE PIEDRA, PAPEL O TIJERA (en la libreria 'ppt.asm')
;================================
	extrn pptFunc:proc
;================================


;FUNCIONES EXTERNAS PARA EL JUEGO DE PIEDRA, PAPEL O TIJERA (en la libreria 'nums.asm')
;================================
	extrn numFunc:proc
;================================


	main proc
		mov ax, @data
		mov ds, ax

		call limpiarPantalla

	;Carga de nombre
		;---------------------------------------
		lea si, pedirNombre
		push si
		call imprimirTexto

		lea si,userName		;Guardamos el offset de la variable. 
		push si				;Pusheamos el offset.
		call cargaTexto		;Llamamos a la funcion para cargar una variable. (Con el offset pasado por stack).
		;---------------------------------------


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
	 	je num

	 	;Si no se cumple ninguna comparacion anterior significa que el caracter ingresado no es reconocido como opcion. Por lo que se muestra un mensaje de error. 
	 	call error
		jmp menuLabel

	 ppt:
	 	lea dx,userName		;La funcion pptFunc necesita que en 'DX' este el offset de userName. 
	 	call pptFunc
	 	jmp menuLabel

	 num:	
		call numFunc
		jmp menuLabel

	 finProc:

		;mov bl,0f0h	;left=background color ||	right=foreground color
		;mov cl,06h	;Cantidad de caracteres.
		;call imprimirColor

		lea si, adios
		push si
		call imprimirTexto

		lea si, userName
		push si
		call imprimirTexto

		lea si, gracias
		push si
		call imprimirTexto

		;------------
		mov ax, 4c00h
		int 21h

	main endp
end main