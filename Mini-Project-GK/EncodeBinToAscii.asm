# input: chuoi ky tu binary (la binary co gia tri 0 hoac 1)
# output: chuoi ky tu ascii tuong ung voi binary input
# ---------------------
# y tuong thuat toan
# B1: kiem tra du lieu dau vao co phai la binary. neu hop le -> chuyen sang B2
# neu sai -> thong bao loi va thuc hien lai input
# B2: chuyen doi binary(8bit) sang DEC -> mot array kieu nguyen (co gia tri [0-255])
# B3: chuyen doi DEC cua tung phan tu sang ascii

.data
BIN_ARRAY: .space 240		# mang ky tu BIN toi da 240 phan tu
DEC_ARRAY: .space 120		# mang nguyen toi da 30 phan tu
INPUT_MESSAGE: .asciiz "Nhap chuoi so nhi phan: "
OUTPUT_MESSAGE: .asciiz "Chuyen doi sang ASCII: "
WANRNING_INPUT: .asciiz "Ban nhap khong hop le! (dau vao la binary)\n"

.text
main:
input:
	# hien thi INPUT_MESAGE
	la $a0, INPUT_MESSAGE
	li $v0, 4
	syscall
	# nhap chuoi 
	la $a0, BIN_ARRAY
	li $a1, 240
	li $v0, 8
	syscall
end_input:
check_input:
	jal CHECK_BIN		# goi thu tuc CHECK_BIN
	beq $v0, $0, warning	# neu loi -> canh bao loi
end_check_input:
	# chuyen mang BINARY sang mang INT
	jal DECODE_BINARY	# goi thu tuc DECODE_BINARY
	move $s0, $v0		# $s0: phan tu cua mang int
output:
	# hien thi OUTPUT_MESSAGE
	la $a0, OUTPUT_MESSAGE
	li $v0, 4
	syscall
	
	la $s1, DEC_ARRAY	# $s1 lay dia chi co so mang so nguyen
	li $t0, 0		# khoi tao bien dem($t0) = 0
	li $t1, 4		# khoi tao gia tri offset ($t1)
loop_output:
	beq $t0, $s0, end_output	# neu duyet het phan tu mang nguyen -> break
	mul $t2, $t0, $t1		# t2 = dem*4
	add $s2, $s1, $t2		# ($s2) dia chi co so cua phan tu mang nguyen hien tai
	lw $a0, 0($s2)			# $a0 = DEC_ARRAY[i] (phan tu hien tai)
	li $v0, 11			# doc ascii tuong ung voi gia tri DEC_ARRAY[i] (phan tu hien tai)
	syscall
	addi $t0, $t0, 1		# tang phan tu mang nguyen them 1
	j loop_output
end_output:
	j exit
warning:
	la $a0, WANRNING_INPUT
	li $v0, 4
	syscall
	j input
end_warning:

exit:
	li $v0, 10			# thoat ct
	syscall
end_main:

# produce check_bin
# kiem tra du lieu dau vao co phai la BINARY
# la BINARY -> return ($v0) = 1
# khong la BINARY -> return ($v0) = 0

CHECK_BIN:
	addi $sp, $sp, -20		# cap phat stack 5 phan tu
	sw $s2, 16($sp)			#
	sw $t0, 12($sp)			#
	sw $ra, 8($sp)			#
	sw $s0, 4($sp)			#
	sw $s1, 0($sp)			# cat gia tri cac thanh ghi su dung trong thu tuc nay vao stack
	
	la $s0, BIN_ARRAY		# $s0 lay dia chi co so cua BIN_ARRAY
	li $t0, 0			# khoi tao bien dem = 0
	li $v0, 1			# khoi tao gia tri tra ve la 1 (true)
loop_of_check:
	add $s1, $s0, $t0		# duyet ky tu hien tai
	lb $s2, 0($s1)			# lay ky tu hien tai vao $s2
	beq $s2, 10, end_loop_of_check	# neu ky tu la '\n' -> return
	beq $s2, $0, end_loop_of_check	# neu ky tu hien tai la NULL -> return
	beq $s2, 48, tang_dem		# neu ky tu hien tai la '0' -> duyet tiep phan tu ke tiep
	bne $s2, 49, return_of_check_false	#neu ky tu hien tai khong phai 0 hoac 1 ->  return 0
