    .data
menu:       .asciiz "[Menu Principal]
1) Agregar una lista
2) Eliminar una lista
3) Agregar un elemento a una lista
4) Eliminar un elemento de una lista
5) Ver las listas
6) Salir \n
Elija una opcion: "

empty_print: .asciiz "[]"
bracket: .asciiz "["
bracket2: .asciiz "]"
comma: .asciiz ", "

add_q:  .asciiz "Las sublistas disponibles con sus elementos son: \n"

add_l: .asciiz "Ingrese su opcion: "

# struct List {
#     struct List *prev;
#     char *name;
#     struct List *obj_ptr, *prev;
# };
#
# typedef struct List* List;
#
# sbrk -> 10001010
#
#   prev   -  nombre  -  obj_ptr -   sig
#
# 10001000 - 10001004 - 10001008 - 10001012

    .text
main:
    # li $v0, 4
    # la $a0, Menu
    # syscall
    #
    # li $v0, 5 # Ingresa un entero
    # syscall

    addi $sp, $sp, -4 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)

    jal new_element # Llama a new_element

    lw $ra, 0($sp)
    addi $sp, $sp, 4 # Carga el contenido anterior de $ra

    addi $sp, $sp, -4 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)

    move $a0, $v0

    jal print_list

    lw $ra, 0($sp)
    addi $sp, $sp, 4 # Carga el contenido anterior de $ra

    jr $ra

# -----------------------------------------------------------------------------------

# [Crear una lista / Agregar un elemento a una lista]
# Crea un nuevo elemento
# Recibe en $a0 la direccion de la lista, en $a1 la direccion del nombre
# y en $a2 la direccion del obj ptr

new_element:
    move $t0, $a0

    # Pide memoria, la direccion del nuevo elemento va a aparecer en $v0
    li $v0, 9
    li $a0, 16
    syscall

    sw $a1, 4($v0)  # Guarda el nombre de la lista en el nuevo elemento
    sw $a2, 8($v0)  # Guarda la direc del objeto en el nuevo elemento

    beq $t0, $zero, empty

    lw $t1, 0($t0)  # Obtiene la direc del previo del antiguo elemento
    sw $t1, 0($v0)  # Guarda la direc del previo en el nuevo elemento
    sw $t0, 12($v0) # Guarda la direc del siguiente en el nuevo elemento

    sw $v0, 0($t0)
    sw $v0, 12($t1)

    j final

    empty:
        sw $v0, 0($v0)  # Guarda la direc del previo en el nuevo elemento
        sw $v0, 12($v0) # Guarda la direc del siguiente en el nuevo elemento

    final:
        jr $ra

 # -----------------------------------------------------------------------------------

 # [Ver las listas]
 # Permite ver los elementos de una lista
 # Recibe en $a0 la direccion de la lista

 print_list:
     move $t0, $a0
     move $t1, $a0

     beq $a0, $zero, empty_list

     print:
         li $v0, 4
         lw $a0, 4($t0) # Muestra el string
         syscall

         lw $t2, 8($t0)
         beq $t2, $zero, empty_sublist

         li $v0, 4
         la $a0, bracket($0)
         syscall

         addi $sp, $sp, -12 # Guarda el contenido de $ra y $t0 en la pila
         sw $ra, 0($sp)
         sw $t0, -4($sp)
         sw $t1, -8($sp)
         move $a0, $t2

         jal print_list

         lw $ra, 0($sp)
         lw $t0, -4($sp)
         lw $t1, -8($sp)
         addi $sp, $sp, 12

         li $v0, 4
         la $a0, bracket2($0)
         syscall

     empty_sublist:
         lw $t0, 12($t0) # Guardamos en $t0 la direc del siguiente elemento

     for1:
         beq $t1, $t0, end_for1

         li $v0, 4
         la $a0, comma($0)
         syscall

         j print

     end_for1:
         j end

     empty_list:
         li $v0, 4
         la $a0, empty_print
         syscall

     end:
         jr $ra

# -----------------------------------------------------------------------------------

# [Busca dentro de una lista]
# Recibe en $a0 la direccion de una lista
# y en $a1 la direccion del nombre del elemento buscado.
# Devuelve en $v0, la direccion de la lista donde se encuentra el elemento, 0 en caso contrario

search:
    move $t0, $a0
    move $t1, $a0

xddd:

    beq $a0, $zero, failed

    lw $a1, 4($t0)

    addi $sp, $sp, -20 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $a0, -4($sp)
    sw $a1, -8($sp)
    sw $t0, -12($sp)
    sw $t1, -16($sp)

    jal compare

    lw $ra, 0($sp)
    lw $a0, -4($sp)
    lw $a1, -8($sp)
    lw $t0, -12($sp)
    lw $t1, -16($sp)
    addi $sp, $sp, 12 # Carga el contenido anterior de $ra

    li $t7, 1
    move $t6, $v0
    beq $v0, $t7, end3

    lw $t2, 8($t0)
    beq $t2, $zero, empty_sublist3

    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $t0, -4($sp)
    sw $t1, -8($sp)
    move $a0, $t2

    jal search

    lw $ra, 0($sp)
    lw $t0, -4($sp)
    lw $t1, -8($sp)
    addi $sp, $sp, 12

    empty_sublist3:
        lw $t0, 12($t0) # Guardamos en $t0 la direc del siguiente elemento

    for3:
        beq $t1, $t0, end3
        j xddd

    success:
        move $v0, $t6
        j end3

    failed:
        li $v0, 0

    end3:
        jr $ra

# [
#     "Perro"
#     [
#         "Caniche",
#         "Corgi"
#     ],
#     "Gato"
#     [],
#     "Ave"
#     [
#         "Paloma"
#     ]
# ]


# USAR EN ELIMINATE
# move $t0, $a0
#
# lw $t2, 4($t0)
#
# li $v0, 4
# la $a0, add_q($0)
# syscall
#
# addi $sp, $sp, -4 # Guarda el contenido de $ra en la pila
# sw $ra, 0($sp)
#
# move $a0, $v0
#
# jal print_list
#
# lw $ra, 0($sp)
# addi $sp, $sp, 4 # Carga el contenido anterior de $ra
#
# li $v0, 4
# la $a0, add_l($0)
# syscall



# -----------------------------------------------------------------------------------

# [Compara dos strings]
# Recibe en $a0 y $a1 las direcciones de dos strings
# Devuelve en $v0, un 1 si son iguales, 0 si no
compare:
    move $t2, $a0
    move $t3, $a1
    for2:
        lb $t0, 0($t2)
        lb $t1, 0($t3)

        bne $t0, $t1, false

        beq $t0, $zero, true

        addi $t2, 1
        addi $t3, 1

        j for2

    false:
        li $v0, 0
        j end_for2

    true:
        li $v0, 1

    end_for2:
        jr $ra


#      f ->  1 -> 2 -> 3 -> 4 -> 1 .....
#
#      $t0 = 4
#
#  (f) 1 <- 2 -> 3
#
#      3 <- 4 -> 1 (f)
#
#      4 <- f -> 1
