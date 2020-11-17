# Tac gia: Nguyen Van Duc
# MSSV: 20176723
# Ngay tao: 19/06/2020
########################### De tai ###############################################
# kiem tra cu phap cua cau lenh (lenh that) hop ngu MIPS cua nguoi dung nhap vao co hop le !?
##################################################################################
# ---------------------- Y tuong thuat toan -----------------------------
# B1 : kiem tra OpCode cau lenh nhap vao hop le. neu hop le chuyen qua B2,
# nguoc lai dua ra thong bao va ket thuc.
# B2 : lay thong tin khuon dang lenh cua tung toan hang ung voi OpCode
#	+, kiem tra toan hang 1 cua dong lenh (neu co) co hop le. neu hop le xet tiep toan hang 2, 
#	   nguoc lai dua ra thong bao va ket thuc.
#       +, Kiem tra toan hang 2 cua dong lenh (neu co) co hop le. neu hop le xet tiep toan hang 3,
#	   nguoc lai dua ra thong bao va ket thuc.
#       +, Kiem tra toan hang 3 (neu co) co hop le. neu hop le chuyen sang B3,
#	   nguoc lai dua ra thong bao va ket thuc.
# B3 : kiem tra cac ky tu sau cau dong lenh khi hoan thanh B2.
#       neu co ky tu khac voi cac ky tu nhu: ' ' , '\tab', '\n' , '#'
#	thi dua ra thong bao va ket thuc.
#	nguoc lai, chuyen qua B4.
# B4 : in ra thong tin ung voi OpCode va ket thuc chuong trinh.
#-------------------------------------------------------------------------
#--------- Chuong trinh -----------------------------
# su dung file ten la: "OpCode.txt" de luu cac khuon dang lenh.
# su dung cau truc Library_Opcode de luu thong tin doc tu file "OpCode.txt" (chu y: kiem tra duong dan khi doc file)
# su dung file ten la: "Registers.txt" de luu tap cac thanh ghi
# su dung cau truc List_Registers de luu thong tin doc tu file "Registers.txt" (chu y: kiem tra duong dan khi doc file)
# cac ham, thu tuc can co:
# 	+, chuong trinh chinh main.
# 	+, skipBlack ( bo qua cac khoang trang)
#	+, check_Opcode ( doc opcode cua dong lenh va kiem tra tinh hop le)
#	+, check_Toan_Hang ( doc va kiem tra tinh hop le cua tung toan hang theo khuon dang lenh)
#	   trong ham check_Toan_Hang con co cac thu tuc long nhau:
#		read_ToanHang : doc cac toan hang cua dong lenh
#		check_register : kiem tra toan hang co phai la thanh ghi
#		check_Number : kiemtra toan hang co phai la hang so nguyen
#		check_Hex : kiem tra toan hang co phai la dang HEX
#		check_Label : kiem tra toan hang co phai la nhan
# in ra chu ky OpCode neu lenh hop le
# dong cac file truoc khi thoat chuong trinh.
#----------------------------------------------------------------------------------------
# y tuong bo sung(khac): co nhap cac cau lenh ra mot file, sau do doc file do vao mot struct de duyet lan luot.
#-------------------------------------------------------------------------------------

.data
File_OpCode:	.asciiz "/home/duc/kien-truc-may-tinh/Project/OpCode.txt"
File_Registers:	.asciiz "/home/duc/kien-truc-may-tinh/Project/Registers.txt"
Message_input:	.asciiz "Ban hay nhap vao 1 dong lenh:\n"
Message1_Command:	.asciiz "\n--------------@ Command @ -----------------\n"
Message2_Command:	.asciiz "---------------------------------------------\n"
Ky_Tu_Label:		.asciiz "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789\n"
Ky_Tu_Hex:		.asciiz "0123456789abcdefABCDEF\n"
Message1_Opcode:	.asciiz "opcode: "
Message2_Opcode:	.asciiz ",hop le\n"
Waning_Opcode:		.asciiz ",la khong hop le!\n"
Waning_Command:		.asciiz "Khong tim duoc khuon dang lenh nay!\n"
Waning_CuPhap:		.asciiz "error!!!Lenh nay khong dung cu phap!\n"
Message_ToanHang1:	.asciiz "Toan hang1: "
Message_ToanHang2:	.asciiz "Toan hang2: "
Message_ToanHang3:	.asciiz "Toan hang3: "
Message_Chu_ky:		.asciiz "Chu ky cua lenh nay la: "
Message_Oh_My_God:	.asciiz "Oh My God!! Hoan Thanh! Lenh vua nhap vao phu hop voi cu phap!\n(*_*) Hanh phuc qua cac ban oi!\n"
Error_Open_File:	.asciiz "Khong the mo file!"

