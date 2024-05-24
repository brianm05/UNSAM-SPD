.8086
.model small
.stack 100h
.data
	eleccion db 0,24h
	eleccionCPU db 0,24h
	piedraVar db "Piedra",0dh,0ah,24h
	papelVar db "Papel",0dh,0ah,24h
	tijeraVar db "Tijera",0dh,0ah,24h
	bienvenida db "Bienvenido al Piedra[1], Papel[2] o Tijera[3]",0dh,0ah,24h
	empateVar db "EMPATASTE!",0dh,0ah,24h
	ganasteVar db "GANASTE!",0dh,0ah,24h
	perdisteVar db "PERDISTE!",0dh,0ah,24h


.code

	extrn random:proc
	


	main proc
		mov ax, @data
		mov ds, ax

		mov ah,9
		mov dx,offset bienvenida
		int 21h

;carga del usuario
	 	mov ah, 8
	 	int 21h
	 	cmp al, 0dh
	 	mov eleccion,al

	 	cmp eleccion,'1'
	 	je piedraUser

	 	cmp eleccion,'2'
	 	je papelUser

		cmp eleccion,'3'
	 	je tijeraUser

piedraUser:
		mov ah,9
		mov dx,offset piedraVar
		int 21h
		jmp finCargaUsuuario
papelUser:
		mov ah,9
		mov dx,offset papelVar
		int 21h
		jmp finCargaUsuuario
tijeraUser:
		mov ah,9
		mov dx,offset tijeraVar
		int 21h
		jmp finCargaUsuuario
finCargaUsuuario:

intentar:
		call random
		cmp al,0
		je intentar
mayorQueTres:		
		cmp al,3
		ja restar

		jmp finNum
restar:
		sub al,3
		jmp mayorQueTres

finNum:
		add al,48
		mov eleccionCPU,al
		cmp al,'1'
		je piedraCPU
		cmp al,'2'
		je papelCPU
		cmp al,'3'
		je tijeraCPU


piedraCPU:
		mov ah,9
		mov dx,offset piedraVar
		int 21h
		jmp finCPU
papelCPU:
		mov ah,9
		mov dx,offset papelVar
		int 21h
		jmp finCPU
tijeraCPU:
		mov ah,9
		mov dx,offset tijeraVar
		int 21h
		jmp finCPU
finCPU:


compara:
		mov al,eleccionCPU

		cmp eleccion,al
		je Empate

		cmp eleccion,'1'
		je comparaPiedra
		cmp eleccion,'2'
		je comparaPapel
		cmp eleccion,'3'
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


Ganaste:
		mov ah,9
		mov dx,offset ganasteVar
		int 21h
		jmp finProc
Perdiste:
		mov ah,9
		mov dx,offset perdisteVar
		int 21h
		jmp finProc
Empate:
		mov ah,9
		mov dx,offset empateVar
		int 21h
		jmp finProc

finProc:
		mov ax, 4c00h
		int 21h





	main endp
end main

