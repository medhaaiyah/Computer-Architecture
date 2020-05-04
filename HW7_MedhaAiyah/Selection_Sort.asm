#Programmer's Name: Medha Aiyah
#Programmer's Net Id: mva170001
#Program Description: This program uses selection sort to order the array which has a size of 500

	.data
array:	.word		19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
			19, 2, 95, 26, 83, 17, -5, 69, -16, 10
	.text
	#la	$a0, msg1
	#li	$v0, 4
	#syscall			# print before message
	#la	$a0, array
	#li	$a1, 500
	#jal	print
	la	$a0, array	# array pointer, v
	li	$a1, 500	# array size,  n
	jal	sort
	#la	$a0, msg2	
	#li	$v0, 4
	#syscall			# print after message
	#la	$a0, array
	#li	$a1, 500
	#jal	print
main:

	li	$v0, 10
	syscall
############################ PRINT ################################
# print an integer array 
# address in $a0
# length in $a1
#print:	li	$t0, 0		# counter
#	add	$t1, $zero, $a0 # pointer to words
#loop:	beq	$t0, $a1, done
#	li	$v0, 1		# print integer sevice call
#	lw	$a0, ($t1)	# load next integer
#	syscall			# print
#	li	$v0, 11
#	li	$a0, 0x20
#	syscall			# print a space	
#	addi	$t1, $t1, 4	# point to next word
#	addi	$t0, $t0, 1	# add 1 to LCV
#	j	loop
#done:	jr	$ra
############################ SELECTION SORT ################################
#This function sorts the array using selection sort
sort:
	li $t0, 0	#starting index = i
	addi $s0, $a1, -1	# $s0 = size - 1
	
loopOuter:
	beq $t0, $s0, returnSort
	move $s1, $t0
	add $t1, $t0, 1	#j = i++
	
loopInner:
	beq $t1, $a1, swapPossible
	sll $t2, $t1, 2
	sll $t3, $s1, 2
	add $t2, $t2, $a0
	add $t3, $t3, $a0
	lw $t4, ($t2)
	lw $t5, ($t3)
	blt $t4, $t5, goTo
	j loopInner1
	
goTo:	move $s1, $t1

loopInner1:
	add $t1, $t1, 1
	j loopInner
	
swapPossible:
	bne $s1, $t0, swap
	
	j loopOuter1
	
swap:
	sll $t2, $t0, 2
	sll $t3, $s1, 2
	add $t2, $t2, $a0
	add $t3, $t3, $a0
	lw $t5, ($t3)
	lw $t4, ($t2)
	sw $t4, ($t3)
	sw $t5, ($t2)
	
loopOuter1:
	add $t0, $t0, 1
	j loopOuter
	
returnSort:
	jr $ra