Command:	.space 100				# dong lenh
OpCode:		.space 15				# opcode cua dong lenh
ToanHang1:	.space 30				# toan hang thu 1 cua dong lenh
ToanHang2:	.space 30				# toan hang thu 2 cua dong lenh
ToanHang3:	.space 30				# toan hang thu 3 cua dong lenh
#List_Command:	.space 790				# cau truc luu cac Command hop le
List_Registers:	.space 500				# danh sach cac thanh ghi
Library_Opcode:		.space 1000			# cau truc cac khuon dang lenh

.text
main:
	la	$s2, Command				# luu address co so Command vao s2
#	la	$s3, List_Command			# luu address co so List_Command vao s3
open_file_opcode:
	li	$v0, 13
	la	$a0, File_OpCode
	li	$a1, 0
	syscall						# mo file OpCode.txt
	move	$s0, $v0
	bltz	$s0, error				# kiem tra file co doc duoc ko?

open_file_registers:
	li	$v0, 13
	la	$a0, File_Registers
	li	$a1, 0
	syscall						# mo file Regusters.txt
	move	$s1, $v0
	bltz	$s1, error				# kiem tra file co doc duoc ko?

read_file_opcode:
	li	$v0, 14
	move	$a0, $s0
	la	$a1, Library_Opcode
	li	$a2, 1000
	syscall						# doc file OpCode.txt

read_file_registers:
	li	$v0, 14
	move	$a0, $s1
	la	$a1, List_Registers
	li	$a2, 500
	syscall						# doc file Registers.txt
input_command:
	li	$v0, 4
	la	$a0, Message_input
	syscall
	
	li	$v0, 8
	la	$a0, Command
	li	$a1, 100
	syscall						# nhap vao dong lenh
end_input_command:

print:
print_Command:
	li	$v0, 4
	la	$a0, Message1_Command			# message 1 command
	syscall
	la	$a0, Command
	syscall						# in ra Command
	la	$a0, Message2_Command
	syscall						# message 2 command
#--------xu ly----------------------
xy_ly_Commnad:
	add	$s7, $0, $0				# khoi tao index = 0  
	add	$s6, $0, $0				# s6 : address OpCode in Library_Opcode (neu co)

	jal	skipBlack				# bo qua khoang trang
	nop
check_OpcodeOfCommand:
	jal	check_Opcode				# kiemtra opcode co hop le
	nop
	beq	$v0, $0, waning_opcode			# ko hop le  -> waning_Opcode
	
	li	$v0, 4					# hop le  ->  in ra OpCode hop le!
	la	$a0, Message1_Opcode
	syscall
	li	$v0, 4
	la	$a0, OpCode
	syscall
	li	$v0, 4
	la	$a0, Message2_Opcode
	syscall

	jal	skipBlack				# bo qua khoang trang
	nop
	
	jal	check_Toan_Hang				# kiem tra cac toan hang cua OpCode
	nop
	beq	$v0, $0, waning_command
check_cac_ky_tu_con_lai:
	jal	skipBlack				# bo qua khang trang
	nop
	#------------- phan bo qua chu thich------------
	add	$t0, $s2, $s7				# t0 : address Command[index]
	lb	$t1, 0($t0)				# t1 = Command[index]
	bne	$t1, 35, check_KetThuc_Command		# Command[index] != '#' --> check_KetThuc_Command
	addi	$s7, $s7, 1				# index += 1
duyet_het_Command:
	add	$t0, $s2, $s7				# t0 : address Command[index]
	lb	$t1, 0($t0)				# t1 = Command[index]
	beq	$t1, 10, end_duyet_het_Command		# Command[index] == '\n'  --> ket thuc
	addi	$s7, $s7, 1				# index += 1
	j	duyet_het_Command
end_duyet_het_Command:
	j	Opcode_chu_ky
	#----------------------------------------------------------
check_KetThuc_Command:	
	bne	$t1, 10, error_cu_phap			# Command[index] != '\n' --> lenh khong hop le!
Opcode_chu_ky:						# in ra thong tin chu ky ung voi OpCode
	li	$v0, 4
	la	$a0, Message_Chu_ky
	syscall
	addi	$t3, $s6, 15				# t3 : address chu ky Opcode
	lb	$t4, 0($t3)				# t4 = chu ky
	li	$v0, 11
	move	$a0, $t4
	syscall						# message chu ky
	li	$v0, 11
	addi	$a0, $0, 10			
	syscall						# xuong dong
end_Opcode_chu_ky:
Oh_My_God:						# thong bao hop le
	li	$v0, 4
	la	$a0, Message_Oh_My_God
	syscall
end_check_CKTCL:
	j	close_file
#--------ket thuc xu ly-------------

waning:							# phan canh bao trong qua trinh xu ly command
waning_opcode:
	li	$v0, 4
	la	$a0, Message1_Opcode
	syscall
	li	$v0, 4
	la	$a0, OpCode
	syscall
	li	$v0, 4
	la	$a0, Waning_Opcode
	syscall
