; --- Mapeamento de Hardware (8051) ---
  RS      equ     P1.3    ;Reg Select ligado em P1.3
  EN      equ     P1.2    ;Enable ligado em P1.2


org 0000h
LJMP START

org 0030h
;STRINGS
	FEI:
	DB "BURGUER FEI"
	DB 00h ;Marca null no fim da String
	PEDIDO:
	DB "FACA SEU PEDIDO"
	DB 00h
	DISPLAY1:
	DB "1- X-BURGUER"
	DB 00h ;Marca null no fim da String
	DISPLAY2:
	DB "2- X-SALADA"
	DB 00h
	DISPLAY3:
	DB "3- X-OVO"
	DB 00h
	DISPLAY4:
	DB "4- X-BACON"
	DB 00h
	DISPLAY5:
	DB "5- SUCO NATURAL"
	DB 00h
	DISPLAY6:
	DB "6- COCA COLA"
	DB 00h
	DISPLAY7:
	DB "PEDIDO"
	DB 00h
	DISPLAY8:
	DB "ADICIONADO"
	DB 00h
	DISPLAY9:
	DB "REMOVIDO"
	DB 00h
	DISPLAY10:
	DB "FINALIZADO"
	DB 00h
	PONTEIRO_TELA:
	DB ">"
	DB 00h



org 0200h
START:
	ACALL lcd_init
	MOV R2, #0FFh
	ACALL parte_0
	ACALL pedidos

main:;loop principal
	ACALL leituraTecladoRow0
	ACALL leituraTecladoRow1
	SETB p3.0
	CLR p3.1
	JMP main 

leituraTecladoRow0:;Realiza a leitura do teclado
	;MOV R0, #0			; clear R0 - the first key is key0
	; scan row0 = * 0 #
	MOV P0, #0FFh	
	CLR P0.0			; clear row0
	CALL colScanRow0		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
finish:
	RET
colScanRow0:;Realiza a leitura do teclado
	; #
	JNB P0.4, baixo	; if col0 is cleared - key found
	; 0
	JNB P0.5, adicionar   ; if col1 is cleared - key found
	; *
	JNB P0.6, cima	; if col2 is cleared - key found
	RET					; return from subroutine - key not found
cima:;Seleciona o ponteiro '>' uma posição acima 
	SETB F0				; key found - set F0
	MOV A, R2
	JZ finish ;ignora caso R0 seja 0
	DEC R2
	ACALL menu1
	RET

baixo:;Seleciona o ponteiro '>' uma posição abaixo
	SETB F0
	ACALL clra
	MOV A, #5
	SUBB A, R2
	JZ finish
	INC R2
	ACALL menu1
	RET

adicionar:;Incrementa o pedido selecionado
	SETB F0
	ACALL clra
	MOV A, #0
	SUBB A, R2
	JZ xburguer
	ACALL clra
	MOV A, #1
	SUBB A, R2
	JZ xsalada
	ACALL clra
	MOV A, #2
	SUBB A, R2
	JZ xovo
	ACALL clra
	MOV A, #3
	SUBB A, R2
	JZ xbacon
	ACALL clra
	MOV A, #4
	SUBB A, R2
	JZ suco
	ACALL clra
	MOV A, #5
	SUBB A, R2
	JZ cocacola
	ACALL clra
	RET
;pedidos
	cocacola:
		SETB F0
		INC 7EH
		ACALL pedido_adc
		RET
	suco:
		SETB F0
		INC 6EH
		ACALL pedido_adc
		RET
	xbacon:
		SETB F0
		INC 5EH
		ACALL pedido_adc
		RET
	xovo:
		SETB F0
		INC 4EH
		ACALL pedido_adc
		RET
	xsalada:
		SETB F0
		INC 3EH
		LJMP pedido_adc
		RET
	xburguer:
		SETB F0
		INC 2EH
		ACALL pedido_adc
		RET

clra:;Realiza o CLR no acumulador e Carry
	CLR A
	CLR C
	RET
leituraTecladoRow1:;Realiza a leitura do teclado
	; scan row1 = 7 8 9
	SETB P0.0			
	CLR P0.1			
	CALL colScanRow1		
	JB F0, finish2
colScanRow1:;Realiza a leitura do teclado
	JNB P0.4, finalizado ; 9
	JNB P0.5, remover; if col1 is cleared - key found
	RET
