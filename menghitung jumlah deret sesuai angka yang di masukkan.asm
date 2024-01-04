.MODEL SMALL
.STACK 100H
.DATA

INPUTMSG    DB "MASUKKAN BATAS DERET ANGKA: $"
OUTPUTMSG   DB 13,10, "HASIL DERET ANGKA: ", 13,10,"$"
EQUALMSG    DB " = $"
NUM         DW ?
SUM         DW ?

.CODE

START:
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, INPUTMSG
    MOV AH, 09H
    INT 21H

    MOV AX, 0
    MOV NUM, AX

    MOV DL, 10
    MOV BL, 0

ScanNum:
    MOV AH, 01H
    INT 21H

    CMP AL, 13
    JE EndScanNum
    
    MOV AH,0
    SUB AL, 48

    MOV CL, AL
    MOV AL, BL

    MUL DL

    ADD AL, CL
    ADC AH, 0
    MOV BX, AX

    JMP ScanNum

EndScanNum:
    MOV NUM, BX
    MOV AX, 0
    MOV BX, NUM

SumLoop:
    CMP BX, 0
    JE EndSumLoop

    PUSH BX  ; Save BX to the stack for later printing
    ADD AX, BX
    DEC BX
    JMP SumLoop

EndSumLoop:
    MOV SUM, AX

    LEA DX, OUTPUTMSG
    MOV AH, 09H
    INT 21H

    ; Print the numbers and "+" symbols
    MOV CX, NUM
PrintLoop:
    POP AX  ; Retrieve the saved BX value
    CALL PRINT_NUM
    DEC CX
    CMP CX, 0
    JE PrintEqual
    MOV DL, '+'
    MOV AH, 02H
    INT 21H
    JMP PrintLoop

    ; Print "=" symbol
PrintEqual:
    LEA DX, EQUALMSG
    MOV AH, 09H
    INT 21H

    ; Print the result
    MOV AX, SUM
    CALL PRINT_NUM

    MOV AH, 4CH
    INT 21H

PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0

PRINT_LOOP:
    MOV BX, 10
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ PRINT_LOOP

PRINT_DIGITS:
    POP DX
    ADD DL, 48
    MOV AH, 02H
    INT 21H
    LOOP PRINT_DIGITS

    POP DX
    POP CX
    POP BX
    POP AX

    RET
PRINT_NUM ENDP
