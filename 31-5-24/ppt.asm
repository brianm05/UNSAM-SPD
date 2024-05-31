.8086
.model small
.stack 100h
.data
	eleccion db 0,24h
	eleccionCPU db 0,24h
	result db 0,24h
;	piedraVar db "Piedra",0dh,0ah,24h
;	papelVar db "Papel",0dh,0ah,24h
;	tijeraVar db "Tijera",0dh,0ah,24h
;	empateVar db "EMPATASTE!",0dh,0ah,24h
;	ganasteVar db "GANASTE!",0dh,0ah,24h
;	perdisteVar db "PERDISTE!",0dh,0ah,24h


.code

	extrn bienvenida:proc
	extrn cargaUser:proc
	extrn mostrarCarga:proc
	extrn cargaCPU:proc
	extrn mostrarCargaCPU:proc
	extrn resultado:proc
	extrn mostrarResultado:proc

	main proc
		mov ax, @data
		mov ds, ax

		call bienvenida

		;La funcion cargaUser retorna en AL la eleccion del usuario
		call cargaUser
	 	mov eleccion,al

	 	mov al,eleccion
	 	call mostrarCarga

		call cargaCPU
		mov eleccionCPU,al

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

		mov ax, 4c00h
		int 21h

	main endp
end main
