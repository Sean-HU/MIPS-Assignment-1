
	
	.text
main:
	la $a0, hex_str
	li $a1, 100
	li $v0, 8		#read user input
	syscall


	.data
hex_str: .space 100
hex_lowercase: .asciiz "0123456789abcdef\n"			#used to check if input is valid
hex_uppercase: .asciiz "0123456789ABCDEF\n"
prompt: .asciiz "Enter Hexadecimal:\n"
error_msg: .asciiz "Invalid Hexadcimal Number\n"