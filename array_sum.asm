# array-sum.asm
# Exercise 3 Part 3

# Start-up and clean-up code copied from stub1.asm

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciiz	"About to exit. main returned"
exit_msg_2:
	.asciiz	".n"
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


# Global variables
	.data
	# int abc[ ] = {-32, -128, -4, -16, -8, -64}
	.globl	abc	
abc:	.word	-32, -128, -4, -16, -8, -64

# Hint for checking that the original program works
# The sum of the six array elements is -252, which will be represented
# as 0xffffff04 in a MIPS GPR.

# Hint for checking that your final version of the program works
# The maximum of the four array elements is -4, which will be represented
# as 0xfffffffc in a MIPS GPR.


# int main(void)
#
# local variable	register
#   int sum		$s0
#   int max		$s1  (to be used when students enhance the program)
#   int p		$s2
#   int end		$s3

	.text
	.globl	main
main:
	la	$s2, abc		# p = abc
	addi	$s3, $s2, 24		# end = p + 6
	add	$s0, $zero, $zero	# sum = 0 
	lw 	$t0, ($s2)		#load first value for t0
	
	# ***I added this initializer so that the first element in our word is the first value we test.
	add 	$s1, $zero, $t0		#set max to be the first value of t0
	
L1:
	beq	$s2, $s3, L2		# if (p == end) goto L2
	lw	$t0, ($s2)		# $t0 = p
	add	$s0, $s0, $t0		# sum += $t0
	addi	$s2, $s2, 4		# p++
	
	#I added this part: 
	slt $t4, $s1,$t0		#t4 will store our bool value true or 1 if s1 is less than t0
	beq $t4, 1, L3			#then we can check if t4 is equal to true or 1, and if it is then we go to l3
					
	# *** woops just read the part where im not allowed to use this branch, this was my original solution 
	# bgt $t0, $s1, L3		#if $t0 is greater than our current max jump to L3
	
	j	L1			#otherwise, jump back to L1 and iterate again
L2:		
	add	$v0, $zero, $zero	# return value from main = 0
	jr	$ra
	
	# ***I added this L3:
L3:
	add $s1, $zero, $t0		#max = $t0
	j L1 				#jump back to L1 and iterate again