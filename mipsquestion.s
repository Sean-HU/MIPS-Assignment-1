# $t0: sum
# $t1: address
# $t2: length
# $t3: character
# $t4: power
# $t5: x  (16^n)
# $t6: mult, the value of the character in string (0, 1, 2,...,15)
# decimal = (x * mult0) + (x * mult1) +...+ (x * multn)
	
	.text
main:
	la $a0, prompt					# load the "prompt" string into $a0
	li $v0, 4						# print prompt message
	syscall

	la $a0, hex_str
	li $a1, 100
	li $v0, 8						# read user input
	syscall

	add $t0, $zero, $zero			#initializ sum (which will eventually be the result)
	add $t1, $zero, $a0				# store address of hex string in $t1
	add $t2, $zero, $zero			# intialize length

length_loop:
	lb $t3, ($t1)				# load the byte in hex string into $t3
	beqz $t3, sub_length1		# if character is null, branch to sub_length
	beq $t3, 10, sub_length2	# if character is '\n' branch to sub_length2
	add $t2, $t2, 1			# increment length
	addi $t1, $t1, 1			# move to the next character in the string,
	b length_loop				# and repeat
sub_length1:					# move length back 2 spaces, to represent the largest exponent
	subu $t2, $t2, 2
	j test_length
sub_length2:					# move length back 1 space to represent the largest exponent
	sub $t2, $t2, 1
test_length:
	bgt $t2, 7, error			# if length > 7 (largest possible exponent), display error message
	bltz $t2, error				# if length < 0, display error message
	add $t1, $zero, $a0			# move pointer back to the first character

# check_loop verifires each character in the hex string
check_loop:
	add $t4, $zero, $zero		# initialize power
	add $t5, $zero, 1			# set x to 1
	lb $t3, ($t1)				# load byte in $t1
	j check_character1			# check what the character is

power_loop:
	beq $t4, $t2, end_power_loop	# if power == length, then end loop
	mulou $t5, $t5, 16				# x = x * 16
	addi $t4, $t4, 1				# increment power
	b power_loop					#and repeat
end_power_loop:
	beqz $t2, set_x_to_one			# if the string entered had only one character,
	j sum
set_x_to_one:
	addi $t5, $zero, 1				# set x to 1
sum:
	mulou $t7, $t5, $t6				# product = x * mult
	add $t0, $t0, $t7				# sum += product
	addi $t1, $t1, 1				# increment address to move to the next character
	beqz $t2, print_decimal			# when length is 0, print decimal and exit
	subu $t2, $t2, 1				# decrement length
	b check_loop					# repeat check_loop

error:
	la $a0, error_msg				# display error message if input is invalid
	li $v0, 4
	syscall
	j exit					

print_decimal:
	la $a0, dec_str					# display "Decimal Number:"
	li $v0, 4
	syscall
	bltz $t0, make_unsigned
	j print
make_unsigned:
	abs $t0, $t0
print:
	move $a0, $t0					# display decimal result
	li $v0, 1
	syscall

exit:
	li $v0, 10						# exit
	syscall

check_character1:
	beq $t3, 48, end_check1			# if character is '0',
	j check_character2
end_check1:			
	add $t6, $zero, $zero			# mult = 0
	b power_loop
check_character2:
	beq $t3, 49, end_check2			# if character is '1',
	j check_character3
end_check2:
	addi $t6, $zero, 1				# mult = 1
	b power_loop
check_character3:
	beq $t3, 50, end_check3			# if character is '2',
	j check_character4
end_check3:
	addi $t6, $zero, 2				# mult = 2
	b power_loop
check_character4:
	beq $t3, 51, end_check4			# if character is '3'
	j check_character5
end_check4:
	addi $t6, $zero, 3				# mult = 3
	b power_loop
check_character5:
	beq $t3, 52, end_check5			# if character is '4'
	j check_character6
end_check5:
	addi $t6, $zero, 4				# mult = 4
	b power_loop
check_character6:
	beq $t3, 53, end_check6			# if character is '5'
	j check_character7
end_check6:
	addi $t6, $zero, 5				# mult = 5
	b power_loop
check_character7:
	beq $t3, 54, end_check7			# if character is '6'
	j check_character8
end_check7:
	addi $t6, $zero, 6				# mult = 6
	b power_loop
check_character8:
	beq $t3, 55, end_check8			# if character is '7'
	j check_character9
end_check8:
	addi $t6, $zero, 7				# mult = 7
	b power_loop
check_character9:
	beq $t3, 56, end_check9			# if character is '8'
	j check_character10
end_check9:
	addi $t6, $zero, 8				# mult = 8
	b power_loop
check_character10:
	beq $t3, 57, end_check10		# if character is '9'
	j check_character11
end_check10:
	addi $t6, $zero, 9				# mult = 9
	b power_loop
check_character11:
	beq $t3, 65, end_check11		# if character is 'A'
	beq $t3, 97, end_check11		# or 'a'
	j check_character12
end_check11:
	addi $t6, $zero, 10				# mult = 10
	b power_loop
check_character12:
	beq $t3, 66, end_check12		# if character is 'B'
	beq $t3, 98, end_check12		# or 'b'
	j check_character13
end_check12:
	addi $t6, $zero, 11				# mult = 11
	b power_loop
check_character13:
	beq $t3, 67, end_check13		# if character is 'C'
	beq $t3, 99, end_check13		# or 'c'
	j check_character14
end_check13:
	addi $t6, $zero, 12				# mult = 12
	b power_loop
check_character14:
	beq $t3, 68, end_check14		# if character is 'D'
	beq $t3, 100, end_check14		# or 'd'
	j check_character15
end_check14:
	addi $t6, $zero, 13				# mult = 13
	b power_loop
check_character15:
	beq $t3, 69, end_check15		# if character is 'E'
	beq $t3, 101, end_check15		# or 'e'
	j check_character16
end_check15:
	addi $t6, $zero, 14				# mult = 14
	b power_loop
check_character16:
	beq $t3, 70, end_check16		# if character is 'F'
	beq $t3, 102, end_check16		# or 'f', mult = 15
	j error							# otherwise, display error message
end_check16:
	addi $t6, $zero, 15				
	b power_loop

	.data
hex_str: .space 9
prompt: .asciiz "Enter Hexadecimal: "
error_msg: .asciiz "Invalid Hexadcimal Number\n"
dec_str: .asciiz "Decimal: "