waning_command:
	li	$v0, 4
	la	$a0, Waning_Command
	syscall
end_waning:
	j	close_file
error_cu_phap:
	li	$v0, 4
	la	$a0, Waning_CuPhap
	syscall
end_error_cu_phap:
	j	close_file
error:							# bao loi doc file
	li	$v0, 4
	la	$a0, Error_Open_File
	syscall
end_error:

close_file:						# phan dong file
close_file_opcode:
	li	$v0, 16
	move	$a0, $s0
	syscall						# dong file OpCode.txt

close_file_registers:
	li	$v0, 16
	move	$a0, $s1
	syscall						# dong file Registers.txt
	
end_close_file:
exit:
	li	$v0, 10
	syscall						# thoat CT
end_main:

############ Procedure skipBlack ##############
### bo qua khoang trang
#############################################
skipBlack:
	addi	$sp, $sp, -20
	sw	$t0, 16($sp)
	sw	$t1, 12($sp)
	sw	$t7, 8($sp)
	sw	$t8, 4($sp)
	sw	$t9, 0($sp)
	 
lap:	add	$t0, $s2, $s7				# address Command[index]
	lb	$t1, 0($t0)				# t1 = Command[index]
	seq	$t9, $t1, 32				# t9 = 1 if Command[index] == ' '
	seq	$t8, $t1, 9				# t8 = 1 if Command[index] == '\tab'
	or	$t7, $t8, $t9
	beq	$t7, $0, end_lap			# !(Command[index] == ' ' or Command[index] == '\tab') -> thoa vong lap
	addi	$s7, $s7, 1				# tang index (index++)
	j	lap
end_lap:	
	lw	$t9, 0($sp)
	lw	$t8, 4($sp)
	lw	$t7, 8($sp)
	lw	$t1, 12($sp)
	lw	$t0, 16($sp)
	addi	$sp, $sp, 20
end_skipBlack: jr	$ra


############### Procedure check_Opcode #######
# kiem tra tinh hop le cua opcode lenh nhap vao
############################################
check_Opcode:
luu_value_registers:
	addi	$sp, $sp, -52
	sw	$s5, 48($sp)
	sw	$t0, 44($sp)
	sw	$t6, 40($sp)
	sw	$t5, 36($sp)
	sw	$s0, 32($sp)
	sw	$s1, 28($sp)
	sw	$t1, 24($sp)
	sw	$t2, 20($sp)
	sw	$t3, 16($sp)
	sw	$t4, 12($sp)
	sw	$t7, 8($sp)
	sw	$t8, 4($sp)
	sw	$t9, 0($sp)

	la	$s0, Library_Opcode			# s0 : address co so Library_Opcode
	la	$s1, OpCode				# s1 : address co so OpCode
	
	add	$t3, $0, $0				# j = 0
read_opcode:
	add	$t4, $s1, $t3				# t4 : address OpCode[j]
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t2, 0($t2)				# t2 = Command[index]
	seq	$t8, $t2, 32				# if Command[index] == ' '
	seq	$t9, $t2, 10				# if Command[index] == '\n'
	seq	$t0, $t2, 9				# if Command[index] == '\tab'
	or	$t8, $t8, $t9				# Command[index] == ' ' or Command[index] == '\n'
	or	$t8, $t8, $t0				# Command[index] == ' ' or Command[index] == '\n' or Command[index] == '\tab'
	bne	$t8, $0, end_read_opcode		# if Command[index] == ' ' or Command[index] == '\n' 
							# or Command[index] == '\tab' ---> end_read_opcode

	sb	$t2, 0($t4)				# OpCode[j] = Command[index]
	
	addi	$t3, $t3, 1				# j += 1
	addi	$s7, $s7, 1				# index += 1
	j	read_opcode			
end_read_opcode:
	sb	$zero, 0($t4)				# OpCode[j] = '\0'
	
	add	$t5, $0, $0				# khoi tao t5 = 0 
	

loop:	
	add	$s5, $s0, $t5				# t5 : address co so Library_Opcode[k] hay address Library_Opcode[k].OpCode[p]	
	lb	$t6, 0($s5)				# t6 = Library_Opcode[k].OpCode[p]
	sle	$t8, $t6,  122				# neu Library_Opcode[k].OpCode[p] <= 'z'
	sge	$t9, $t6, 97				# neu Library_Opcode[k].OpCode[p] >= 'a'
	and	$t7, $t8, $t9				# t7 = 1: if Library_Opcode[k].OpCode[p] thuoc [a,z]
	beq	$t7, $0, end_loop			# Library_Opcode[k].OpCode[p] ko thuoc [a,z] ---> end_loop 
							# hay da duyet het phan tu Library_Opcode
	add	$t3, $0, $0				# khoi tao j = 0
