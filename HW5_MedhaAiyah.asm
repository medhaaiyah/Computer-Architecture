#Programmer's Name: Medha Aiyah
#Programmer's Net ID: mva170001
		.data 
array: 		.word 		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
arraySize: 	.word 		0
buffer: 	.space 		80
fileName: 	.asciiz		"input.txt"	
errorMSG: 	.asciiz 	"This is an error message. The number of bytes read is <=0!"
beforeSort: 	.asciiz 	"The array before: \t"
afterSort: 	.asciiz 	"The array after: \t"
mean: 		.asciiz 	"The mean is: "
meanVal: 	.float		0.0
median: 	.asciiz		"The median is: "
SD:	 	.asciiz		"The standard deviation is: "
space: 		.asciiz 	" "
newLine: 	.asciiz 	"\n"
	.text
main: 
	#read the file into the buffer
	
	la 	$a0, fileName
	la 	$a1, buffer
	jal 	read
	ble  	$v0, 0, error
	
	#convert the buffer into the array
	
	la	$a0, array
	li	$a1, 0			
	la 	$a2, buffer
	jal 	toArray
	
	#print the array before sorting it
	
	la 	$a0, beforeSort
	li 	$v0, 4
	syscall
	la 	$a0, array
	li      $s0, 0
	jal 	printArray	
	
	#sort the array using the selctionSort
	
	la 	$a0, array
	jal 	selectionSort
	
	#print the array after sorting it
	
	la 	$a0, afterSort
	li 	$v0, 4
	syscall
	la 	$a0, array
	jal 	printArray
	
	#calculate and print the mean
	
	la 	$a0, array
	lw 	$a1, arraySize
	jal 	calcMean
	la 	$a0, mean
	li 	$v0, 4
	syscall 
	s.s	$f12, meanVal		
	li 	$v0, 2
	syscall
	la 	$a0, newLine
	li 	$v0, 4
	syscall 
	
	#calculate and print the median
	
	la 	$a0, median
	li 	$v0, 4
	syscall 
	la 	$a0, array
	lw 	$a1, arraySize
	jal 	calcMedian
	beq 	$v1, 1, float		
	move 	$a0, $v0		
	li	$v0, 1
	syscall
	j main2
float: 	
	#Used to deal with floating points
	
	li	$v0, 2
	syscall
main2:	
	#Dealing with the newline from the .data section
	
	la 	$a0, newLine
	li 	$v0, 4
	syscall
	
	#calculate and print the Standard Deviation
	
	la 	$a0, array
	lw 	$a1, arraySize
	jal 	calcSDF
	la 	$a0, SD
	li 	$v0, 4
	syscall
	li	$v0, 2
	syscall
	j exit
error:
	#Used to print out the error message that is required it is unable to read the file (dialog box)
	
	la 	$a0,  errorMSG
	li 	$a1,  0
	li 	$v0,  55
	syscall
	j exit

read:
	#system call for opening the file
	
	move 	$t0, $a1 
	la 	$a0, fileName
	li 	$a1, 0
	li 	$a2, 0
	li 	$v0, 13
	syscall
	move 	$s1, $v0
	
	# system call for read from file
	
	li   	$v0, 14			
	move 	$a0, $s1		
	move   	$a1, $t0		
	li   	$a2, 100
	syscall				
	move 	$t1, $v0 
	
	#system call for close file	
	
	li   	$v0, 16			
	move 	$a0, $s1		
	syscall				
	move 	$v0, $t1	
	jr	$ra
toArray:
	#Calling to instances: if a newline is required or not
	
	lb 	$t0, ($a2)		
	beq 	$t0, 10, isNL		
	j notNL
	
		
			
isNL:	
	#What will happen if there is a newline	
	
	sw 	$s0, ($a0)
	addi 	$a1, $a1, 1		
	addi 	$a2, $a2, 1		
	addi 	$a0, $a0, 4		
	move 	$s0, $0			
	j toArray			
	
	
	
notNL:	
	#What will happen if there is not a newline
	
	bne 	$t0, 0, notEnd 		
	sw 	$s0, ($a0)		
	addi 	$a1, $a1, 1		 
	sw 	$a1, arraySize		
	jr 	$ra			
					
notEnd:	
	#This is what will happen if it is in the middle of the file and not in range
	
	slti	$t1, $t0, 48		
	sgt 	$t2, $t0, 57		
	or 	$t3, $t1, $t2	
	bne  	$t3, 1, isInt	
	addi 	$a2, $a2, 1		
	j toArray			
	
isInt: 
	#Used to deal with a value not in range
	
	subi 	$t0, $t0, 48		
	li 	$t4, 10		
	mul 	$s0, $s0, $t4		
	add 	$s0, $t0, $s0		
	addi 	$a2, $a2, 1		
	j toArray			
	
printArray: 

	#This is used to print the array
	
	move 	$t0, $a0		
	li 	$t1, 0	
			