remover:;Decrementa o pedido selecionado
	SETB F0
	ACALL clra
	MOV A, #5
	SUBB A, R2
	MOV R1, #7EH
	JZ rem
	ACALL clra
	MOV A, #4
	SUBB A, R2
	MOV R1, #6EH
	JZ rem
	ACALL clra
	MOV A, #3
	SUBB A, R2
	MOV R1, #5EH
	JZ rem
	ACALL clra
	MOV A, #2
	SUBB A, R2
	MOV R1, #4EH
	JZ rem
	ACALL clra
	MOV A, #1
	SUBB A, R2
	MOV R1, #3EH
	JZ rem
	ACALL clra
	MOV A, #0
	SUBB A, R2
	MOV R1, #2EH
	JZ rem
	ACALL clra
	RET
rem:;Remove o pedido selecionado
	MOV A, @R1
	MOV R0, A
	JZ finish2 ;ignora caso R0 seja 0
	DEC @R1
	ACALL pedido_rem
	RET
finish2:
	RET

finalizado:;Mostra no display "Pedido finalizado" e reinicializa a quantidade de cada pedido
	MOV 2EH, 00H
	MOV 3EH, 00H
	MOV 4EH, 00H
	MOV 5EH, 00H
	MOV 6EH, 00H
	MOV 7EH, 00H
	MOV R2, #0FFH
	ACALL clearDisplay
 	MOV A, #05h
  	ACALL posicionaCursor
  	MOV DPTR,#DISPLAY7            ;endereço inicial de memória da String FEI
  	ACALL escreveStringROM
  	MOV A, #43h
  	ACALL posicionaCursor
  	MOV DPTR,#DISPLAY10            ;endereço inicial de memória da String Display LCD
  	ACALL escreveStringROM
	ACALL clearDisplay
	ACALL parte_0
  	RET

menu1:;Label responsavel por detectar o pedido selecionado e a posição do ponteiro '>'
	;R2 navegar	
	ACALL ponteiro
	MOV A, #0
	SUBB A, R2
	JZ parte_1
	ACALL clra
	MOV A, #1
	SUBB A, R2
	JZ parte_1
	ACALL clra
	MOV A, #2
	SUBB A, R2
	JZ parte_2
	ACALL clra
	MOV A, #3
	SUBB A, R2
	JZ parte_2
	ACALL clra
	MOV A, #4
	SUBB A, R2
	JZ parte_3
	ACALL clra
	MOV A, #5
	SUBB A, R2
	JZ parte_3
	ACALL clra
	RET

print_ponteiro:
	ACALL clearDisplay
	ACALL posicionaCursor
	MOV DPTR,#PONTEIRO_TELA            ;endereço inicial de memória da String FEI
	ACALL escreveStringROM
	RET
ponteiro:;localiza a posição do ponteiro caso o numero seja par ou impar, e armazena em R1
	MOV A, R2  ; Coloca o dividendo (A) em A
	MOV B, #2  ; Coloca o divisor (B) em B
	MOV DPTR, #0;
	DIV AB  ; Realize a divisão de A por B
	MOV R0, A  ; O quociente é armazenado em R2
	MOV A, B  ; Resto em A
	JZ print_ponteiro
	MOV A, #40H
	ACALL print_ponteiro
	RET


;parte_x mostra no display as opções do menu
parte_0:
	MOV A, #02h
	ACALL posicionaCursor
	MOV DPTR,#FEI            ;endereço inicial de memória da String FEI
	ACALL escreveStringROM
	MOV A, #40h
	ACALL posicionaCursor
	MOV DPTR,#PEDIDO            ;endereço inicial de memória da String Display LCD
	ACALL escreveStringROM
	RET

parte_1:
	MOV A, #01h
	ACALL posicionaCursor
	MOV DPTR,#DISPLAY1            ;endereço inicial de memória da String FEI
	ACALL escreveStringROM
	MOV A, #41h
	ACALL posicionaCursor
	MOV DPTR,#DISPLAY2            ;endereço inicial de memória da String Display LCD
	ACALL escreveStringROM
	JMP finish

parte_2:
	MOV A, #01h
	ACALL posicionaCursor
	MOV DPTR,#DISPLAY3            ;endereço inicial de memória da String FEI
	ACALL escreveStringROM
	MOV A, #41h
	ACALL posicionaCursor
	MOV DPTR,#DISPLAY4            ;endereço inicial de memória da String Display LCD
	ACALL escreveStringROM
	JMP finish

parte_3:
	MOV A, #01h
	ACALL posicionaCursor
	MOV DPTR,#DISPLAY5            ;endereço inicial de memória da String FEI
	ACALL escreveStringROM
	MOV A, #41h
	ACALL posicionaCursor
	MOV DPTR,#DISPLAY6            ;endereço inicial de memória da String Display LCD
	ACALL escreveStringROM
	JMP finish