check_opcode:
	add	$t1, $s1, $t3				# t1 : address OpCode[j]
	lb	$t1, 0($t1)				# t1 = OpCode[j]
	lb	$t6, 0($s5)				# t6 = Library_Opcode[k].OpCode[l]
	bne	$t6, 32, L1				# Library_Opcode[k].OpCode[l] != ' ' ---> L1
	beq	$t1, $0, tim_thay			# OpCode[j] == '\0'  ---> return 1 
L1:  	bne	$t1, $t6, end_check_opcode		# OpCode khac nhau ----> duyet tiep List_Opcode
	addi	$t3, $t3, 1				# j += 1
	addi	$s5, $s5, 1				# t5 : address Library_Opcode[k].OpCode[l++]
	j	check_opcode
end_check_opcode:
	addi	$t5, $t5, 17				# t5 : address Library_Opcode[k++].OpCode[0]
	j	loop
end_loop:	
	j	ko_co_opcode				# return 0
tim_thay:
	add	$s6, $s0, $t5				# s6 : luu address opcode tim thay trong Library_Opcode	
	addi	$v0, $0, 1				# return 1	(la opcode)
	j	tra_lai_value_registers
ko_co_opcode:	add	$v0, $0, $0			# return 0	(khong phai opcode)

tra_lai_value_registers:
	lw	$t9, 0($sp)
	lw	$t8, 4($sp)
	lw	$t7, 8($sp)
	lw	$t4, 12($sp)
	lw	$t3, 16($sp)
	lw	$t2, 20($sp)
	lw	$t1, 24($sp)
	lw	$s1, 28($sp)
	lw	$s0, 32($sp)
	lw	$t5, 36($sp)
	lw	$t6, 40($sp)
	lw	$t0, 44($sp)
	lw	$s5, 48($sp)
	addi	$sp, $sp, 52
	
end_check_Opcode:	jr	$ra

######### Procedure checkToanHang #############
#### kiem tra tinh hop le cua toan hang ung voi opcode
###############################################


check_Toan_Hang:
	addi	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$t0, 16($sp)
	sw	$t1, 12($sp)
	sw	$t2, 8($sp)
	sw	$t3, 4($sp)
	sw	$t9, 0($sp)
	
	add	$t9, $0, $0				# so luong toan hang dang check
	addi	$s0, $s6, 11				# s0 : address cua khuon dang Opcode
loop2:	
	beq	$t9, 3, end_loop2			# duyet het toan hang ---> end_loop2
	
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t3, 0($t2)				# t3 = Command[index]
	
	
	lb	$t0, 0($s0)				# t0 : trang thai cua toan hang
switch: 
	addi	$t1, $0, 49				# t1 == '1' theo ascii
	beq	$t0, $t1, thanhghi			# ki tu doc vao la '1' ----> thanhghi
	addi	$t1, $0, 50				# t1 == '2' theo ascii
	beq	$t0, $t1, hangso			# ki tu doc vao la '2' ----> hangso
	addi	$t1, $0, 51				# t1 == '3' theo ascii
	beq	$t0, $t1, label				# ki tu doc vao la '3' ----> label
	addi	$t1, $0, 52				# t1 == '4' theo ascii
	beq	$t0, $t1, thanhghi_diachi		# ki tu doc vao la '4' ----> thanhghi_diachi
	addi	$t1, $0, 45				# t1 == '-' theo ascii
	beq	$t0, $t1, nothing			# ki tu doc vao la '-' ----> nothing
	j	default					# default  --> return 0
thanhghi:
	beq	$t3, 10, false				# gap ky tu '\n' --> chua duyet xong Toan hang --> return 0
	
	beq	$t9, $0, tieptuc_Register
	jal	skipBlack
	nop
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t3, 0($t2)				# t3 = Command[index]
	bne	$t3, 44, false				# khong co dau ',' o truoc thi return 0
	addi	$s7, $s7, 1
	jal	skipBlack
	nop
	tieptuc_Register:
	
	jal	read_Toan_Hang
	nop
	jal	check_register
	nop
	beq	$v0, $0, waning_TH				# token da doc khong phai thanh ghi
	
	j	printf_TH
end_thanhghi:	
hangso:
	beq	$t3, 10, false				# gap ky tu '\n' --> chua duyet xong Toan hang --> return 0
	
	beq	$t9, $0, tieptuc_Number
	jal	skipBlack
	nop
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t3, 0($t2)				# t3 = Command[index]
	bne	$t3, 44, false				# khong co dau ',' o truoc thi return 0
	addi	$s7, $s7, 1
	jal	skipBlack
	nop
	tieptuc_Number:
	
	jal	read_Toan_Hang
	nop
	jal	check_Number
	nop
	bne	$v0, $0, printf_TH				# toan hang da doc la so nguyen -> printf_TH
	jal	check_Hex
	nop
	beq	$v0, $0, waning_TH
	j	printf_TH
