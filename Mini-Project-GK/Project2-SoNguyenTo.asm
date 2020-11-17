#------------------------------------------------------------
# trong ham main thuc hien khai bao, nhap 2 so nguyen N va M
# kiem tra N va M neu N <= M thi thuc hien tim so nguyen to
# nguoc lai exit
# trong do Mang A luu tru cac phan tu so nguyen to
# trong pham vi so nguyen tu N den M
#------------------------------------------------------------ 
.data
A:	.word 
Message_N:	.asciiz "Nhap so nguyen N:"
Message_M:	.asciiz "Nhap so nguyen M:"
Null:		.asciiz "Khong co so nguyen to nao trong pham vi."
Canh_Bao:	.asciiz "ERROR! Ban nhap khong hop le!\n(so nguyen N phai nho hon hoac bang so nguyen M)."
space:		.asciiz " "
Print:		.asciiz  "in ra danh sach so nguyen to:\n"
.text
main:
nhap_N:				# nhap so nguyen N
	li	$v0, 51
	la	$a0, Message_N
	syscall
	addi	$s0, $a0, 0	# $s0 = $a0 = N
nhap_M:				# nhap so nguyen M
	addi	$v0,$0, 51
	la	$a0, Message_M
	syscall
	addi	$s1, $a0, 0	# $s1 = $a0 = M
end_nhap:	
	la	$s2,A		# lay dia chi co so mang A vao $s2
	addi	$t7,$0,0	#index of array A
	blt	$s1,$s0, error	# neu s1 < s0 (M < N) thi branch error
	
	addi	$t0,$s0,0	#khoi tao t0 = N
loop:	slt	$t1,$s1, $t0 		# t1 = 1 neu M < t0
	bne	$t1,$0, end_loop	# neu t1 = 1 thi branch end
	jal	is_prime		# goi thu tuc is_prime
	bne	$v0,$0, tang_dem	#neu t3 = 1 thi branch tang_dem
	sll	$t6,$t7,2		#t6 =4 * t7 = 4 * index
	add	$t6,$t6,$s2		# t6 = address A[index] 
	addi	$t7,$t7,1		# index += 1
	sw	$t0,0($t6)		#A[index] = t0;
tang_dem:	addi $t0,$t0,1		# t0 += 1
	j	loop
end_loop:
thongbao_rong:	bne	$t7,$0, printf	# t7 != 0 branch printf 
		li	$v0, 55
		la	$a0, Null
		li	$a1, 1
		syscall			# thong bao khong co so nguyen to nao
end_thongbao_rong:	j	exit

printf:
	li	$v0, 4
	la	$a0, Print
	syscall

	li	$t8, 0			#j = 0
print_prime:
	beq	$t7, $t8, end_print_prime
	sll	$t9, $t8, 2	# 4j
	add	$s7, $s2,$t9	# address A[j]
	lw	$s6,0($s7)	# s6 = A[j]
	li $v0, 1		# print A[i]
	add $a0,$0,$s6
	syscall 
	addi $v0, $0, 4		# print ' '
	la	$a0, space
	syscall
	addi $t8, $t8 ,1	# j++
	j	print_prime
end_print_prime:
end_printf:	j	exit

error:	li	$v0, 55		# canh bao loi
	la	$a0, Canh_Bao
	li	$a1, 0
	syscall
end_error:
exit:	addi	$v0,$0, 10	# v0 =10 , exit 
	syscall

end_main:
#---------------
# procedure is_prime la thu tuc kiem tra 1 so nguyen
# trong pham vi so nguyen tu N den M (voi N <= M, N va M thuoc Z)
# neu la so nguyen tra ve t3 = 0 nguoc lai t3 = 1
# trong chuong trinh hop ngu nay 
# do thanh ghi su dung ko qua nhieu de thao tac cac toan hang
# nen chung em khong su dung $sp de luu gia tri cua thanh ghi
# tuy nhien neu nhu chuong trinh co cac thu tuc long nhau thi phai su dung $sp
#---------------
is_prime:	
dk1:	slti	$t2,$t0,2	# $t2 = 1 neu t0 < 2
	beq	$t2, $0, dk2	# t2 = 0 thi branch dk2
	addi	$v0, $0, 1	# v0 = 1 (t0 khong phai so nguyen to)
	j	end_is_prime	
end_dk1:	
dk2:	addi	$s3,$0,2	#i = 2 = s3
	bne	$t0, $s3, else	# neu t0 != 2 thi branch else
	add	$v0,$0,$0	# v0 = 0 (t0 la so nguyen to)
	j	end_is_prime
end_dk2:	
else:	div	$s4,$t0,$s3		# s4  = t0/2
	addi	$v0, $0,0		# t3 = 0
for:	blt	$s4,$s3, end_for	#neu s4 < s3 (t0/2 < i) thi branch end_for
	div	$t0,$s3			# t0 chia s3
	mfhi	$t4			# t4 = t0 mod s3 (lay gia tri $hi vao $t4)
	addi	$s3,$s3,1		# i += 1
	beq	$t4,$0, not_prime	# neu t4 = 0 thi branch not_prime
	j	for
not_prime:	addi	$v0,$v0,1	# t3 = 1 (t0 khong phai la so nguyen to)
end_for:
end_else:
end_is_prime:	jr	$ra