tang_dem:
	addi $t0, $t0, 1		# tang bien dem them 1
	j loop_of_check
end_loop_of_check:
	bne $t0, $0, end_CHECK_BIN	# neu length != 0 -> return 1
return_of_check_false:
	li $v0, 0			# return 0
end_CHECK_BIN:
	lw $s1, 0($sp)			#
	lw $s0, 4($sp)			#
	lw $ra, 8($sp)			#
	lw $t0, 12($sp)			#
	lw $s2, 16($sp)			# tra lai gia tri truoc cho thanh ghi tu stack
	addi $sp, $sp, 20		# giai phong stack
	jr $ra
	
# produce BIN_ARRAY_LENGTH
# tra ve so ky tu 0 ,1 trong BIN_ARRAY
BIN_ARRAY_LENGTH:
	addi $sp, $sp, -20		# cap phat 5 phan tu cho stack
	sw $ra, 16($sp)			#
	sw $t0, 12($sp)			#
	sw $s0, 8($sp)			#
	sw $s1, 4($sp)			#
	sw $s2, 0($sp)			# cat gia tri thanh ghi su dung trong thu tuc nay vao stack
	
	la $s0, BIN_ARRAY		# lay dia chi co so BIN_ARRAY vao $s0
	li $t0, 0			# khoi tao bien dem = 0
loop_BIN_ARRAY_LENGTH:
	add $s1, $s0, $t0		# dia chi cua ky tu hien tai
	lb $s2, 0($s1)			# lay gia tri ky tu hien tai BIN_ARRAY[i]
	beq $s2, 10, end_BINARRAY_LENGTH	# neu ky tu la '\n' -> return dem
	beq $s2, $0, end_BINARRAY_LENGTH	# neu ky tu la NULL -> return dem
	addi $t0, $t0, 1			# tang bien dem them 1
	j  loop_BIN_ARRAY_LENGTH

end_BINARRAY_LENGTH:
	add $v0, $t0, $0		# return dem
	
	lw $s2, 0($sp)			#
	lw $s1, 4($sp)			#
	lw $s0, 8($sp)			#
	lw $t0, 12($sp)			#
	lw $ra, 16($sp)			# tra lai gia tri ban dau vao thanh ghi
	addi $sp, $sp, 20		# giai phong stack
	jr $ra
# produce DECODE_BINARY
# 

DECODE_BINARY:
	addi $sp, $sp, -40		# cap phat 10 phan tu cho stack
	sw $ra, 36($sp)			#
	sw $t0, 32($sp)			#
	sw $t1, 28($sp)			#
	sw $t2, 24($sp)			#
	sw $t3, 20($sp)			#
	sw $t4, 16($sp)			#
	sw $s0, 12($sp)			#
	sw $s1, 8($sp)			#
	sw $s2, 4($sp)			#
	sw $s7, 0($sp)			# cat gia tri thanh ghi se su dung trong thu tuc nay vao stack
	
	la $s0, BIN_ARRAY		# $s0 luu dia chi BIN_ARRAY
	la $s2, DEC_ARRAY		# $s2 luu dia chi DEC_ARRAY
	li $t0, 0			# khoi tao bien dem ($t0) = 0 cua loop
	li $s1, 0			# khoi tao bien length ($s1) = 0 cua DEC_ARRAY
	jal BIN_ARRAY_LENGTH		# thuc hien produce BIN_ARRAY_LENGTH
	move $t1, $v0			# copy gia tri length ($v0) vao $t1
	li $t2, 8			# khoi tao so bits ($t2) = 8
	div $t1, $t2			# $t1 chia $t2
	mfhi $t3			# $t3 lay phan du
	mflo $t4			# $t4 lay phan thuong
	move $s1, $t4			# $s1 = $s4 (copy)
	beq $t3, $0, loop_DECODE_BINARY	# neu phan du ($t3) == 0 thi thuc hien  loop_DECODE_BINARY
	addi $s1, $s1, 1		# tang length ($s1) them 1