pedido_adc:;Mostra no display "Pedido adicionado"
	ACALL clearDisplay
 	MOV A, #05h
  	ACALL posicionaCursor
  	MOV DPTR,#DISPLAY7            ;endereço inicial de memória da String FEI
  	ACALL escreveStringROM
  	MOV A, #43h
  	ACALL posicionaCursor
  	MOV DPTR,#DISPLAY8            ;endereço inicial de memória da String Display LCD
  	ACALL escreveStringROM
  	JMP menu1

pedido_rem:;Mostra no display "Pedido removido"
	ACALL clearDisplay
  	MOV A, #05h
  	ACALL posicionaCursor
  	MOV DPTR,#DISPLAY7            ;endereço inicial de memória da String FEI
  	ACALL escreveStringROM
  	MOV A, #44h
  	ACALL posicionaCursor
  	MOV DPTR,#DISPLAY9            ;endereço inicial de memória da String Display LCD
  	ACALL escreveStringROM
  	JMP menu1


pedidos:;Escreve na memoria ram as opções do menu
	; X-BURGUER
	MOV 20H, #58H
	MOV 21H, #2DH
	MOV 22H, #42H
	MOV 23H, #55H
	MOV 24H, #52H
	MOV 25H, #47H
	MOV 26H, #55H
	MOV 27H, #45H
	MOV 28H, #52H

	; X-SALADA
	MOV 30H, #58H
	MOV 31H, #2DH
	MOV 32H, #53H
	MOV 33H, #41H
	MOV 34H, #4CH
	MOV 35H, #41H
	MOV 36H, #44H
	MOV 37H, #41H

	; X-OVO
	MOV 40H, #58H
	MOV 41H, #2DH
	MOV 42H, #4FH
	MOV 43H, #56H
	MOV 44H, #4FH

	; X-BACON
	MOV 50H, #58H
	MOV 51H, #2DH
	MOV 52H, #42H
	MOV 53H, #41H
	MOV 54H, #43H
	MOV 55H, #4FH
	MOV 56H, #4EH

	; SUCO
	MOV 60H, #53H
	MOV 61H, #55H
	MOV 62H, #43H
	MOV 63H, #4FH

	; COCA COLA
	MOV 70H, #43H
	MOV 71H, #4FH
	MOV 72H, #43H
	MOV 73H, #41H
	MOV 74H, #20H
	MOV 75H, #43H
	MOV 76H, #4FH
	MOV 77H, #4CH
	MOV 78H, #41H
	LJMP MAIN


lcd_init:

	CLR RS		; clear RS - indicates that instructions are being sent to the module
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear	
	SETB EN		; |
	CLR EN		; | negative edge on E
	SETB P1.7		; low nibble set (only P1.7 needed to be changed)

	SETB EN		; |
	CLR EN		; | negative edge on E
		; function set low nibble sent
	CALL delay		; wait for BF to clear
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET

escreveStringROM:
	MOV R1, #00h
	; Inicia a escrita da String no Display LCD
	loop:
	MOV A, R1
	MOVC A,@A+DPTR 	 ;lê da memória de programa
	JZ finish1		; if A is 0, then end of data has been reached - jump out of loop
	ACALL sendCharacter	; send data in A to LCD module
	INC R1			; point to next piece of data
	MOV A, R1
	JMP loop		; repeat
	RET

finish1:
	RET

sendCharacter:
	SETB RS  		; setb RS - indicates that data is being sent to module
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endereço da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|

posicionaCursor:
	CLR RS	
	SETB P1.7		    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET


;Retorna o cursor para primeira posição sem limpar o display
retornaCursor:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


;Limpa o display
clearDisplay:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	MOV R6, #40
rotC:
	CALL delay		
	DJNZ R6, rotC
	RET

delay:
	MOV R0, #50
	DJNZ R0, $
	RET


; For this program, the keys are numbered
; as:

;	+----+----+----+
;	| 11 | 10 |  9 |	row3
;	+----+----+----+
;	|  8 |  7 |  6 |	row2
;	+----+----|----+
;	|  5 |  4 |  3 |	row1
;	+----+----+----+
;	|  2 |  1 |  0 |	row0
;	+----+----+----+
;	 col2 col1 col0

;;	+----+----+----+
;	|  1 |  2 |  3 |	row3
;	+----+----+----+
;	|  4 |  5 |  6 |	row2
;	+----+----|----+
;	|  7 |  8 |  9 |	row1
;	+----+----+----+
;	|  * |  0 |  # |	row0
;	+----+----+----+
;	 col2 col1 col0

; The pressed key number will be stored in
; R0. Therefore, R0 is initially cleared.
; Each key is scanned, and if it is not
; pressed R0 is incremented. In that way,
; when the pressed key is found, R0 will
; contain the key's number.

; The general purpose flag, F0, is used
; by the column-scan subroutine to indicate
; whether or not a pressed key was found
; in that column.
; If, after returning from colScan, F0 is
; set, this means the key was found.