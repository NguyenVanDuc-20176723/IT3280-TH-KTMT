.data
#tao struct S de luu tru cac string Doi Xung voi 10 phan tu, moi phan tu ung voi 24 byte
#trong moi phan tu struct co String (20 byte) va Length (4 byte) 
Struct:	.space	240
Message_Str:	.asciiz "Nhap chuoi: "
Message_N:	.asciiz "So nguyen N chuoi muon nhap: "
Message_errorN:	.asciiz "Nhap khong hop le! so nguyen N phai lon hon hoac bang 0."
Message_Null:	.asciiz "Khong co phan tu nao trong Struct"
Message_Waning:	.asciiz "hien tai Struct da day!"
Message_printf:	.asciiz "in ra danh sach chuoi doi xung:\n"
Message_strName:	.asciiz "strName = \""
Message_length:		.asciiz "\", length = "
Str:	.space 20
.text
#chuong trinh chinh (main)
main:
	la	$s0, Struct	# s0 = address co so cua Struct
	addi	$s1, $0, 0	# khoi tao index = 0, so luong phan tu Struct
nhap_N:
	addi	$v0, $0, 51
	la	$a0, Message_N
	syscall			#nhap so nguyen N
end_nhap_N:
	add	$s2, $a0, $0	# s2 = N
	blt	$s2, $0, error	# neu N < 0 , branch error 
	addi	$t0, $0, 0	# i = 0
	add	$s7, $s0, $0	# s7 = s0 = address co so cua Struct
loop:	beq	$t0, $s2, end_loop	#i = N branch end_loop
nhap_Str:
	addi	$v0, $0, 54
	la	$a0, Message_Str
	la	$a1, Str
	addi	$a2, $0, 20
	syscall			# nhap chuoi Str
end_nhap_Str:
	
length_Str:
	la	$s3, Str	# s3 = address co so cua Str
	addi	$s4, $0, 0	# length = 0
	addi	$t1, $0, 0	# j = 0;
	addi	$t2, $0, 10	# t2 = '\n' trong ASCII 
check_char:
	add	$t3, $s3, $t1	# t3 = address Str[j]
	lb	$t4, 0($t3)	# t4 = Str[j]
	seq	$t5, $t4, $0	# t5 = 1 neu t4 = 0 (Str[j] = '\0'), nguoc lai t5 = 0
	seq	$t6, $t4, $t2	# t6 = 1 neu t4 = 10 (Str[j] = '\n'), nguoc lai t6 = 0
	or	$t7, $t5, $t6	# t7 = 0 neu t5 hoac t6 bang 1, nguoc lai t7 = 0
	bne	$t7, $0, end_check_char	# t7 = 1 branch end_check_char
	addi	$s4, $s4, 1	# length += 1
	addi	$t1, $t1, 1	# j += 1
	j	check_char
end_check_char:
end_length_Str:
	jal	strDoiXung
	bne	$v0, $0, tang_i	#v0 = 1 -> khong phai string doi xung, Branch tang_i
	jal	kiemTraDS
	bne	$v0, $0, tang_i #v0 =1 -> da co trong ds, branch tang i
add_Struct:
	addi	$t8, $s7, 0		# t8 = address co so cua Struct[index]
	addi	$t9, $0, 0		# t9 = 0
add_str:
	beq	$t9, $s4, end_add_str	#t9 = length branch end_add_str
	add	$s5, $s3,$t9		# s5  = address Str[t9]
	lb	$s6, 0($s5)		# s6 = Str[t9]
	sb	$s6, 0($t8)		# Struct[index].strName[t9] = Str[t9]
	addi	$t8, $t8, 1		# t8 += 1
	addi	$t9, $t9, 1		# t9 += 1
	j	add_str
end_add_str:
add_length:
	add	$t8, $s7, 20		# t8 = address Struct[index].length
	sw	$s4, 0($t8)		# Struct[index].length = length
end_length:
	addi	$s1, $s1, 1		# index += 1
	addi	$s7, $s7, 24		# s7 = address co so Struct[index]
end_add_Struct:
tang_i:	addi	$t0, $t0, 1	#i += 1
	j	loop
end_loop:
	beq	$s1, $0, rong		# index = 0, branch rong
	beq	$s1, 10, canh_bao	# index = 10, brach canh_bao
	
