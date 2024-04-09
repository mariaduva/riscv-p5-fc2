.extern _stack
.extern resArea
.global main
.data
A:
    .word -1, -1
    .word 2, 2
    .word 3, 3

.bss
res:  		.space 4
.text
main:

    la s1, A            // a0 = @base A

	mv a0, s1
    call checkCoordenadas

	beq a0, zero, fin
	mv a0, s1
    call sonColineales

	la t0, res          // t0 = @base Res
    sw a0, 0(t0)        // res = a0

fin:
    j fin

checkCoordenadas:
    li t0, 0 // Inicializar contador de coordenadas
    li t3, 3 // Establecer el número esperado de coordenadas

for:
    slli t1, t0, 3 // Calcular el offset para acceder a la coordenada actual
    add t2, a0, t1 // Calcular la dirección de memoria de la coordenada actual

    lw a1, 0(t2) // Cargar la coordenada x
    lw a2, 4(t2) // Cargar la coordenada y

    // Verificar si la coordenada actual es (0,0)
    beqz a1, check_zero // Verificar si la coordenada x es cero
    beqz a2, not_found_zero // Si la coordenada y no es cero, continuar verificando

    addi t0, t0, 1 // Incrementar el contador de coordenadas
    j for // Continuar verificando las siguientes coordenadas

check_zero:
    // Si la coordenada x es cero, verificar si la coordenada y también es cero
    beqz a2, found_zero // Si la coordenada y es cero, encontramos (0,0)

    addi t0, t0, 1 // Incrementar el contador de coordenadas
    j for // Continuar verificando las siguientes coordenadas

found_zero:
    // Si encontramos (0,0) al final del array, establecer el resultado y devolver
    beq t0, t3, end_valid // Si el número de coordenadas es exactamente tres, es válido
    li a0, 0 // Establecer el resultado en 0 (false)
    ret // Devolver

not_found_zero:
    // Si no encontramos (0,0) al final del array, continuar verificando
    addi t0, t0, 1 // Incrementar el contador de coordenadas
    j for // Continuar verificando las siguientes coordenadas

end_valid:
    li a0, 1 // Establecer el resultado en 1 (true)
    ret // Devolver




sonColineales:
    addi sp, sp, -8		///
    sw ra, 4(sp)		// PRÓLOGO
    sw s1, 0(sp)

    call calcularAreaTriangulo

fin_sonColineales:
    lw ra, 4(sp)		///
    lw s1, 0(sp)		// EPÍLOGO
    addi sp, sp, 8		///
    ret


calcularAreaTriangulo:
    lw a1, 0(a0)     	// x1
    lw a2, 4(a0)		// y1
    lw a3, 8(a0)		// x2
    lw a4, 12(a0)		// y2
    lw a5, 16(a0)		// x3
    lw a6, 20(a0)		// y3


    sub t1, a4, a6		// y2 - y3
    mul t2, a1, t1		// x1 * (y2 - y3)

    sub t3, a6, a2		// y3 - y1
    mul t4, a3, t3		// x2 * (y3 - y1)

    sub t5, a2, a4		// y1 - y2
    mul t6, a5, t5		// x3 * (y1 - y2)

    add a7, t2, t4
    add a7, a7, t6

	mv a0, a7
	addi sp, sp, -4		///
    sw ra, 0(sp)		// PRÓLOGO

    call resArea

    lw ra, 0(sp)		///
    addi sp, sp, 4		// EPÍLOGO

    ret
