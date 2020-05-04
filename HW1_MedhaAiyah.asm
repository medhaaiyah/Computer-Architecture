#Programmer's Name: Medha Aiyah
#Homework # 1

		.data
a:		.word	0
b:		.word	0
c:		.word	0
outputOne:	.word	0
outputTwo:	.word	0
outputThree: 	.word	0
name:		.space 	20
promptName:	.asciiz   "What is your name?"
integer:	.asciiz	  "Please enter an integer between 1-100: "
results:	.asciiz	  "Your answers are: "

	.text
main :

	#Prompting using for name
	li	$v0, 4
	la	$a0, promptName
	syscall
	
	#Save it in the memory
	li	$v0, 8
	li	$a1, 20 
	la	$a0, name
	syscall
	
	#Prompting a user for an integer
	li	$v0, 4
	la	$a0, integer
	syscall
	
	#Read integers in a
	li 	$v0, 5
	syscall
	
	#Store integers in a
	sw 	$v0, a
	
	#Prompting a user for an integer
	li	$v0, 4
	la	$a0, integer
	syscall
	
	#Read integers in b
	li 	$v0, 5
	syscall
	
	#Store integers in b
	sw 	$v0, b
	
	#Prompting a user for an integer
	li	$v0, 4
	la	$a0, integer
	syscall
	
	#Read integers in c
	li 	$v0, 5
	syscall
	
	#Store integers in c
	sw 	$v0, c
	
	#calculate ans1	 = 2a-b+9 (use a+a for 2a)
	lw 	$t1, a
	lw	$t2, b
	lw	$t3, c
	add 	$t4, $t1, $t1
	sub	$t5, $t4, $t2
	addi	$t0, $t5, 9
	
	sw	$t0, outputOne
	
	
	#calculate ans2 = c-b + (a-5)
	lw 	$t1, a
	lw	$t2, b
	lw	$t3, c
	subi	$t4, $t1, 5
	sub	$t5, $t3, $t2
	add	$t0, $t5, $t4
	
	sw	$t0, outputTwo
	
	
	
	#calculate ans3 = (a-3)+(b+4)-(c+7)	
	lw 	$t1, a
	lw	$t2, b
	lw	$t3, c
	subi	$t4, $t1, 3
	addi	$t5, $t2, 4
	addi	$t6, $t3, 7
	add	$t7, $t4, $t5
	sub	$t0, $t7, $t6
	
	sw	$t0, outputThree
	
	#Display user's name
	
	li	$v0, 4
	la	$a0, name
	syscall
	
	#Display message for results
	
	li	$v0, 4
	la	$a0, results
	syscall
	
	#Display 3 result and print a space character in between
	
	li 	$v0, 1
	lw	$a0, outputOne
	syscall
	
	li	$v0, 11
	li	$a0, 32
	syscall
	
	
	li 	$v0, 1
	lw	$a0, outputTwo
	syscall
	
	li	$v0, 11
	li	$a0, 32
	syscall
	
	li 	$v0, 1
	lw	$a0, outputThree
	syscall
	
#terminate

exit:
	li	$v0, 10	
	syscall
	
#Testing the program with three cases

# If a = 1, b = 2, and c = 3 then outputOne = 9, outputTwo = -3, and outputThree = -6 (Sample Run # 1)

#What is your name? Jiwon
#Please enter an integer between 1-100: 1
#Please enter an integer between 1-100: 2
#Please enter an integer between 1-100: 3
#Jiwon
#Your answers are: 9 -3 -6

# If a = 10, b = 20, and c = 30 then outputOne = 9, outputTwo = 15, and outputThree = -6 (Sample Run # 2)

#What is your name? Bea
#Please enter an integer between 1-100: 10
#Please enter an integer between 1-100: 20
#Please enter an integer between 1-100: 30
#Bea
#Your answers are: 9 15 -6

# If a = 40, b = 60, and c = 70 then outputOne = 29, outputTwo = 45, and outputThree = 24 (Sample Run # 3)
	
#What is your name? Medha
#Please enter an integer between 1-100: 40
#Please enter an integer between 1-100: 60
#Please enter an integer between 1-100: 70
#Medha
#Your answers are: 29 45 24