print:	jal	printf			# printf Struct
end_print:	j	exit
rong:	li	$v0, 55
	la	$a0, Message_Null
	addi	$a1, $0, 3
	syscall				# thong bao Struct rong
end_rong:	j	exit
canh_bao:
	li	$v0, 55
	la	$a0, Message_Waning
	addi	$a1, $0, 2
	syscall				# canh bao Struct da day
end_canh_bao:	j	print
error:	li	$v0, 55
	la	$a0, Message_errorN
	addi	$a1, $0, 1
	syscall	
end_error:
exit:	addi	$v0,$0, 10
	syscall			# thoat CT
end_main:
#--------------
#procedure strDoiXung
# thu tuc nay kiem tra xem chuoi nhap vao co phai la chuoi doi xung ko?
# neu dung thi v0 = 0, nguoc lai v0 = 1
#----------------
strDoiXung:
	#luu tru gia tri cua 8 thanh ghi su dung trong procedure nay vao stack
	addi	$sp, $sp, -32
	sw	$t0, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	sw	$t5, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	
	addi	$t0, $0, 0	# khoi tao t0  = 0 la string doi xung
	beq	$s4, $0, not_strDoiXung
	addi	$t1, $0, 2	# t1 = 2
	div	$s4, $t1	# s4 chia t1 (length / 2)
	mflo	$t2		# lay phan nguyen (length / 2)
	addi	$t3, $0, 0	# i = 0
for:	blt	$t2, $t3, end_for	# (length/2) < i branch end_for
	add	$t4, $t3, $s3	#t4 = address Str[i]
	lb	$s0, 0($t4)	# s0 = Str[i]
	addi	$t5, $t3, 1	# t5 = i + 1
	sub	$t5, $s4, $t5	# t5 = length - (i+1) = length - i - 1
	add	$t5, $s3, $t5	# t5 = address Str[length - i - 1] 
	lb	$s1, 0($t5)	# s1 = Str[length - i - 1]
	bne	$s0, $s1, not_strDoiXung	# Str[i] != Str[length - i -1] branch not_strDoiXung
	addi	$t3, $t3, 1	# i += 1
	j	for 
end_for:	j	tra_gia_tri_thanh_ghi
not_strDoiXung:	addi	$t0,$0, 1	# t0 = 1 -> string khong doi xung
tra_gia_tri_thanh_ghi:
	add	$v0, $0, $t0		# return gia tri t0 
	#tra lai gia tri cua 8 thanh ghi trong stack
	lw	$s1, 0($sp)
	lw	$s0, 4($sp)
	lw	$t5, 8($sp)
	lw	$t4, 12($sp)
	lw	$t3, 16($sp)
	lw	$t2, 20($sp)
	lw	$t1, 24($sp)
	lw	$t0, 28($sp)
	addi	$sp, $sp, 32
end_strDoiXung:	jr	$ra
#----------
# procedure kiemTraDS
# thu tuc nay co string nhap vao la 1 chuoi doi xung
# neu chuoi nay da co trong danh sach thi v0 = 1, nguoc lai v0 = 0
#----------------
kiemTraDS:
	#cat gia tri cac thanh ghi vao stack
	addi	$sp, $sp, -36
	sw	$t0, 32($sp)
	sw	$t1, 28($sp)
	sw	$t2, 24($sp)
	sw	$t3, 20($sp)
	sw	$t4, 16($sp)
	sw	$t5, 12($sp)
	sw	$t6, 8($sp)
	sw	$s5, 4($sp)
	sw	$s6, 0($sp)

	add	$t1, $0, $0	#i = 0
	add	$t0, $0, $0	# t0 = 0 khong co trong DS
for1:	beq	$t1, $s1, end_for1	#i = index branch end_for
	mul	$t2, $t1, 24	# t1 = 24*i
	add	$t2, $t2, 20	# t1 = 24*i + 20
	add	$t2, $t2, $s0	# t2 = address Struct[i].length
	lw	$t3, 0($t2)	#t3 = Struct[i].length
	bne	$t3, $s4, tang	#Struct[i]. length = length branch tang
	add	$t4, $0, $0	# j = 0
	addi	$t2, $t2, -20	# t2 = address Struct[i].strName
