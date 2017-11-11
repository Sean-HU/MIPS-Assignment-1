	.text
	.global main
main:
	la $a0, prompt									#load the "prompt" string into $a0
	li $v0, 4										#print prompt message
	syscall

	la $a0, hex_str
	li $a1, 100
	li $v0, 8		#read user input
	syscall

	add $t0, $zero, $zero

	.data
hex_str: .space 100
hex_lowercase: .asciiz "0123456789abcdef\n"			#used to check if input is valid
hex_uppercase: .asciiz "0123456789ABCDEF\n"
prompt: .asciiz "Enter Hexadecimal:\n"
error_msg: .asciiz "Invalid Hexadcimal Number\n"