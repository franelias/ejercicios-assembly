    .data
menu:       .asciiz "\n
#-----------------------------------------------------------------------------------
[Menu Principal]
1) Crear una nueva lista
2) Agregar un nuevo elemento
3) Eliminar un elemento
4) Ver las listas
5) Salir \n
Elija una opcion: "

menu_crear:     .asciiz "\n
#-----------------------------------------------------------------------------------
[Crear una lista]
Ingrese el nombre de la nueva lista: "

menu_agregar:   .asciiz "\n
#-----------------------------------------------------------------------------------
[Crear Nuevo Elemento]
Ingrese el nombre del nuevo elemento: "

menu_agregar2:  .asciiz "
Ingrese el nombre de la lista donde quiere ingresar el elemento: "

menu_eliminar:  .asciiz "\n
#-----------------------------------------------------------------------------------
[Eliminar Elemento]
Ingrese el nombre del elemento que desea eliminar: "

menu_ver:       .asciiz "\n
#-----------------------------------------------------------------------------------
[Ver listas]"

menu_error:     .asciiz "\n
#-----------------------------------------------------------------------------------
[El valor ingresado no corresponde a ninguna de las opciones]"

menu_vacio:     .asciiz "\n
#-----------------------------------------------------------------------------------
[No existe Ninguna Lista] \n"

menu_continuar: .asciiz "
Aprete ENTER para continuar"

empty_print: .asciiz "[]"
bracket: .asciiz "["
bracket2: .asciiz "]"
comma: .asciiz ", "

add_q:  .asciiz "Las sublistas disponibles con sus elementos son: \n"

add_l: .asciiz "Ingrese su opcion: "

test: .asciiz "testing"

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
    li $v0, 4
    la $a0, menu
    syscall

    li $v0, 5
    syscall

    li $t0, 1
    li $t1, 2
    li $t2, 3
    li $t3, 4
    li $t4, 5

    beq $v0, $t0, crear_lista
    beq $v0, $t1, agregar_elemento
    beq $v0, $t2, eliminar_elemento
    beq $v0, $t3, ver_listas
    beq $v0, $t4, salir

    j error

    crear_lista:
    li $v0, 4
    la $a0, menu_crear
    syscall

    li $v0, 5
    syscall

    move $a0, $t5
    move $a1, $v0
    li $a2, 0

    addi $sp, $sp, -8 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $t5, -4($sp)
    jal new_element
    lw $ra, 0($sp)
    lw $t5, -4($sp)
    addi $sp, $sp, 8 # Carga el contenido anterior de $ra

    move $t5, $v0

    j main

    agregar_elemento:
    beq $t5, $zero, vacio

    li $v0, 4
    la $a0, menu_agregar
    syscall

    li $v0, 5
    syscall
    move $t6, $v0

    li $v0, 4
    la $a0, menu_agregar2
    syscall

    li $v0, 5
    syscall

    move $a0, $t5
    move $a1, $v0

    addi $sp, $sp, -12 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $t5, -4($sp)
    sw $t6, -8($sp)
    jal search
    lw $ra, 0($sp)
    lw $t5, -4($sp)
    lw $t6, -8($sp)
    addi $sp, $sp, 12 # Carga el contenido anterior de $ra
    move $t7, $v0

    move $a0, $t5
    move $a1, $t6
    li $a2, 0

    addi $sp, $sp, -12 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $t5, -4($sp)
    sw $t6, -8($sp)
    jal new_element
    lw $ra, 0($sp)
    lw $t5, -4($sp)
    lw $t6, -8($sp)
    addi $sp, $sp, 12 # Carga el contenido anterior de $ra
    move $t6, $v0

    move $a0, $t7
    move $a1, $t6

    addi $sp, $sp, -8 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $t5, -4($sp)
    jal update
    lw $ra, 0($sp)
    lw $t5, -4($sp)
    addi $sp, $sp, 8 # Carga el contenido anterior de $ra

    move $t5, $v0

    j main

    eliminar_elemento:
    beq $t5, $zero, vacio

    li $v0, 4
    la $a0, menu_eliminar
    syscall

    li $v0, 5
    syscall

    move $a0, $t5
    move $a1, $v0
    addi $sp, $sp, -8 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $t5, -4($sp)
    jal eliminate
    lw $ra, 0($sp)
    lw $t5, -4($sp)
    addi $sp, $sp, 8 # Carga el contenido anterior de $ra

    move $t5, $v0

    j main

    ver_listas:
    beq $t5, $zero, vacio

    li $v0, 4
    la $a0, menu_ver
    syscall

    move $a0, $t5
    addi $sp, $sp, -8 # Guarda el contenido de $ra en la pila
    sw $ra, 0($sp)
    sw $t5, -4($sp)
    jal print_list
    lw $ra, 0($sp)
    lw $t5, -4($sp)
    addi $sp, $sp, 8 # Carga el contenido anterior de $ra

    li $v0, 4
    la $a0, menu_continuar
    syscall

    li $v0, 5
    syscall

    salir:
    jr $ra

    error:
    li $v0, 4
    la $a0, menu_error
    syscall
    j main

    li $v0, 4
    la $a0, menu_continuar
    syscall

    li $v0, 5
    syscall

    vacio:
    li $v0, 4
    la $a0, menu_vacio
    syscall

    li $v0, 4
    la $a0, menu_continuar
    syscall

    li $v0, 5
    syscall

    j main

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
    move $t0, $a0 # Guardo en $t0, la direccion de $a0
    move $t1, $a0 # Guardo en $t1, la direccic de $a0

