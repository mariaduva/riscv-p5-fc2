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
    li t0, 0
    li t3, 3

for:
    slli t1, t0, 3
    add t2, a0, t1

    lw a1, 0(t2)
    lw a2, 4(t2)

    beqz a1, check_zero
    beqz a2, not_found_zero

    addi t0, t0, 1
    j for

check_zero:
    beqz a2, found_zero

    addi t0, t0, 1
    j for

found_zero:
    beq t0, t3, end_valid
    li a0, 0
    ret

not_found_zero:
    addi t0, t0, 1
    j for

end_valid:
    li a0, 1
    ret



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