end_hangso:
label:
	beq	$t3, 10, false				# gap ky tu '\n' --> chua duyet xong Toan hang --> return 0
	
	beq	$t9, $0, tieptuc_Label
	jal	skipBlack
	nop
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t3, 0($t2)				# t3 = Command[index]
	bne	$t3, 44, false				# khong co dau ',' o truoc thi return 0
	addi	$s7, $s7, 1
	jal	skipBlack
	nop
	tieptuc_Label:
	
	jal	read_Toan_Hang
	nop
	jal	check_Label
	nop
	beq	$v0, $0, waning_TH				# token da doc khong phai so nguyen
	
	j	printf_TH
end_label:
thanhghi_diachi:
	beq	$t3, 10, false				# gap ky tu '\n' --> chua duyet xong Toan hang --> return 0
	
	beq	$t9, $0, tieptuc_Register_Address
	jal	skipBlack
	nop
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t3, 0($t2)				# t3 = Command[index]
	bne	$t3, 40, false				# khong co dau '(' o truoc thi return 0
	addi	$s7, $s7, 1
	jal	skipBlack
	nop
	tieptuc_Register_Address:
	
	jal	read_Toan_Hang
	nop
	jal	check_register
	nop
	beq	$v0, $0, waning_TH				# token da doc khong phai thanh ghi
	
	jal	skipBlack
	nop
	add	$t2, $s2, $s7				# t2 : address Command[index]
	lb	$t3, 0($t2)				# t3 = Command[index]
	bne	$t3, 41, false				# khong co dau ')' o sau thi return 0
	addi	$s7, $s7, 1
	j	printf_TH
end_thanhghi_diachi:

nothing:						# ko co toan hang
	j	end_loop2
end_nothing:

default:
	j	false
end_default:
printf_TH:						# phan in ra thong tin neu toan hang hop le
TH0:	bne	$t9, 0, TH1
	li	$v0, 4
	la	$a0, Message_ToanHang1
	syscall
	la	$a0, ToanHang1
	syscall	
	la	$a0, Message2_Opcode
	syscall
	j	end_printf_TH
TH1:	bne	$t9, 1, TH2
	li	$v0, 4
	la	$a0, Message_ToanHang2
	syscall
	la	$a0, ToanHang2
	syscall	
	la	$a0, Message2_Opcode
	syscall
	j	end_printf_TH
TH2:	bne	$t9, 2, end_printf_TH

	li	$v0, 4
	la	$a0, Message_ToanHang3
	syscall
	la	$a0, ToanHang3
	syscall	
	la	$a0, Message2_Opcode
	syscall
end_printf_TH:
end_switch:
tang:
	addi	$t9, $t9, 1
	addi	$s0, $s0, 1				# duyet tiep cac toan hang tiep theo
	j	loop2
end_loop2:
	j	true					# duyet xong khuon dang lenh --> return 1
waning_TH:
waning_TH1:
	bne	$t9, 0, waning_TH2
	li	$v0, 4
	la	$a0, Message_ToanHang1
	syscall
	la	$a0, ToanHang1
	syscall	
	la	$a0, Waning_Opcode
	syscall
	j	end_waning_TH
waning_TH2:	
	bne	$t9, 1, waning_TH3
	li	$v0, 4
	la	$a0, Message_ToanHang2
	syscall
	la	$a0, ToanHang2
	syscall	
	la	$a0, Waning_Opcode
	syscall
	j	end_waning_TH
waning_TH3:
	bne	$t9, 2, end_waning_TH	
	li	$v0, 4
	la	$a0, Message_ToanHang3
	syscall
	la	$a0, ToanHang3
	syscall	
	la	$a0, Waning_Opcode
	syscall

end_waning_TH:
false:	add	$v0, $0, $0				# return 0   (oh! no.)
	j	return_register
true:	addi	$v0, $0, 1				# return 1   (ok! )
return_register:
	lw	$t9, 0($sp)
	lw	$t3, 4($sp)
	lw	$t2, 8($sp)
	lw	$t1, 12($sp)
	lw	$t0, 16($sp)
	lw	$s1, 20($sp)
	lw	$s0, 24($sp)
	lw	$ra, 28($sp)
	addi	$sp, $sp, 28
end_check_Toan_Hang:
	jr	$ra
###### Procedure   read_Toan_Hang ########
## doc toan hang
#######################

read_Toan_Hang:
	addi	$sp, $sp, -20
	lw	$t0, 16($sp)
	lw	$t2, 12($sp)
	lw	$t3, 8($sp)
	lw	$t4, 4($sp)
	lw	$t5, 0($sp)
			
	bne	$t9, $0, C1				# toan hang thu nhat
	la	$s1, ToanHang1				# s0 = address ToanHang1
	j	gan
	
C1:	bne	$t9, 1, C2				# toan hang thu 2
	la	$s1, ToanHang2				# s0 = address ToanHang2
	j	gan
	
