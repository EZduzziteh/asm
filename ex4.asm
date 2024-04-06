# stub1.asm

# This program has complete start-up and clean-up code, and a "stub"
# main function.

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciiz	"***About to exit. main returned "
exit_msg_2:
	.asciiz	".***\n"
main_rv:
	.word	0
	
	.text
	# adjust $sp, then call main
	addi	$t0, $zero, -32		# $t0 = 0xffffffe0
	and	$sp, $sp, $t0		# round $sp down to multiple of 32
	jal	main
	nop
	
	# when main is done, print its return value, then halt the program
	sw	$v0, main_rv	
	la	$a0, exit_msg_1
	addi	$v0, $zero, 4
	syscall
	nop
	lw	$a0, main_rv
	addi	$v0, $zero, 1
	syscall
	nop
	la	$a0, exit_msg_2
	addi	$v0, $zero, 4
	syscall
	nop
	addi	$v0, $zero, 10
	syscall
	nop	
# END of start-up & clean-up code.


	.data
	.globl foo
foo: .word 0xd3, 0xe3, 0xf3, 0xc3, 0x83, 0x93, 0xa3, 0xb3
	.globl bar
bar: .word 0x80, 0x70, 0x60, 0x50, 0x40, 0x30, 0x30, 0x10

	.text
	.globl	main
	
#setup variables
main:
	add $s0, $zero, $zero 		# int *p = 0
	add $s1, $zero, $zero 		# int *q = 0
 	add $s2, $zero, $zero 		# int* stop = 0;
	la $s4, foo			# p = foo
	la $s6, bar			#q = bar
 	lw $s3, ($s4)			# int min($s3) = foo[0]
 	add $s5, $zero, $zero		# int i = 0;			
	addi $s5, $zero, 1		# i = 1;
	
# Put value of smallest element of foo into min.
# while loop i < 8
L1:
	slti    $t0, $s5, 8   		# hold bool value, true if $s5(i) less than 8
	beq	$t0, 0, L3		# i>=8, end loop
	lw	$t1, ($s4)		# $t1 = foo
	slt 	$t2, $t1, $s3			#if  foo[i] < min, this bool will be true.
	beq	$t2, 1, L2

	addi	$s4, $s4, 4		# increment foo array element
	addi    $s5, $s5, 1		# i++
	j L1

# if foo[i]<min, set min = foo[i]
L2: 

	lw 	$s3, ($s4)		# min = foo[i];
	addi	$s4, $s4, 4		# increment foo array element
	addi    $s5, $s5, 1		# i++
	j L1 				# go back to while loop

#initialize second part of program.
L3: 
	lw 	$s0, 28($s4)  		#  p = foo + 8;
	add 	$s5, $zero, $zero	# i = 0;
	j L4
	
# Copy elements from bar to foo in reverse order,
# writing over the initial values in foo.
L4:
	slti    $t0, $s5, 8   		# hold bool value, true if $s5(i) less than 8
	beq	$t0, 0, L6		# i>=8, end loop
	subi 	$s4, $s4, 4		# --p
	lw	$t1, ($s6)		# $t1 = bar[i]
	sw 	$t1, ($s4)		#*p = *q or foo[i] = bar[j]
	addi	$s6, $s6, 4		# ++q
	addi 	$s5, $s5, 1		# i++
	j L4
	

#I just created this to test all of the values of foo after my program runs, change line 93 to jump to L5 instead of L6 if you want to run this and see the output of foo in the t registers
L5: 
	lw 	$t0, ($s4)  	
	lw 	$t1, 4($s4)  		
	lw 	$t2, 8($s4)  		
	lw 	$t3, 12($s4)  	
	lw 	$t4, 16($s4)  		
	lw 	$t5, 20($s4)  
	lw 	$t6, 24($s4)  		
	lw 	$t7, 28($s4)  		
	j L6

#end the program
L6:

	add	$v0, $zero, $zero	# return value from main = 0
	jr	$ra
	
	



	