loop_DECODE_BINARY:
	beq $t0, $s1, end_loop_DECODE_BINARY	#
	beq $t3, $0, update_length_bit		# neu phan du bang 0 -> $s7 = 8 (bit) 
	add $s7, $t3, $0			# nguoc lai -> $s7 = phan du
	add $t3, $0, $0				# cap nhat lai phan du bang 0
	j add_on_DEC_ARRAY
update_length_bit:
	li $s7, 8				# s7 = 8 (bit) : dau vao so bit se doc trong block BIN8->DEC
add_on_DEC_ARRAY:
	jal CONVERT_BIN8_TO_DEC			# thuc hien thu tuc CONVERT_BIN8_TO_DEC
	sw $v0, 0($s2)				# cat gia tri DEC cua khoi 8 bit vao danh sach mang so nguyen DEC_ARRAY
tang_element_DEC_ARRAY:
	addi $s2, $s2, 4			# tang phan tu mang nguyen them 1
	addi $t0, $t0, 1			# tang bien dem cua loop them 1
	j loop_DECODE_BINARY
end_loop_DECODE_BINARY:
end_DECODE_BINARY:
	move $v0, $s1			# tra ve do dai cua mang DEC_ARRAY
	lw $s7, 0($sp)			#
	lw $s2, 4($sp)			#
	lw $s1, 8($sp)			#
	lw $s0, 12($sp)			#
	lw $t4, 16($sp)			#
	lw $t3, 20($sp)			#
	lw $t2, 24($sp)			#
	lw $t1, 28($sp)			#
	lw $t0, 32($sp)			#
	lw $ra, 36($sp)			# tra lai gia tri cac thanh ghi truoc do tu stack
	addi $sp, $sp, 40		# giai phong stack
	jr $ra
## produce CONVERT_BIN8_TO_DEC
## chuyen doi 8 bit BINARY sang DEC 
# dau vao: $s0: dia chi kytu dang xet cua BIN_ARRAY, $s7: so ky tu se doc tiep tu $s0
# return DEC([0,255])

CONVERT_BIN8_TO_DEC:
	addi $sp, $sp, -24		# cap phat 6 phan tu stack
	sw $s3, 20($sp)			#
	sw $ra, 16($sp)			#
	sw $t9, 12($sp)			#
	sw $t8, 8($sp)			#
	sw $s1, 4($sp)			#
	sw $s2, 0($sp)			# cat gia tri cac thanh ghi se su dung trong thu tuc nay vao stack
	
	li $v0, 0			#khoi tao gia tri tra ve DEC ($v0) = 0
	li $t9, 0			#khoi tao bien dem ($t9) = 0
	li $t8, 1			# khoi tao gia tri bit = 1
loop_CONVERT_BIN8_TO_DEC:
	beq $t9, $s7, end_CONVERT_BIN8_TO_DEC		# neu $t9 == $s7 thi thoat vong lap va return $v0 (DEC)
	add $s3, $s0, $t9				# cap nhat dia chi BIN_ARRAY ($s0) them 1
	lb $s1, 0($s3)					# lay ky tu tai dia chi $s0 vao $s1
	beq $s1, 48, tang_dem_t9			# neu ky tu ($s1) la ky tu 0 thi duyet tiep
	sub $t7, $s7, $t9				# t7 = s7 - t9
	addi $t7, $t7, -1				# t7 = t7 - 1	($t7) la so dich bit sang trai(sllv)
	sllv $s2, $t8, $t7 				# neu ky tu do la 1 thi $s2 la ket qua dich $t9 bit (hay 2^($t9))
	add $v0, $v0, $s2				# cong them vao gia tri tra ve $s2
tang_dem_t9:
	addi $t9, $t9, 1				# tang bien dem them 1
	j loop_CONVERT_BIN8_TO_DEC

end_CONVERT_BIN8_TO_DEC:
	add $s0, $s0, $s7				# cap nhat con tro dia chi hien tai trong danh sach ku ty BINARY
	lw $s2, 0($sp)					#
	lw $s1, 4($sp)					#
	lw $t8, 8($sp)					#
	lw $t9, 12($sp)					#
	lw $ra, 16($sp)					#
	lw $s3, 20($sp)					# tra lai gia tri cac thanh ghi tu stack
	addi $sp, $sp, 24				# giai phong stack
	jr $ra
