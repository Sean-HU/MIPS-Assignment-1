## $t1: address
## $t2: length
## $t3: character
## $t4: power
## $t5: x
## $t6: multiple
	
	.data
hex_str: .space 9
prompt: .asciiz "Enter Hexadecimal:\n"
error_msg: .asciiz "Invalid Hexadcimal Number\n"
	
	.text
	.global main
main:
	la $a0, prompt									# load the "prompt" string into $a0
	li $v0, 4										# print prompt message
	syscall

	la $a0, hex_str
	li $a1, 100
	li $v0, 8		# read user input
	syscall

	add $t0, $zero, $zero
	add $t1, $zero, $a0				# store address of string in $t1
	add $t2, $zero				# set length to 0

length_loop:
	lb $t3, ($t1)				# load the byte in hex string into $t3
	beqz $t3, sub_length1		
	beq $t3, 10, sub_length2
	addu $t2, $t2, 1			# increment length
	addi $t1, $t1, 1			# move to the next character
	b length_loop				# and repeat
sub_length1:					# move length back 3 spaces, to represent the largest exponent
	subu $t2, $t2, 3
	j test_length
sub_length2:					# move length back 2 spaces to represent the largest exponent
	subu $t2, $t2, 2
test_length:
	bgt $t2, 7, error
	bltz $t2, error
	add $t1, $zero, $a0				# move back to the first character
check_loop:
	add $t4, $zero, $zero		# initialize power
	addu $t5, $zero, 16			# set x to 16
	lb $t3, ($t1)
	j check_character1
power_loop:
	beq $t4, $t2, end_power_loop	# if power == length, then end loop
	multu $t5, $t5, 16				# x = x * 16
	addi $t4, $t4, 1				# increment power
	b power_loop					#and repeat
end_power_loop:
	beqz $t2, set_x_to_one			# if the string entered had only one character,
	j sum
set_x_to_one:
	addi $t5, $zero, 1				# set x to 1

check_character1:
	beq $t3, 48, end_check1			# if character == '0'
	j check_character2
end_check1:			
	add $t6, $zero, $zero			# mult = 0
	b power_loop


	