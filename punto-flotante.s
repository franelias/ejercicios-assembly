    .data
Entrada:    .asciiz "Ingrese un Numero Real: "
Mantisa:    .asciiz "La Mantisa es: "
Exponente:  .asciiz "El Exponente es: "
SaltoLinea: .asciiz "\n"
Mascara_expo:   .word 2139095040 # 01111111100000000000000000000000 = 2139095040
Mascara_man:   .word 8388607 # 00000000011111111111111111111111 = 8388607
.align 2
resultado:     .space 4

    .text
main:
            li $v0, 4
            la $a0, Entrada
            syscall

            li $v0, 6
            syscall

            s.s $f0, resultado($0)

            lw $t0, resultado($0)

            lw $t1, Mascara_expo($0)
            lw $t2, Mascara_man($0)

            and $t3, $t0, $t1
            and $t4, $t0, $t2

            srl $t3, $t3, 23

            li $v0, 4
            la $a0, Mantisa
            syscall

            li $v0, 1
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