xddd:
    beq $a0, $zero, failed # Verifico si $a0 es nula

    lw $a1, 4($t0) # Guardo en $a1, el nombre del elemento $t0

    addi $sp, $sp, -20 # Guardo el contenido de $ra en la pila
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
    addi $sp, $sp, 12 # Restauro el contenido anterior de $ra

    li $t7, 1 # Guardo en $t7, el valor 1
    move $t6, $v0 # Guardo en $t6, el valor de $v0
    beq $v0, $t7, end3 # Verifico $v0 es igual a 1 (Esto es en el caso de que ya se encuentre el valor buscado)

    lw $t2, 8($t0) # Guarda en $t2, el object pointer de $t0
    beq $t2, $zero, empty_sublist3 # Verifico si $t2 es nulo

    addi $sp, $sp, -16 # Guardo $ra, $t0 y $t1 en la pila
    sw $ra, 0($sp)
    sw $t0, -4($sp)
    sw $t1, -8($sp)
    move $a0, $t2

    jal search # Recursa

    lw $ra, 0($sp)
    lw $t0, -4($sp)
    lw $t1, -8($sp)
    addi $sp, $sp, 12 # Restauro $ra, $t0 y $t1

    empty_sublist3:
        lw $t0, 12($t0) # Guardo en $t0 la direc del siguiente elemento

    for3:
        beq $t1, $t0, end3 # Verifico si $t1 es igual a $t0
        j xddd

    success:
        move $v0, $t6 #Guardo en $v0 el valor de $t6
        j end3

    failed:
        li $v0, 0 # Devuelvo 0 si no encontre coincidencias

    end3:
        jr $ra # Termino la funcion


# -----------------------------------------------------------------------------------

# [Busca el padre de un elemento]
# Recibe en $a0 la direccion de una lista
# y en $a1, la direccion del elemento buscado
# Devuelve en $v0, el padre del elemento buscado

find_father:
    move $t0, $a0 # Muevo $a0 a $t0 y $t1 para poder cambiar sus valores
    move $t1, $a0

    xd_find_father:
        beq $t0, $a1, finded # Verifico

        lw $t2, 8($t0) # Cargo en $t2 la sublista

        beq $t2, $zero, empty_sublist_father # Verifico si existe la sublista

        addi $sp, $sp, -20 # Guardo los valores de $ra, $a0, $a1, $t0 y $t1 en la pila
        sw $ra, 0($sp)
        sw $a0, -4($sp)
        sw $a1, -8($sp)
        sw $t0, -12($sp)
        sw $t1, -16($sp)

        move $a0, $t2

        jal find_father # Recursa

        lw $ra, 0($sp)
        lw $a0, -4($sp)
        lw $a1, -8($sp)
        lw $t0, -12($sp)
        lw $t1, -16($sp)
        addi $sp, $sp, 20 # Restauro los valores de $ra, $a0, $a1, $t0 y $t1 en la pila

        bne $v0, $zero, finded # Verifico que no se encontro ningun resultado en la sublista accedida con la recursion

    empty_sublist_father:
        lw $t0, 12($t0) # Guardo en $t0, el siguiente valor

    for_find_father:
        beq $t1, $t0, not_finded # Verifico si se llego al final de la lista/sublista
        j xd_find_father

    not_finded:
        li $v0, 0 # Si se llego al final de la lista/sublista y no se encontro coincidencia, devuelvo 0
        j end_find_father

    finded:
        li $t5, 2 # Cargo 2 en $t5 para poder comparar
        beq $t5, $v1, end_find_father # Verifico si en $v1 hay un 2
        move $v0, $t0 # Si no lo hay, muevo $t0 a $v0
        addi $v1, 1 # Sumo 1 a $v1

    end_find_father:
        jr $ra # Termino la funcion

