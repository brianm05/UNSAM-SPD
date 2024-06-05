.8086
.model small
.stack 100h
.data

.code


	public imprimir
	public carga
	public cifrar
	public encuentra

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
			mov [bx], 24h
			pop ax
			pop dx
			pop bx
			ret
	carga endp

	;Con push and pop(por stack). Recibe por push: En 'SI' el offset del texto.
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
end