#Programmer's Name: Medha Aiyah
#Homework # 3

		.data
promptName:	.asciiz "What is your name? "
enterName:	.space 40
promptHeight:	.asciiz "Please enter your height in inches: "
enterHeight:	.word 0
promptWeight:	.asciiz "Now enter your weight in pounds (round to a whole number): "
enterWeight:	.word 0
ouputResults:	.asciiz ", your bmi is: "
bmi:		.float 0
underWeight:	.asciiz "\nThis is considered underweight. \n"
normalWeight:	.asciiz "\nThis is a normal weight. \n"
overWeight: 	.asciiz "\nThis is considered over weight"
obeseWeight:	.asciiz "\nThis is considered obese. \n"
bmiOne:		.float 18.5
bmiTwo:		.float 25
bmiThree:	.float 30

		.text
main:

	#Prompt's the user for their name
	
	li	$v0, 4
	la	$a0, promptName
	syscall
	
	#This is where the user is able to enter their name
	
	li	$v0, 8
	la	$a0, enterName
	li	$a1, 20
	syscall
	
	li 	$a0, 0
	jal	removeNL
	
	#Prompt's user for their height
	
	li	$v0, 4
	la	$a0, promptHeight
	syscall
	
	#This is where the user can enter their height
	
	li	$v0, 5 
	syscall
	sw	$v0, enterHeight
	
	#Prompt's user for their weight
	
	li	$v0, 4
	la	$a0, promptWeight
	syscall
	
	#This is where the user enters their weight
	
	li	$v0, 5
	syscall
	sw	$v0, enterWeight

	lw $a3, enterWeight
	lw $a2, enterHeight
	
	#These series of statements are used to calculate the BMI
	
	mul $t0, $a3, 703
	mul $t1, $a2, $a2
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	mtc1 $t1, $f1
	cvt.s.w $f1, $f1	
	
	div.s $f2 ,$f0, $f1
	swc1 $f2, bmi
	
	#This is used to output the BMI results
	
	#This will output the name
	
	li	$v0, 4
	la	$a0, enterName
	li	$a1, 20 
	syscall
	
	#This will output the prompt for the bmi
	
	li	$v0, 4
	la	$a0, ouputResults
	syscall
	
	#This will output the actual BMI
	
	li	$v0, 2
	mov.s	$f12, $f2
	syscall
	
	#These statements are used to determine their weight
	
	lwc1 	$f3, bmiOne
	lwc1	$f4, bmiTwo
	lwc1	$f5, bmiThree
	
	#Test the BMI for underweight
	
	c.lt.s	$f12, $f3
	bc1t 	underweight
	
	#Test the BMI for underweight
	
	c.lt.s	$f12, $f4
	bc1t 	normal
	
	#Test the BMI for underweight
	
	c.lt.s $f12, $f5
	bc1t	overweight
	
	j obese
	
#This is used to remove the enter portion of the name

removeNL:
	lb	$t1, enterName($a0)
	addi 	$a0, $a0, 1
	bnez	$t1, removeNL
	subiu	$a0, $a0, 2
	sb 	$0, enterName($a0)
	jr	$ra
	
#This is used to display the underweight statement

underweight:
	
	li	$v0, 4
	la	$a0, underWeight
	syscall
	
	j 	exit
	
#This is used to display the normal weight statement
	
normal:

	li	$v0, 4
	la	$a0, normalWeight
	syscall
	
	j 	exit
	
#This is used to display the over weight statement
	
overweight:

	li	$v0, 4
	la	$a0, overWeight
	syscall
	
	j 	exit

#This is used to display the obese weight statement	

obese: 
	li 	$v0, 4
	la 	$a0, obeseWeight
	syscall 
	
	j	exit
	
exit: 
	li $v0, 10
	syscall
	