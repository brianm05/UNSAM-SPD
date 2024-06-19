;-----------------------------------------------------------------------
; Programa TSR que se instala en el vector de interrupciones 80h
; que suma AX a BX a traves de la int 80h
; Se debe generar el ejecutable .COM con los siguientes comandos:
;	tasm tsr2.asm
;	tlink /t tsr2.obj
;-----------------------------------------------------------------------
.8086
.model tiny		; Definicion para generar un archivo .COM
.code
   org 100h		; Definicion para generar un archivo .COM
start:
   jmp main		; Comienza con un salto para dejar la parte residente primero

;------------------------------------------------------------------------
;- Part que queda residente en memoria y contine las ISR
;- de las interrupcion capturadas
;------------------------------------------------------------------------
Funcion PROC FAR
   ; La funcion ISR que atendera la interrupcion capturada
        push ax
        push bx
        push cx
        push dx

        mov ah, 06h       ; BIOS function 06h: Scroll up window
        mov al, 00h       ; Number of lines to scroll up (0 = clear entire window)
        mov bh, 07h       ; Attribute used to write blank lines (07h = light gray on black)
        mov cx, 0000h     ; Upper-left corner of window (row=0, column=0)
        mov dx, 184Fh     ; Lower-right corner of window (row=24, column=79)
        int 10h           ; Call BIOS video interrupt

        ;reubicar cursor
        mov ah, 02h
        mov bh, 00h
        mov dh, 00h
        mov dl, 00h
        int 10h

        pop dx
        pop cx
        pop bx
        pop ax
    iret
endp

; Datos usados dentro de la ISR ya que no hay DS dentro de una ISR
DespIntXX dw 0
SegIntXX  dw 0

FinResidente LABEL BYTE		; Marca el fin de la porción a dejar residente
;------------------------------------------------------------------------
; Datos a ser usados por el Instalador
;------------------------------------------------------------------------
Cartel    DB "Interrupcion instalada exitosamente.",0dh, 0ah, '$'

main:
; Se apunta todos los registros de segmentos al mismo lugar CS.
    mov ax,CS
    mov DS,ax
    mov ES,ax

InstalarInt:
    mov AX,3580h        ; Obtiene la ISR que esta instalada en la interrupcion
    int 21h    
         
    mov DespIntXX,BX    
    mov SegIntXX,ES

    mov AX,2580h	; Coloca la nueva ISR en el vector de interrupciones
    mov DX,Offset Funcion 
    int 21h

MostrarCartel:
    mov dx, offset Cartel
    mov ah,9
    int 21h

DejarResidente:		
    Mov     AX,(15+offset FinResidente) 
    Shr     AX,1            
    Shr     AX,1        ;Se obtiene la cantidad de paragraphs
    Shr     AX,1
    Shr     AX,1	;ocupado por el codigo
    Mov     DX,AX           
    Mov     AX,3100h    ;y termina sin error 0, dejando el
    Int     21h         ;programa residente
end start