pLoop:	
	#The loop that is used to print the array
	
	lw 	$a0, 0($t0)		
	li 	$v0, 1			
	syscall 
	li 	$v0, 4			
	la 	$a0, space
	syscall
	addi	$t0, $t0, 4		
	addi 	$t1, $t1, 1		
	lw 	$t2, arraySize
	blt 	$t1, $t2, pLoop		
	li 	$v0, 4
	la 	$a0, newLine		
	syscall
	jr $ra				
	
selectionSort:
	#Dealing with the selection sort and their respective loops
	
	li 	$t0, 0 			
	li 	$t1, 0			
	addi 	$sp, $sp, -4		
	sw 	$ra, ($sp)
outer: 	
	#The starting of the outer loop
	
	move 	$t2, $t1		
	addi 	$t0, $t1, 1		
inner:	
	#The starting of the inner loop
	
	sll 	$t3, $t0, 2
	add 	$t3, $a0, $t3		
	lw 	$t4, ($t3)		
	sll 	$t5, $t2, 2
	add 	$t5, $a0, $t5
	lw 	$t6, ($t5)		
	
	bgt 	$t4, $t6, less		
	
	move 	$t2, $t0
	
	
less:	
	#Increment i and then call the inner loop again
	
	addi	$t0, $t0, 1		
	lw 	$t7, arraySize		 
	blt 	$t0, $t7, inner 
		
	# end of inner loop
	
	beq 	$t2, $t1, EQ		
	move 	$a1, $t1		
	move 	$a2, $t2
	
	jal swap			
	
EQ:	
	#Increments i and then calls the outer loop again
	
	addi 	$t1, $t1, 1		
	subi 	$t8, $t7, 1	
	blt 	$t1, $t8, outer  
		
	# end of outer loop
	
	lw 	$ra, ($sp)		
	addi 	$sp, $sp, 4
	jr $ra	
	
swap: 
	#This is the swap function that is used for the sort
	
	sll 	$t3, $a1, 2 
	add 	$t3, $a0, $t3		
	lw 	$t4, ($t3)		
	sll 	$t5, $a2, 2		
	add 	$t5, $a0, $t5
	lw 	$t6, ($t5)		
	sw 	$t4, ($t5)		
	sw 	$t6, ($t3)		
	jr $ra	
	
calcMean: 

	#Used to print the calculated mean
	
	li	$t0, 0			
	li 	$t1, 0 			
meanLP:	
	#Used to actually solve for the mean
	
	lw 	$t2, ($a0)		
	add 	$t0, $t0, $t2		
	addi	$a0, $a0, 4		
	addi 	$t1, $t1, 1		
	lw 	$t3, arraySize
	blt 	$t1, $t3, meanLP	
	
	#Dealing with it in terms of single floating point
	
	mtc1 	$t0, $f0		
	cvt.s.w	$f0, $f0		
	mtc1 	$t3, $f1
	cvt.s.w	$f1, $f1		
	div.s 	$f12, $f0, $f1		
	jr $ra
calcMedian:

	#This is used to calculate the median
	
	li 	$t0, 2
	div	$a1, $t0		
	mfhi 	$t1			
	mflo	$t2			
	li 	$t3, 4
	mul	$t4, $t2, $t3		
	add 	$t4, $t4, $a0
	lw 	$v0, ($t4)		
	beq	$t1, 0, even
	jr $ra
even:  
	 #This is what happened if there are an even number of digits in the system
	  
	li 	$v1, 1			
	subi 	$t2, $t2, 1
	mul	$t4, $t2, $t3
	add 	$t4, $t4, $a0
	lw 	$t5, ($t4)		
	add 	$v0, $v0, $t5 	
	
	#Dealing with it in terms of single floating point
			
	mtc1	$v0, $f12
	cvt.s.w	$f12, $f12
	mtc1	$t0, $f0
	cvt.s.w	$f0, $f0
	div.s 	$f12, $f12, $f0		
	jr $ra
calcSDF: 
	#Used to print out the standard deviation
	
	li 	$t0, 0			
	l.s 	$f0, meanVal		
	mtc1	$0, $f1			
	cvt.s.w	$f1, $f1
			
SDloop:	
	#This is the loop to solve for the standard deviation
	sll 	$t1, $t0, 2
	add 	$a2, $a0, $t1
	lw 	$t1, ($a2)
	
	#Dealing with it in terms of single floating point
	
	mtc1 	$t1, $f2		
	cvt.s.w	$f2, $f2
	sub.s 	$f2, $f2, $f0		
	mul.s	$f2, $f2, $f2		
	add.s	$f1, $f1, $f2		
	addi 	$t0, $t0, 1		
	blt 	$t0, $a1, SDloop	
	subi 	$t0, $a1, 1
	
	#Dealing with it in terms of single floating point
					
	mtc1	$t0, $f0		
	cvt.s.w	$f0, $f0		
	div.s	$f2, $f1, $f0		
	sqrt.s	$f12, $f2
	jr $ra
	
exit: 
	#This is the exit function to end the program
	
	li	$v0, 10
	syscall