C2:	la	$s1, ToanHang3				# s0 = address ToanHang3
gan:	add	$t2, $s1, $0				# t2 = s0
read_Token:
	add	$t0, $s2, $s7				# t0 : address Command[index]
	lb	$t3, 0($t0)				# t3 = Command[index]
	
	seq	$t4, $t3, 32				# t4 = 1 if Command[index] = ' ' theo ascii
	seq	$t5, $t3, 44				# t5 = 1 if Command[index] = ',' theo ascii
	or	$t4, $t4, $t5				# t4 = 1 if Command[index] = ' ' or Command[index] = ','
	seq	$t5, $t3, 10				# t5 = 1 if Command[index] = '\n' theo ascii
	or	$t4, $t4, $t5				# t4 = 1 if Command[index] = ' ' or Command[index] = ',' or Command[index] = '\n'
	seq	$t5, $t3, 40				# t5 = 1 if Command[index] = '(' theo ascii
	or	$t4, $t4, $t5				# t4 = 1 if Command[index] = ' ' or Command[index] = ',' or Command[index] = '\n'
							# or Command[index] = '('
	seq	$t5, $t3, 41				# t5 = 1 if Command[index] = ')' theo ascii
	or	$t4, $t4, $t5				# t4 = 1 if Command[index] = ' ' or Command[index] = ',' or Command[index] = '\n'
							# or Command[index] = '(' or Command[index] = ')' 
	seq	$t5, $t3, 9				# t5 = 1 if Command[index] = '\tab'
	or	$t4, $t4, $t5				# t4 = 1 if Command[index] == ' ' or Command[index] == ',' or Command[index] == '\n'
							# or Command[index] == '(' or Command[index] == ')' or Command[index] = '\tab'
	seq	$t5, $t3, 35				# t5 = 1 neu Command[index] == '#'
	or	$t4, $t4, $t5				# t4 = 1 neu Command[index] == ' ' or Command[index] == ',' or Command[index] == '\n'
							# or Command[index] == '(' or Command[index] == ')' or Command[index] = '\tab' or Command[index] == '#'
	bne	$t4, $0, end_read_Token			# t5 = 1 ---> end_read_Token
	sb	$t3, 0($t2)				# copy Command[index] ---> address luu o t2
	
	addi	$s7, $s7, 1				# index += 1
	addi	$t2, $t2, 1				# tang address luu o t2 them 1
	j	read_Token
end_read_Token:
	sb	$zero, 0($t2)				# phan tu cuoi cua ToanHang la ki tu '\0'
	
	sw	$t5, 0($sp)
	sw	$t4, 4($sp)
	sw	$t3, 8($sp)
	sw	$t2, 12($sp)
	sw	$t0, 16($sp)
	addi	$sp, $sp, 20
end_read_Toan_Hang:
	jr	$ra

######## Procedure check_register #######
### kiem tra toan hang co phai la mot thanh ghi
##########################################3

check_register:
	addi	$sp, $sp -28
	sw	$t0, 24($sp)
	sw	$t1, 20($sp)
	sw	$t2, 16($sp)
	sw	$t3, 12($sp)
	sw	$t4, 8($sp)
	sw	$t5, 4($sp)
	sw	$t8, 0($sp)

	la	$t8, List_Registers			# t8 : luu dia chi danh sach cac thanh ghi
	add	$t1, $0, $0				# i = 0
lap_compato_register:	
	add	$t2, $t8, $t1				# t2 = t8 : address List_Registers[i]
	add	$t0, $s1, $0				# t0 : address co so cua Toan Hang
	lb	$t3, 0($t2)				# t3 = ki tu dau tien cua phan tu
	sle	$t4, $t3, 122				# t4 = 1  if t3 <= 'z'
	sge	$t5, $t3, 97				# t5 = 1  if t3 >= 'a'
	and	$t4, $t4, $t5				# t4 = 1  neu t3 thuoc [a,z]
	seq	$t5, $t3, 36				# t5 = 1  if t3 == '$'
	or	$t4, $t4, $t5				# t4 = 1  if t3 == '$' or ( t3 >= 'a' and t3 <= 'z')
	beq	$t4, $0, end_lap_compato_register	# thoat vong lap neu t4 = 0  <--> duyet het phan tu trong List_Registers   
compato_register:
	lb	$t3, 0($t2)				# t3 = ki tu dau tien cua phan tu
	lb	$t4, 0($t0)				# t4 = ToanHangX[i]   voi X = 1,2 or 3
	bne	$t3, 32, compato			# khong phai la ky tu ' ' trong ascii ---> compato	
	bne	$t4, $0, end_compato_register		# duyet tiep phan tu trong List_Registers
	j	duoc_nhi1				# return 1
