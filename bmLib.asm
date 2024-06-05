
;En libreria:
	public funcion
;===============
;En main:
	entrn funcion:proc


;regToAscii
;Sin push and pop(por stack). Convierte un registro en una variable ascii.
	;==============================================================================================================================================================
	;----------------------
		nroAscii db '000',0dh,0ah,24h
		dataDiv db 100 ,10 ,1 
		posicion db 0
	;----------------------
		mov dl, posicion
		lea bx, nroAscii
		lea si, dataDiv
		call regToAscii
	;----------------------


	;Espera en 'DL' el numero a convertir. Espera en 'BX' el offset de la variable donde guardar el numero ascii ("000").
	;Espera en 'SI' el offset de dataDiv (variable que contiene 100,10,1 nacesaria para poder dividir).
	regToAscii proc
			push ax
			push dx
			push cx
			push si
			push bx

			xor ax, ax		;Limpiamos 'AX'
			mov al, dl

			mov cx, 3 		;Valores para el correcto uso del dataDiv

			;ACA EMPIEZA EL CODIGO
		proceso:
			mov dl, [si]
			div dl 
			add [bx],al 
			xchg al, ah  	;INTERCAMBIA VALORES
			xor ah, ah 
			inc bx 
			inc si
		loop proceso
		
			pop bx
			pop si
			pop cx
			pop dx
			pop ax
			ret
	regToAscii endp
;==============================================================================================================================================================

;asciiToReg
;Sin push and pop(por stack). Convierte una variable ascii en un registro.
	;==============================================================================================================================================================
	;----------------------
		nroLeido db '000',24h
		dataDiv db 100 ,10 ,1 
	;----------------------
		lea bx, nroLeido
		lea si, dataDiv
		call asciiToReg
	;----------------------

	;Espera en 'BX' el offset de una variable donde esta guardado el numero ascii ("000"). Devuelve en 'DL' el valor correspondiente.
	asciiToReg proc 
			push cx
			push ax
			push si

			mov dx,0
			
			mov cx, 3
		sigue:
			mov al, [bx]
			sub al, 30h
			mov dl, [si]
			mul dl
			add dh, al
			xor ax, ax
			inc bx
			inc si
		loop sigue
			mov dl, dh
			mov dh, 0
			pop si
			pop ax
			pop cx
		ret
	asciiToReg endp
;==============================================================================================================================================================

;carga
;Sin push and pop(por stack). Espera en 'DX' el offset de la variable a llenar y en 'AL' el caracter de finalizacion 
	;==============================================================================================================================================================
	;----------------------
		texto db 255 dup (24h), 0dh, 0ah, 24h
	;----------------------
		mov dx, offset texto
		mov al, 0dh
		call carga  			
	;----------------------


	;Espera en 'DX' el offset de la variable a llenar y en 'AL' el caracter de finalizacion
	carga proc
			push bx
			push dx
			push ax

			mov bx, dx 			;CARGO EL OFFSET EN BX
			mov dl, al 			;MUEVO EL CARACTER DE FINALIZACIÖN A DL
		cargaTexto:
			mov ah, 1
			int 21h
			cmp al, dl
			je finCarga 
			mov [bx], al 
			inc bx
			jmp cargaTexto
		finCarga:
			pop ax
			pop dx
			pop bx
			ret
	carga endp
;==============================================================================================================================================================

;imprimir
;Con push and pop(por stack). Recibe por push: En 'SI' el offset del texto.
	;==============================================================================================================================================================
	;----------------------
		texto db 255 dup (24h), 0dh, 0ah, 24h
	;----------------------
		lea si, texto
		push si
		call imprimir 			
	;----------------------
	imprimir proc

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

	imprimir endp
;==============================================================================================================================================================