strcmp:	beq	$t4, $s4, end_strcmp	# i = length branch end_strcmp
	add	$t5, $s3, $t4	# t5 = address Str[j]
	lb	$s5, 0($t5)	# s5 = Str[i]
	add	$t6, $t2, $t4	# t6 = address Struct[i].strName[j]
	lb	$s6, 0($t6)	# s6 = Struct[i].strName[j]
	bne	$s5, $s6, tang	# Str != Struct[i].strName branch tang
	addi	$t4, $t4, 1
	j	strcmp
end_strcmp:	j	co_trongDS
tang:	addi	$t1, $t1, 1	# i += 1
	j	for1
end_for1:	j	tra_Value_thanh_ghi
co_trongDS:	addi	$t0, $0, 1	#s0 = 1 : co trong danh sach
tra_Value_thanh_ghi:
	add	$v0, $t0, $0	# v0 = t0
	#lay lai gia tri thanh ghi trong stack
	lw	$s6, 0($sp)
	lw	$s5, 4($sp)
	lw	$t6, 8($sp)
	lw	$t5, 12($sp)
	lw	$t4, 16($sp)
	lw	$t3, 20($sp)
	lw	$t2, 24($sp)
	lw	$t1, 28($sp)
	lw	$t0, 32($sp)
	addi	$sp, $sp, 36
end_kiemTraDS:	jr $ra
#--------------
#procedure printf
# thu tuc nay de in cac phan tu trong ds ra man hinh
# do chuong trinh hien tai su dung nhieu thanh ghi
# de tranh ghi de gia tri cac thanh ghi -> dan den anh huong den ket qua
# nen toi su dung procedure nay de (voi cac thanh ghi su dung gan, khoi tao..
# toi se cat no vao trong stack ($sp) roi tra lai cho cac thanh ghi cua no)
#-------------
printf:	
	#cat gia tri thanh ghi vao stack
	addi	$sp, $sp, -28	
	sw	$t0, 24($sp)
	sw	$t1, 20($sp)
	sw	$t2, 16($sp)
	sw	$t3, 12($sp)
	sw	$t4, 8($sp)
	sw	$t5, 4($sp)
	sw	$t6, 0($sp)

	add	$t0, $s0, $0	# t0 = address co so cua Struct
	add	$t1, $0, $0	# i = 0
	
	li	$v0, 4
	la	$a0, Message_printf
	syscall			# message_print
for_print:
	beq	$t1, $s1, end_for_print
	addi	$t2, $t0, 20	# t2 = address Struct[i].length
	lw	$t3, 0($t2)	# t3 = Struct[i].length
	add	$t4, $0, $0	# j = 0
	
	li	$v0, 4
	la	$a0, Message_strName
	syscall			#Message_strName
put_strName:
	beq	$t4, $t3, end_put_strName	# j = Struct[i].length brach end_put_strName
	add	$t5, $t0, $t4			# t5 = address Struct[i].strName[j]
	lb	$t6, 0($t5)			# t6 = Struct[i].strName[j]
	
	li	$v0, 11
	add	$a0, $t6, $0
	syscall
	addi	$t4, $t4, 1
	j	put_strName
end_put_strName:
	li	$v0, 4
	la	$a0, Message_length
	syscall			# Message_length
put_length:
	li	$v0, 1
	add	$a0, $t3, $0
	syscall			# put length
	
	li	$v0, 11
	addi	$a0, $0, 10
	syscall			# xuong dong
end_put_length:
	addi	$t1, $t1, 1	# i += 1
	addi	$t0, $t0, 24	# t0 = address Struct[i]
	j	for_print
end_for_print:
	#lay lai gia tri thanh ghi trong stack ra
	lw	$t6, 0($sp)
	lw	$t5, 4($sp)
	lw	$t4, 8($sp)
	lw	$t3, 12($sp)
	lw	$t2, 16($sp)
	lw	$t1, 20($sp)
	lw	$t0, 24($sp)
	addi	$sp, $sp, 28
end_printf:	jr	$ra
#----------------------
#thuc hien code voi ngon ngu C 
#voi muc dich tim kiem huong di dung cho chuong trinh nay
# bo cuc chuong trinh theo mau o code lam cho chuong trinh dep va de hieu.
#-----------------------