.data
    Entrada:    .asciiz "Ingrese un Numero Real: " 
    Mantisa:    .asciiz "La Mantisa es: "
    Exponente:  .asciiz "El Exponente es: "
    SaltoLinea: .asciiz "\n"

.text
    main:
                li $v0, 4
                la $a0, Entrada
                syscall
                
                li $v0, 4
                la $a0, SaltoLinea
                syscall
                
                li $v0, 4
                la $a0, Mantisa
                syscall
                
                li $v0, 4
                la $a0, SaltoLinea
                syscall
                
                li $v0, 4
                la $a0, Exponente
                syscall
                
                
                li $v0, 10
                syscall
