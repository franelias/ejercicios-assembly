    .data
Entrada:    .asciiz "Ingrese un Numero Real: "
Mantisa:    .asciiz "La Mantisa es: "
Exponente:  .asciiz "El Exponente es: "
SaltoLinea: .asciiz "\n"
Mascara_expo:   .word 2139095040 # 01111111100000000000000000000000 = 2139095040
Mascara_mant:   .word 8388607 # 00000000011111111111111111111111 = 8388607
.align 2
resultado:     .space 4

    .text
main:
            li $v0, 4   # codigo para imprimir cadena
            la $a0, Entrada
            syscall

            li $v0, 6   # codigo para leer entero
            syscall

            s.s $f0, resultado($0)    # almacena punto flotante unico

            lw $t0, resultado($0)
            lw $t1, Mascara_expo($0)
            lw $t2, Mascara_mant($0)

            and $t3, $t0, $t1   # hacemos and al numero con nuestra mascara para sacar el exponente
            and $t4, $t0, $t2   # hacemos and al numero con nuestra mascara para sacar la mantisa

            srl $t3, $t3, 23    # desplazo el exponente 23 lugares a la derecha

            li $v0, 4   # muestro el resultado
            la $a0, Mantisa
            syscall

            li $v0, 1   # imprime el entero
            move $a0, $t4
            syscall

            li $v0, 4
            la $a0, SaltoLinea
            syscall

            li $v0, 4
            la $a0, Exponente
            syscall

            li $v0, 1
            move $a0, $t3
            syscall

            jal $ra
