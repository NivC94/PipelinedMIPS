.data

srcArr:		.word	4, 5, 12, 19, 2, 18, 3 ,4, 9, 10, 17, 15, 11, 7 ,6, 8, 1, 20, 16, 14

end:		.space 4

.text

la $t0, end		# ending index label
addi $t1, $zero,0x2004	# external loop index start from the byte in index 1
la $t6, srcArr		# saving the starting index of the array

ExternalLoop:
	nop
	nop
	# break from the External loop when $t1 is out of the array ($t1 >= $t0)
	slt $t2, $t1, $t0
	nop
	nop
	nop
	beq $t2, $zero, EndLoop
	nop
	
	addi $t2, $t1, -4	# internal index, initialize to be the previous index of $t1 in the array
	lw $t3, 0($t1)		# temporary variable for the swap
	InternalLoop:
		nop
		nop
		lw $t4, 0($t2)
		nop
		nop
		nop
		# break the internal loop if the the position of the temporary variable has been found
		# temporary variable (array[$t1]) >= array[$t2]
		slt $t5, $t3, $t4
		nop
		nop
		nop
		beq $t5, $zero, EndInternalLoop
		nop
		sw $t4, 4($t2) # the value is higher so lets swap to find its place

		# if the internal loop index reached the start of the array then break from the internal loop (index 0 of the array >= $t2)
		# in case all the values are greater than the temporary value
		slt $t4, $t6, $t2
		nop
		nop
		nop
		beq $t4, $zero, ReachedStartArr
		nop
		addi $t2, $t2, -4
		j InternalLoop
		nop
	# save the temporary value in its position
	EndInternalLoop:
	nop	
	sw $t3, 4($t2)
	j Continue
	nop
	ReachedStartArr:
	sw $t3, 0($t2)
	Continue:
	addi $t1, $t1, 4
	j ExternalLoop
	nop
EndLoop:

#retrun to OS
add $v0, $zero, 10
syscall
