.data

srcArr:		.word	4, 5, 12, 19, 2, 18, 3 ,4, 9, 10, 17, 15, 11, 7 ,6, 8, 1, 20, 16, 14

length:		.word 	80

.text

la $t0, length	# array length

addi $t1, $zero, 0x2004	# external loop index start from the byte in index 1
nop
ExternalLoop:
	nop
	nop
	slt $t2, $t1, $t0
	nop
	nop
	nop
	beq $t2, $zero, EndLoop
	nop
	
	addi $t2, $t1, -4	#internal index
	lw $t3, 0($t1)		#temporary variable for the swap
	InternalLoop:
		nop
		nop
		lw $t4, 0($t2)
		nop
		nop
		nop
		#if the value in the index below the index of the temoorary variable is lower, we are ok and can continue to external loop
		slt $t5, $t3, $t4
		nop
		nop
		nop
		beq $t5, $zero, EndInternalLoop
		nop
		sw $t4, 4($t2) #the value is higher so lets swap to find its place

		#last internal loop is for index 0
		slt $t4, $zero, $t2
		nop
		nop
		nop
		beq $t4, $zero, EndInternalLoopZ
		nop
		addi $t2, $t2, -4
		j InternalLoop
		nop
	EndInternalLoop:	
	nop
	sw $t3, 4($t2)
	j Continue
	nop
	EndInternalLoopZ:
	sw $t3, 0($t2)
	Continue:
	addi $t1, $t1, 4
	j ExternalLoop
EndLoop:

#retrun to OS
add $v0, $zero, 10
syscall
