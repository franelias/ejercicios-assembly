            .data
Menu:       .asciiz "[Menu Principal]
1) Agregar una lista
2) Eliminar una lista
3) Agregar un elemento a una lista
4) Eliminar un elemento de una lista
5) Ver una lista
6) Salir \n
Elija una opcion: "

            .text
main:
            li $v0, 4
            la $a0, Menu
            syscall

            li $v0, 6
            syscall

            jal $ra