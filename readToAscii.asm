.8086
.model small
.stack 100h
.data
		reg db 076
		nro db '000',0dh,0ah,24h
		multi db 100,10,1
.code
	main proc
		mov ax, @data
		mov ds, ax

		mov bx,0
		mov si,0

		mov al,reg
bucle:
		mov ah,0
		mov dl,multi[bx]
		div dl
		add nro[si],al
		mov al,ah
		inc bx
		inc si
		cmp bx,2
		jne bucle

		add nro[2],ah

imprimir:
		mov ah, 9
		lea dx, nro
		int 21h

		mov ax, 4c00h
		int 21h
	main endp

	end main.8086
.model small
.stack 100h
.data
		reg db 076
		nro db '000',0dh,0ah,24h
		multi db 100,10,1
.code
	main proc
		mov ax, @data
		mov ds, ax

		mov bx,0
		mov si,0

		mov al,reg
bucle:
		mov ah,0
		mov dl,multi[bx]
		div dl
		add nro[si],al
		mov al,ah
		inc bx
		inc si
		cmp bx,2
		jne bucle

		add nro[2],ah

imprimir:
		mov ah, 9
		lea dx, nro
		int 21h

		mov ax, 4c00h
		int 21h
	main endp

	end main