compato:
	bne	$t4, $t3, end_compato_register		# duyet tiep phan tu List_Registers
	addi	$t2, $t2, 1				# duyet tiep ky tu ke tiep cua phan tu trong List_Registers
	addi	$t0, $t0, 1				# t0 = ToanHangX[i++]
	j	compato_register
end_compato_register:
	addi	$t1, $t1, 7				# duyet phan tu tiep theo ( i += 1)
	j	lap_compato_register
end_lap_compato_register:
khong_duoc1:
	add	$v0, $0, $0				# return 0    ( khong phai la mot thanh ghi)
	j	tra_lai_register
duoc_nhi1:
	addi	$v0, $0, 1				#return 1     ( la mot thanh ghi)

tra_lai_register:
	lw	$t8, 0($sp)
	lw	$t5, 4($sp)
	lw	$t4, 8($sp)
	lw	$t3, 12($sp)
	lw	$t2, 16($sp)
	lw	$t1, 20($sp)
	lw	$t0, 24($sp)
	addi	$sp, $sp, 28
end_check_register:
	jr	$ra

######## Procedure check_Number #########
### kiem tra mot toan hang la so nguyen
####################################

check_Number:
	addi	$sp, $sp, -20
	sw	$t0, 16($sp)
	sw	$t1, 12($sp)
	sw	$t2, 8($sp)
	sw	$t3, 4($sp)
	sw	$t4, 0($sp)

	add	$t0, $s1, $0				# t0 : address co so cua Toan Hang
	lb	$t1, 0($t0)				# t1 = ToanHangX[0] voi X = 1, 2 or 3
	beq	$t1, $0, khong_duoc			# xau rong --> return 0
	seq	$t2, $t1, 45				# so sanh ToanHangX[0] voi '-'	
	beq	$t2, $0, loop_CN			# neu ky tu dau ko la '-' ---> loop_CN
	addi	$t0, $t0, 1				# t0 : address ToanHangX[1] 
	lb	$t1, 0($t0)				# t1 = ToanHangX[0] voi X = 1, 2 or 3
	beq	$t1, $0, khong_duoc			# ToanHangX = "-" --> return 0
	
loop_CN:
	lb	$t1, 0($t0)				# t1 = ToanHangX[0] voi X = 1, 2 or 3
	beq	$t1, $0, end_loop_CN			# la ki tu ket thuc xau '\0' --> ket thuc vong lap
	sle	$t3, $t1, 57				# ToanHangX[0] <= '9'
	sge	$t4, $t1, 48				# ToanhangX[0] >= '0'
	and	$t3, $t3, $t4				# '0' <= ToanHangX[0] <= '9' 
	beq	$t3, $0, khong_duoc			# neu khong phai la ki tu so thi return 0
	addi	$t0, $t0, 1				# duyet tiep ky tu tiep theo
	j	loop_CN
end_loop_CN:
duoc_nhi:
	addi	$v0, $0, 1				#return 1     ( la mot so nguyen)
	j	return_register_CN
khong_duoc:
	add	$v0, $0, $0				# return 0    ( khong phai la mot so nguyen)
return_register_CN:
	lw	$t4, 0($sp)
	lw	$t3, 4($sp)
	lw	$t2, 8($sp)
	lw	$t1, 12($sp)
	lw	$t0, 16($sp)
	addi	$sp, $sp, 20

end_check_Number:
	jr	$ra
########### Procedure check_Hex #########
## kiem tra co phai so dang Hex
######################################

check_Hex:
	addi	$sp, $sp, -20
	sw	$t0, 16($sp)
	sw	$t1, 12($sp)
	sw	$t2, 8($sp)
	sw	$t3, 4($sp)
	sw	$t4, 0($sp)
	
	la	$t2, Ky_Tu_Hex				# t2 : address co so Ky_Tu_Hex
	add	$t0, $0, $0				# khoi tao i = 0
	add	$t1, $s1, $t0				# t1 : address ToanHangX[0]  voi X = {1,2,3}
	lb	$t1, 0($t1)				# t1 = ToanHangX[0]
	bne	$t1, 48, return_hex_0			# ToanHangX[0] != '0' -> return 0
	addi	$t0, $t0, 1				# i += 1
	add	$t1, $s1, $t0				# t1 : address ToanHangX[1]  voi X = {1,2,3}
	lb	$t1, 0($t1)				# t1 = ToanHangX[1]
	bne	$t1, 120, return_hex_0			# ToanHangX[0] != 'x' -> return 0
	addi	$t0, $t0, 1				# i += 1
	add	$t1, $s1, $t0				# t1 : address ToanHangX[i]  voi X = {1,2,3}
	lb	$t1, 0($t1)				# t1 = ToanHangX[i]
	beq	$t1, $0, return_hex_0			# da duyet het Toan hang : ToanHangX = "0x" --> return 0
