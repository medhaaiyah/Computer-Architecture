##Ritvik Divanji
##RXD170003
		.data 
buffer: 	.space 		80
array: 		.word 		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fileName: 	.asciiz		"input.txt"	
errorMSG: 	.asciiz 	"This is an error message. The number of bytes read is <=0!"
arraySize: 	.word 		0
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
	##read the file into the buffer
	
	la 	$a0, fileName
	la 	$a1, buffer
	jal read
	ble  	$v0, 0, error
	
	##convert the buffer into the array
	
	la	$a0, array
	li	$a1, 0			
	la 	$a2, buffer
	jal toArray
	
	##print the array before sorting it
	
	la 	$a0, beforeSort
	li 	$v0, 4
	syscall
	la 	$a0, array
	li      $s0, 0
	jal printArray	
	
	##sort the array using the selctionSort
	
	la 	$a0, array
	jal selectionSort
	
	##print the array after sorting it
	
	la 	$a0, afterSort
	li 	$v0, 4
	syscall
	la 	$a0, array
	jal printArray
	
	##calculate and print the mean
	
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
	
	##calculate and print the median
	
	la 	$a0, median
	li 	$v0, 4
	syscall 
	la 	$a0, array
	lw 	$a1, arraySize
	jal calcMedian
	beq 	$v1, 1, float		
	move 	$a0, $v0		
	li	$v0, 1
	syscall
	j main2
float: 	li	$v0, 2
	syscall
main2:	la 	$a0, newLine
	li 	$v0, 4
	syscall
	
	##calculate and print the Standard Deviation
	
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
	#Used to print out the error message that is required it is unable to read the file
	la 	$a0, errorMSG
	li 	$a1,  0
	li 	$v0, 55
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
	
	#What will happen if there is a newline		
			
isNL:	
	sw 	$s0, ($a0)
	addi 	$a1, $a1, 1		
	addi 	$a2, $a2, 1		
	addi 	$a0, $a0, 4		
	move 	$s0, $0			
	j toArray			
	
	#What will hap
	
notNL:	bne 	$t0, 0, notEnd 		# if the byte is 0 (EOF)
	sw 	$s0, ($a0)		# save the accumulator into the array
	addi 	$a1, $a1, 1		# add 1 to the size 
	sw 	$a1, arraySize		# save the arraySize to memory because...
	jr 	$ra			# we are done with this function
					
notEnd:	slti	$t1, $t0, 48		# if the byte is NOT between 48
	sgt 	$t2, $t0, 57		# and 57
	or 	$t3, $t1, $t2
	bne  	$t3, 1, isInt	
	addi 	$a2, $a2, 1		# move the buffer to the next byte
	j toArray			# and ignore the current one
	
isInt: 	subi 	$t0, $t0, 48		# if it is between 48 and 57, subtract 48
	li 	$t4, 10		
	mul 	$s0, $s0, $t4		# multiply the accumulator by 10
	add 	$s0, $t0, $s0		# add the new number to the accumulator
	addi 	$a2, $a2, 1		# move the buffer to the next byte
	j toArray			# and start again
	
printArray: 
	move 	$t0, $a0		# $t0 = &array
	li 	$t1, 0			# $t1 = i
pLoop:	lw 	$a0, 0($t0)		# $a0 = array[i]
	li 	$v0, 1			# print array[i]
	syscall 
	li 	$v0, 4			# and a space
	la 	$a0, space
	syscall
	addi	$t0, $t0, 4		# move the array to point to the next int
	addi 	$t1, $t1, 1		# i+=1
	lw 	$t2, arraySize
	blt 	$t1, $t2, pLoop		# continue while i<arraySize
	li 	$v0, 4
	la 	$a0, newLine		# print a newline
	syscall
	jr $ra				
	
selectionSort:
	##direct 'translation' from the wiki article linked in the doc
	li 	$t0, 0 			# $t0=i
	li 	$t1, 0			# $t1=j
	addi 	$sp, $sp, -4		# push SP in anticipation of swap function
	sw 	$ra, ($sp)
outer: 	move 	$t2, $t1		# $t2 = iMin = j
	addi 	$t0, $t1, 1		# i = j + 1
inner:	sll 	$t3, $t0, 2
	add 	$t3, $a0, $t3		
	lw 	$t4, ($t3)		# $t4 = a[i]
	sll 	$t5, $t2, 2
	add 	$t5, $a0, $t5
	lw 	$t6, ($t5)		# $t6 = a[iMin]
	
	bgt 	$t4, $t6, less		# if a[i]<a[iMin], branch
	
	move 	$t2, $t0
	
	