;Cifrar un texto agregando un numero a su ascii 
;Con push and pop(por stack).
	;==============================================================================================================================================================
	;----------------------
	texto db "Programa para texto cifrado",0dh,0ah, 24h
	cifrado db "Programa para texto cifrado",0dh,0ah, 24h
	cant db 1
	;----------------------
	lea dx,texto
	push dx
	lea dx,cifrado
	push dx
	lea dx,cant
	push dx
	call cifrar
	;----------------------
	;Recibe por stack offsets el texto, textoCif y cantidad. Devuelve el texto cifrado en el offset de textoCif
	cifrar proc
			push bp
			mov bp, sp
			push bx
			push si 
			push ax

			mov bx, ss:[bp+8]
			mov si, ss:[bp+4]
			mov al, byte ptr [si]
			mov si, ss:[bp+6]

		cifrando:
			cmp byte ptr[bx], 24h
			je finCifrado
			mov ah, [bx]
			add ah, al 
			mov [si],ah 
			inc si
			inc bx

			jmp cifrando

		finCifrado:
			pop ax
			pop si
			pop bx
			pop bp
			ret 6
	cifrar endp
;==============================================================================================================================================================

;encuentra
;Con push and pop(por stack). Encuentra un caracter en un texto. Retorna la posicion.
	;==============================================================================================================================================================
	;----------------------
		texto db 255 dup (24h), 0dh, 0ah, 24h
		posicion db 0
	;----------------------
		mov dx, offset texto 	;Offset variable a revisar
		mov al, 'a'				;Caracter a buscar
		mov ah, 0  				;Limpiamos el resto de AX
		push dx
		mov dx, offset posicion
		push dx
		push ax
		call encuentra
	;----------------------

	;Recibe por push: En 'DX' el offset del texto. En 'AL' el caracter a buscar (hay que limpiar 'AH').
	;En 'DX' el offset de la posicion. Devuelve 255 si no se encuantra.
	encuentra proc
			;porque [bp+4] y no [bp+2]? porque lo primero que sea hace al entrar a la funcion en un push bp. por lo que [bp+2]==bp 
			;CARÁCTER		ss:[bp+4]
			;OFFSET POS		ss:[bp+6]
			;OFFSET TEXTO	ss:[bp+8]

			push bp
			mov bp, sp
			push bx
			push ax
			push si 

			mov bx, ss:[bp+8]
			mov si, ss:[bp+6]
			mov ax, ss:[bp+4]

			xor ah, ah 

		procEncuentro:
			cmp [bx], byte ptr 24h
			je finEncuentra
			cmp [bx], al
			je encontrado
			inc ah 
			inc bx
		jmp procEncuentro

		encontrado:
			inc ah
			mov [si], byte ptr ah ; CANTIDAD
			jmp final	

		finEncuentra:	
			mov [si], byte ptr 255; DEVUELVO CODIGO DE ERROR NO ENCONTRÖ
		final:
			pop si
			pop ax
			pop bx
			pop bp
			ret 6 			;ret 6 por la cantidad de push's previos a la funcion
	encuentra endp
;==============================================================================================================================================================

;RANDOM - Devuelve en AL un número del 0 al 9 usando los milisegundos del la función TIME$
	;==============================================================================================================================================================
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
;==============================================================================================================================================================

;limpiar la pantalla
;Sin push and pop(por stack).
	;==============================================================================================================================================================
	limpiarPantalla proc
		push ax
		push bx
		push cx
		push dx

		mov ah, 06h
		mov al, 00h
		mov bh, 07h
		mov cx, 0000h
		mov dx, 184Fh
		int 10h

		;Reubicar cursor
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
;==============================================================================================================================================================

public reinicioCarga 	 ;  
			 ; DH = Caracter para replicar (Ej: 0dh, 24h)
			 ; DL= Cantidad de caracteres a reiniciar:
			 ; 255, TEXTO
			 ; 3, DEC
			 ; 2, HEX
			 ; 8, BIN
			 ;
			 ; BX offset variable a llenar ("reiniciar")

reinicioCarga proc 
	;reinicio variables de tipo texto

		push bp
		mov bp, sp
		push cx
		push si
		push dx

		mov si, ss:[bp+4]

		mov cl, dl
	cargaX:
		mov byte ptr[si], dh
		inc si
	loop cargaX
		
		pop dx 
		pop si 
		pop cx 
		pop bp 

		ret 2

	reinicioCarga endp

public largoCadena    ;suma los caracteres ingresados hasta el '$'
largoCadena proc
	;recibe en bx el offset de una variable devuelvo cantidad de caracteres hasta encontrar $ en cx

		xor cx, cx 
		push bx
	largo:
		cmp byte ptr [bx], 24h 
		je fin
		inc bx
		inc cx 
		jmp largo

	fin:
	 	pop bx
	 ret
	largoCadena endp