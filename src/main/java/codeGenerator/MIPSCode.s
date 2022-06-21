.data

i_x:				.byte 0
i_y:				.byte 0
i_z:				.byte 0
c_a:				.byte 'z'
b_1:				.byte 1
b_2:				.byte 0
b_3:				.byte 1
str_s:				.asciiz "Esto es un string" 
i_p:				.byte 0
c_b:				.byte 'u'
i_u:				.byte 0
c_t:				.byte 'p'
i_o:				.byte 0
i_xi:				.byte 0
i_yi:				.byte 0
i_ai:				.byte 0
i_bi:				.byte 0
i_ci:				.byte 0
i_ji:				.byte 0
i_zi:				.byte 0
i_di:				.byte 0
i_ei:				.byte 0
i_fi:				.byte 0
i_gi:				.byte 0
printLabel_0:				.asciiz "i_zi es: " 
printLabel_1:				.asciiz "Inserte un numero: " 
i_ri:				.byte 0
printLabel_2:				.asciiz "i_ri es: " 
b_ai:				.byte 1
i_ti:				.byte 0

.text

#LA op1Var is: i_y
#LI op2Val is: 5
#LA op1Var is: i_y
main:
	la				$s0,	i_xi
	li				$t2,	5
	sb				$t2,	($s0)
	la				$s1,	i_yi
	li				$t2,	7
	sb				$t2,	($s1)
	la				$s2,	i_ai
	li				$t2,	52
	sb				$t2,	($s2)
	la				$s4,	i_bi
	li				$t2,	26
	sb				$t2,	($s4)
	la				$s5,	i_ci
	li				$t2,	2
	sb				$t2,	($s5)
#LA op1Var is: i_xi
	la				$s6,	i_xi
	lb				$t1,	($s6)
#LI op2Val is: 5
	li				$t2,	5
	mul				$t1,	$t1,	$t2
	la				$s0,	i_ji
	sb				$t1,	($s0)
#LA op1Var is: i_xi
	la				$s2,	i_xi
	lb				$t1,	($s2)
#LA op2Var is: i_yi
	la				$s4,	i_yi
	lb				$t2,	($s4)
	mul				$t1,	$t1,	$t2
	la				$s5,	i_zi
	sb				$t1,	($s5)
#LA op1Var is: i_ai
	la				$s0,	i_ai
	lb				$t1,	($s0)
#LA op2Var is: i_bi
	la				$s1,	i_bi
	lb				$t2,	($s1)
	div				$t1,	$t1,	$t2
	la				$s2,	i_di
	sb				$t1,	($s2)
#LA op1Var is: i_xi
	la				$s5,	i_xi
	lb				$t1,	($s5)
#LA op2Var is: i_bi
	la				$s6,	i_bi
	lb				$t2,	($s6)
	add				$t1,	$t1,	$t2
	la				$s0,	i_ei
	sb				$t1,	($s0)
#LA op1Var is: i_yi
	la				$s2,	i_yi
	lb				$t1,	($s2)
#LA op2Var is: i_ci
	la				$s4,	i_ci
	lb				$t2,	($s4)
	sub				$t1,	$t1,	$t2
	la				$s5,	i_fi
	sb				$t1,	($s5)
#LI op1Val is: 5
	li				$t1,	5
#LI op2Val is: 2
	li				$t2,	2
	mul				$t1,	$t1,	$t2
#LI op2Val is: 3
	li				$t2,	3
	add				$t1,	$t1,	$t2
#LI op2Val is: 2
	li				$t2,	2
	sub				$t1,	$t1,	$t2
	la				$s0,	i_gi
	sb				$t1,	($s0)

	li				$v0,	4
	la				$a0,	printLabel_0
	syscall

	la				$a0,	i_zi 
	lb				$a1,	($a0)

	li				$v0,	1
	move				$a0,	$a1
	syscall


	li				$v0,	4
	la				$a0,	printLabel_1
	syscall

#READ INT RETURNS IN $V0

	li				$v0,	5
	syscall

	la				$a1,	i_ri
	sb				$v0,	($a1)

	li				$v0,	4
	la				$a0,	printLabel_2
	syscall

	la				$a0,	i_ri 
	lb				$a1,	($a0)

	li				$v0,	1
	move				$a0,	$a1
	syscall

#LA op1Var is: i_xi
	la				$s2,	i_xi
	lb				$t1,	($s2)
#LI op2Val is: 1
	li				$t2,	1
	add				$t1,	$t1,	$t2
#LI op2Val is: 6
	li				$t2,	6
	add				$t1,	$t1,	$t2
	la				$s0,	i_ti
	sb				$t1,	($s0)

end:
	li				$v0,	10
	syscall

funcOne:
	la				$s0,	i_x
	li				$t0,	0
	sb				$t0,	($s0)
	la				$s1,	i_y
	li				$t0,	10
	sb				$t0,	($s1)
	la				$s2,	i_y
	lb				$t1,	($s2)
	li				$t2,	5
	mul				$t1,	$t1,	$t2
	la				$s5,	i_z
	sb				$t1,	($s5)
	la				$s0,	i_y
	lb				$t1,	($s0)
	add				$t1,	$t1,	$t2
	la				$s2,	i_p
	sb				$t1,	($s2)
	la				$s5,	i_u
	li				$t2,	99
	sb				$t2,	($s5)
	la				$s6,	i_o
	li				$t2,	99
	sb				$t2,	($s6)

	jr				$ra
