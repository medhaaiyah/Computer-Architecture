#Programmer's Name: Medha Aiyah
#Homework # 2

	  	.data
prompt:		.asciiz "Enter some text: "	
text:		.space 40
wordNum:	.word	0
characterNum:	.word	0
wordText:	.asciiz "words"
characterText:	.asciiz "characters"
goodByeMessage:	.asciiz "goodbye"
goodByeMessage1:.asciiz " have a wonderful day"
		.text
main:
loopProgram:
	#Prompts the user to enter some text in the dialog box
	
	li	$v0, 54
	la	$a0, prompt
	la	$a1, text
	li	$a2, 20
	syscall
	
	#Used to direct to the goodbye label
	
	beq	$a1, -2, goodbye
	beq	$a1, -3, goodbye
	
	#Calling the function
	
	jal	Num
	
	sw	$v0, wordNum		#this is storing the word count
	sw	$v1, characterNum	#this is storing the character count
	
	#Display input string
	
	li	$v0, 4
	la	$a0, text
	syscall
	
	#Display word number
	
	li	$v0, 1
	lw	$a0, wordNum
	syscall
	
	#Add space
	
	li	$v0, 11
	li	$a0, 32
	syscall
	
	#Display word text
	
	li	$v0, 4
	la	$a0, wordText
	syscall
	
	#Add space
	
	li	$v0, 11
	li	$a0, 32
	syscall
	
	#Display character number
	
	li	$v0, 1
	lw	$a0, characterNum
	syscall
	
	#Add space
	
	li	$v0, 11
	li	$a0, 32
	syscall
	
	#Display character text
	
	li	$v0, 4
	la	$a0, characterText
	syscall
	
	#Display a newline
	
	li	$v0, 11
	li	$a0, 10
	syscall
	
	j loopProgram
	
# This label is used to display the goodbye message to exit
	
goodbye:
	li	$v0, 59
	la	$a0, goodByeMessage
	la	$a1, goodByeMessage1
	syscall			
exit:
	li	$v0, 10	
	syscall

#This is the num function that used to increment the word count and character count

Num: 
	#Pushing into the stack
	la	$a0, text
	addi	$sp, $sp, -4
	sw	$s1, ($sp)
	
	li	$t4, 1 #initialize the register for word count
	li	$t5, 0 #initialize the register for character count
Loop: 	
	lb	$t0, 0($a0)		#goes to the next character
	beqz	$t0, exit1 		#it will exit for a null character
	beq	$t0, 0x20, isSpace	#it will go to the isSpace label
	j incrementChar
isSpace: 	addi 	$t4, $t4, 1	#this will increment the word count
incrementChar: addi 	$t5, $t5, 1	#this will increment the character count
	 addi $a0, $a0, 1		#it will increment the next character
	 j Loop

exit1:
	subi $t5, $t5, 1 
	
	##This is where it moves the contents of the word count and character count to a different register.
	
	move $v0, $t4
	move $v1, $t5
	
	#Popped the stack
	
	lw	$s1, ($sp)
	addi	$sp, $sp, 4
	
	jr	$ra
	
	