loop_check_hex:
	beq	$t0, 10, end_loop_check_hex		# toi da 10 kt tu ( "0x" va 8 ky tu Hex sau)
	add	$t1, $s1, $t0				# t1 : address ToanHangX[i]  voi X = {1,2,3}
	lb	$t1, 0($t1)				# t1 = ToanHangX[i]
	beq	$t1, $0, return_hex_1			# da duyet het Toan hang : ToanHangX la Hex --> return 1
	add	$t3, $0, $0 				# khoi tao j = 0
	loop_check_KT_Hex:
	add	$t4, $t3, $t2				# t4 : address Ky_Tu_Hex[j]
	lb	$t4, 0($t4)				# t4 = Ky_Tu_Hex[j]
	beq	$t4, 10, return_hex_0			# ToanHangX[i] khong phai HEX -> return 0
	beq	$t4, $t1, end_loop_check_KT_Hex		# ToanHangX[i] == Ky_Tu_Hex[j] --> end_loop_check_KT_Hex
	addi	$t3, $t3, 1				# j += 1
	j	loop_check_KT_Hex
	end_loop_check_KT_Hex:
	addi	$t0, $t0, 1				# i += 1
	j	loop_check_hex
end_loop_check_hex:
	check_TH_Hex:
	add	$t1, $s1, $t0				# t1 : address ToanHangX[10]  voi X = {1,2,3}
	lb	$t1, 0($t1)				# t1 = ToanHangX[10]
	beq	$t1, $0, return_hex_1			# da duyet het Toan hang : ToanHangX la Hex --> return 1
	end_check_TH_Hex:
return_hex_0:
	add	$v0, $0, $0				# return 0
	j	return_TG_hex
return_hex_1:
	addi	$v0 , $0, 1				# return 1	
return_TG_hex:
	lw	$t4, 0($sp)
	lw	$t3, 4($sp)
	lw	$t2, 8($sp)
	lw	$t1, 12($sp)
	lw	$t0, 16($sp)
	addi	$sp, $sp, 20
end_check_Hex:
	jr	$ra

####### Procedure check_Label ##########
### kiem tra nhan hop le
##########################

check_Label:
	addi	$sp, $sp -20
	sw	$t0, 16($sp)
	sw	$t1, 12($sp)
	sw	$t2, 8($sp)
	sw	$t3, 4($sp)
	sw	$t4, 0($sp)

	la	$t0, Ky_Tu_Label			# t0 : address co so Ky_Tu_Label
	add	$t1, $s1, $0				# t1 : address co so ToanHangX
	lb	$t2, 0($t1)				# t2 = ToanHangX[0]
	beq	$t2, $0, return_CL_0			# ToanHangX rong ---> return 0
	add	$t3, $0, $0				# khoi tao i = 0
check_Ky_Tu_Dau:
	add	$t4, $t0, $t3				# t4 : address Ky_Tu_Label[i]
	lb	$t4, 0($t4)				# t4 =  Ky_Tu_Label[i]
	beq	$t4, 48, return_CL_0			# Ky_Tu_Label[i] == '0' --> ky tu dau khong kop le --> return 0
	beq	$t4, $t2, end_check_Ky_Tu_Dau		# ky tu dau hop le --> duyet tiep ky tu sau	
	addi	$t3, $t3, 1				# i += 1
	j	check_Ky_Tu_Dau 
end_check_Ky_Tu_Dau:

	addi	$t1, $t1, 1				# t1 : address ToanHangX[1]
loop_LB:
	lb	$t2, 0($t1)				# t2 = ToanHangX[j]
	beq	$t2, $0, end_loop_LB			# da duyet het ToanHangX : Label hop le --> return 1
	add	$t3, $0, $0				# khoi tao lai i = 0
 check_Ky_Tu:
 	add	$t4, $t0, $t3				# t4 : address Ky_Tu_Label[i]
	lb	$t4, 0($t4)				# t4 =  Ky_Tu_Label[i]
	beq	$t4, 10, return_CL_0			# Ky_Tu_Label[i] == '\n' --> ky tu hien tai ko hople --> return 0
	beq	$t4, $t2, end_check_Ky_Tu		# ky tu hop le --> duyet tiep ky tu sau	
	addi	$t3, $t3, 1				# i += 1
	j	check_Ky_Tu
 end_check_Ky_Tu:
 	addi	$t1, $t1, 1				# t1 : address ToanHangX[j++]
 	j	loop_LB
 end_loop_LB:
 return_Cl_1:
 	addi	$v0, $0, 1				# return 1
 	j	return_register_LB			
return_CL_0:
	add	$v0, $0, $0				# return 0
return_register_LB:
	lw	$t4, 0($sp)
	lw	$t3, 4($sp)
	lw	$t2, 8($sp)
	lw	$t1, 12($sp)
	lw	$t0, 16($sp)
	addi	$sp, $sp, 20
end_check_Label:
	jr	$ra