# -----------------------------------------------------------------------------------

# [Elimina un elemento de una lista]
# Recibe en $a0 la direccion de una lista
# y en $a1 la direccion del nombre del elemento buscado.
# Devuelve en $v0, la lista sin el elemento indicado.

eliminate:
    addi $sp, $sp, -12 # Guardo en la pila $ra, $a0 y $a1
    sw $ra, 0($sp)
    sw $a0, -4($sp)
    sw $a1, -8($sp)

    jal search # Llamo a search para buscar la direccion en la lista del elemento a eliminar

    lw $ra, 0($sp)
    lw $a0, -4($sp)
    lw $a1, -8($sp)
    addi $sp, $sp, 12 # Restauro $ra, $a0 y $a1

    beq $v0, $zero, end4 # Verifico que el elemento buscado este en la lista
    move $t0, $v0 # Muevo la direccion del elemento en la lista a $t0 para no perder su valor

    li $v1, 0 # Seteo $v1 a 0 para poder utilizar find_father correctamente
    addi $sp, $sp, -16 # Guardo en la pila $ra, $a0, $a1 y $t1
    sw $ra, 0($sp)
    sw $a0, -4($sp)
    sw $a1, -8($sp)
    sw $t0, -12($sp)

    move $a1, $t0 # Muevo a $a1 la direccion del elemento a eliminar en la lista

    jal find_father # Llamo a find_father para buscar la direccion del padre del elemento a eliminar

    lw $ra, 0($sp)
    lw $a0, -4($sp)
    lw $a1, -8($sp)
    lw $t0, -12($sp)
    addi $sp, $sp, 16 # Restauro $ra, $a0 y $a1

    move $t1, $v0 # Muevo la direccion del padre a $t1 para no perder su valor

    lw $t2, 0($t0) # Guardo en $t2, la direccion del anterior elemento
    beq $t0, $t2, alone # Se fija si el elemento esta solo en la lista

    lw $t3, 12($t0) # Cargo en $t3 el siguiente al eliminado
    lw $t4, 0($t0) # Cargo en $t4 el anterior al eliminado
    sw $t4, 0($t3) # Vinculo al siguiente del eliminado con el anterior
    sw $t3, 12($t4) # Vinculo al anterior del eliminado con el siguiente

    beq $t0, $t1, supreme # Verifico si el elemento es parte de la lista suprema

    sw $t3, 8($t1) # Vinculo al padre con el siguiente al eliminado

    move $v0, $a0 # Muevo la direccion de la lista sin el elemento a $v0

    j end4 # Salto a end4

    supreme:
        move $v0, $t3 # Si el elemento es parte de la lista suprema, muevo a $v0 la direccion de la nueva lista suprema
        bne $t0, $t3, end4 # Verifico si el elemento a eliminar no es unico

    supreme_alone:
        li $v0, 0 # Si es un unico elemento a elimnar de la lista suprema, devuelvo 0
        j end4

    alone:
        sw $zero, 8($t1) # Desvinculo del padre el elemento

    end4:
        jr $ra # Termino la funcion


# -----------------------------------------------------------------------------------

# [Compara dos strings]
# Recibe en $a0 y $a1 las direcciones de dos strings
# Devuelve en $v0, un 1 si son iguales, 0 si no

compare:
    move $t2, $a0 # Guardo en $t2, el valor de $a0
    move $t3, $a1 # Guardo en $t3, el valor de $a1
    for2:
        lb $t0, 0($t2) # Cargo en $t0, un caracter de $t2
        lb $t1, 0($t3) # Cargo en $t1, un caracter de $t3

        bne $t0, $t1, false # Verifico si los caracteres son distintos

        beq $t0, $zero, true # Verifico si la primer palabra ha finalizado (al ser iguales, al terminar una palabra -> termina la otra)

        addi $t2, 1 # Paso al siguiente caracter
        addi $t3, 1 # Paso al siguiente caracter

        j for2

    false:
        li $v0, 0 # En el caso en que las palabras sean falsas, devuelo 0
        j end_for2

    true:
        li $v0, 1 # En el caso en que las palabras sean iguales, devuelvo 1

    end_for2:
        jr $ra # Termino la funcion

# -----------------------------------------------------------------------------------

# [Actualiza el object pointer de una lista]
# Recibe $a0 la lista que se quiere actualizar, en $a1 la lista que se convertira en object pointer ???????????????????????????????????????????????????????????????????????
# Devuelve en $v0 la direccion de la lista con el nuevo object pointer

update:
    move $t0, $a0
    sw $a1, 8($t0)
    move $v0, $t0
