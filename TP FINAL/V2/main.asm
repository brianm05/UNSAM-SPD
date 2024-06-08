.8086
.model small
.stack 100h
.data
	userName db 255 dup (24h),24h

	eleccion db 0,24h

	adios db "Adios.",0dh,0ah,24h



.code

;FUNCIONES PARA MENU + FUNCIONES GENERICAS. (todas en la libreria 'menu.asm')
;================================
	extrn limpiarPantalla:proc
	extrn cargaNombre:proc
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

		lea bx,userName
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
	 	je num

	 	;Si no se cumple ninguna comparacion anterior significa que el caracter ingresado no es reconocido como opcion. Por lo que se muestra un mensaje de error. 
	 	call error
		jmp menuLabel


	 ppt:
	 	lea dx,userName		;La funcion pptFunc necesita que en 'DX' este el offset de userName. 
	 	call pptFunc
	 	jmp menuLabel

	 num:
	 	;CODIGO DEL JUEGO DE LOS NUMEROS
		call numFunc

		jmp menuLabel

	 finProc:

		mov bl,0f0h	;left=background color ||	right=foreground color
		mov cl,06h	;Cantidad de caracteres.
		call imprimirColor

		mov ah,9
		mov dx,offset adios
		int 21h

		mov ax, 4c00h
		int 21h

	main endp
end main