less:	addi	$t0, $t0, 1		# i+=1
	lw 	$t7, arraySize		 
	blt 	$t0, $t7, inner 	# do while i < n
	# end of inner loop
	
	beq 	$t2, $t1, EQ		# if iMin=j, branch
	move 	$a1, $t1		# else, $a1 = j
	move 	$a2, $t2		# $a2 = iMin
	
	jal swap			# swap a[j] and a[iMin]
	
EQ:	addi 	$t1, $t1, 1		# j+=1
	subi 	$t8, $t7, 1	
	blt 	$t1, $t8, outer  	# continue while j < n-1
	# end of outer loop
	lw 	$ra, ($sp)		# pop SP after jal to swap function
	addi 	$sp, $sp, 4
	jr $ra	
	
swap: 
	sll 	$t3, $a1, 2 
	add 	$t3, $a0, $t3		
	lw 	$t4, ($t3)		# $t4 = a[j]
	sll 	$t5, $a2, 2		
	add 	$t5, $a0, $t5
	lw 	$t6, ($t5)		# $t6 = a[iMin]
	sw 	$t4, ($t5)		
	sw 	$t6, ($t3)		# swap the 2
	jr $ra	
	
calcMean: 
	li	$t0, 0			# $t0=sum
	li 	$t1, 0 			# $t1=i
meanLP:	lw 	$t2, ($a0)		# $t2 = array[]
	add 	$t0, $t0, $t2		# sum+= array[]
	addi	$a0, $a0, 4		# move to next index
	addi 	$t1, $t1, 1		# i+=1
	lw 	$t3, arraySize
	blt 	$t1, $t3, meanLP	# continue while i<arraySize
	
	mtc1 	$t0, $f0		
	cvt.s.w	$f0, $f0		# $f0 = sum
	mtc1 	$t3, $f1
	cvt.s.w	$f1, $f1		# $f1 = arraySize
	div.s 	$f12, $f0, $f1		# $f12 = sum/arraySize
	jr $ra
calcMedian:
	li 	$t0, 2
	div	$a1, $t0		# arraySize/2
	mfhi 	$t1			# $t1 = remainder
	mflo	$t2			# $t2 = quotient
	li 	$t3, 4
	mul	$t4, $t2, $t3		
	add 	$t4, $t4, $a0
	lw 	$v0, ($t4)		# $v0 = array[mid]
	beq	$t1, 0, even
	jr $ra
even:   li 	$v1, 1			# flag to tell return value is a float
	subi 	$t2, $t2, 1
	mul	$t4, $t2, $t3
	add 	$t4, $t4, $a0
	lw 	$t5, ($t4)		# $t5 = array[rightMid]
	add 	$v0, $v0, $t5 		# $v0 = array[rightMid] + array[Mid]
	mtc1	$v0, $f12
	cvt.s.w	$f12, $f12
	mtc1	$t0, $f0
	cvt.s.w	$f0, $f0
	div.s 	$f12, $f12, $f0		# $f12 = (array[rightMid] + array[Mid])/2
	jr $ra
calcSDF: 
	li 	$t0, 0			# $t0 = i
	l.s 	$f0, meanVal		# $f0 = r(avg)
	mtc1	$0, $f1			
	cvt.s.w	$f1, $f1		# $f1 = sum
SDloop:	sll 	$t1, $t0, 2
	add 	$a2, $a0, $t1
	lw 	$t1, ($a2)
	mtc1 	$t1, $f2		# $f2 = r(i)
	cvt.s.w	$f2, $f2
	sub.s 	$f2, $f2, $f0		# $f2 = r(i)-r(avg)
	mul.s	$f2, $f2, $f2		# $f2 = [r(i)-r(avg)]^2
	add.s	$f1, $f1, $f2		# add $f2 t0 sum
	addi 	$t0, $t0, 1		# i+=1
	blt 	$t0, $a1, SDloop	# loop while i<size
	subi 	$t0, $a1, 1		
	mtc1	$t0, $f0		# $f0 = n-1
	cvt.s.w	$f0, $f0		
	div.s	$f2, $f1, $f0		# $f1 = sum/(n-1)
	sqrt.s	$f12, $f2
	jr $ra
exit: 
	li	$v0, 10
	syscall
