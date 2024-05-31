.8086
.model small
.stack 100h

.data

	pedirNombre db "Cual es tu nombre?",0dh,0ah,24h
	bienvenidaText db "Bienvenido al Piedra[1], Papel[2] o Tijera[3]",0dh,0ah,24h

	user db 255 dup (24h),24h

	cpu db "CPU: ",24h
	
	piedra db "Piedra",0dh,0ah,24h
	papel db "Papel",0dh,0ah,24h
	tijera db "Tijera",0dh,0ah,24h

	aux db 0,24h

	empateText db "EMPATASTE!",0dh,0ah,24h
	ganasteText db "GANASTE!",0dh,0ah,24h
	perdisteText db "PERDISTE!",0dh,0ah,24h

.code

public bienvenida
public cargaUser
public mostrarCarga
public cargaCPU
public mostrarCargaCPU
public resultado
public mostrarResultado
public cargaNombre

;Pide el nombre.
cargaNombre proc
	push bx
	push ax

	mov ah,9
	mov dx,offset pedirNombre
	int 21h

	mov bx, 0
	carga:
		mov ah, 1
		int 21h
		cmp al, 0dh
		je finCarga
		mov user[bx],al

		inc bx
	jmp carga

	finCarga:

	mov user[bx],':'
	inc bx
	mov user[bx],' '
	inc bx
	mov user[bx],'$'

	pop ax
	pop bx
	ret
cargaNombre endp

;Imprime por pantalla la bienvenida al programa.
bienvenida proc
		push ax

		mov ah,9
		mov dx,offset bienvenidaText
		int 21h

		pop ax
		ret
bienvenida endp

;Lee la eleccion del usuario y la retorna en al.
cargaUser proc
	 	mov ah, 8
	 	int 21h
	 	cmp al, 0dh

		ret
cargaUser endp

;Espera en AL la eleccion del usuario e imprime en pantalla la eleccion (en palabras).
mostrarCarga proc
		push dx

		;Mostramos "user: " antes de imprimir la eleccion.
		mov ah,9
		mov dx,offset user
		int 21h

	 	cmp al,'1'
	 	je piedraUser

	 	cmp al,'2'
	 	je papelUser

		cmp al,'3'
	 	je tijeraUser

	piedraUser:
		mov ah,9
		mov dx,offset piedra
		int 21h
		jmp finFunc
	papelUser:
		mov ah,9
		mov dx,offset papel
		int 21h
		jmp finFunc
	tijeraUser:
		mov ah,9
		mov dx,offset tijera
		int 21h
		jmp finFunc
	finFunc:

		pop dx
		ret
mostrarCarga endp

;Retorna en AL un numero aleatorio del 1 al 3 como caracter ascii.
cargaCPU proc

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
		ret
cargaCPU endp

;Espera en AL la eleccion del CPU e imprime en pantalla la eleccion (en palabras).
mostrarCargaCPU proc
		push dx

		;Mostramos "cpu: " antes de imprimir la eleccionCPU.
		mov ah,9
		mov dx,offset cpu
		int 21h

		cmp al,'1'
		je piedraCPU
		cmp al,'2'
		je papelCPU
		cmp al,'3'
		je tijeraCPU

	piedraCPU:
		mov ah,9
		mov dx,offset piedra
		int 21h
		jmp finCPU
	papelCPU:
		mov ah,9
		mov dx,offset papel
		int 21h
		jmp finCPU
	tijeraCPU:
		mov ah,9
		mov dx,offset tijera
		int 21h
		jmp finCPU
	finCPU:
		pop dx
		ret
mostrarCargaCPU endp


;Espera en AH la eleccion del usuario y espera en AL la eleccion CPU. Retorna en AL el resultado. 0:Empataste - 1:Ganaste - 2:Perdiste
resultado proc
	mov aux,al 		;Usamos una variable auxiliar para guardar eleccionCPU.

	compara:

		cmp ah,aux
		je Empate

		cmp ah,'1'
		je comparaPiedra
		cmp ah,'2'
		je comparaPapel
		cmp ah,'3'
		je comparaTijera

	comparaPiedra:
		cmp aux,'2'
		je Perdiste
		cmp aux,'3'
		je Ganaste
	comparaPapel:
		cmp aux,'1'
		je Ganaste
		cmp aux,'3'
		je Perdiste
	comparaTijera:
		cmp aux,'2'
		je Ganaste
		cmp aux,'1'
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
		ret
resultado endp

;Espera en AL el resultado del juego y lo imprime en pantalla (con palabras).
mostrarResultado proc
		push dx
		cmp al,0
		je empateImp
		
		cmp al,1
		je ganasteImp
		
		cmp al,2
		je perdisteImp

	ganasteImp:
		mov ah,9
		mov dx,offset ganasteText
		int 21h
		jmp FinFuncion
	perdisteImp:
		mov ah,9
		mov dx,offset perdisteText
		int 21h
		jmp FinFuncion
	empateImp:
		mov ah,9
		mov dx,offset empateText
		int 21h
		jmp FinFuncion
	FinFuncion:

		pop dx
		ret
mostrarResultado endp


;=======================================================================
; PROCESO ALEATORIO - Devuelve en AL un número del 0 al 9 usando los 
; milisegundos del la función TIME$
;=======================================================================
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
;=======================================================================

end
