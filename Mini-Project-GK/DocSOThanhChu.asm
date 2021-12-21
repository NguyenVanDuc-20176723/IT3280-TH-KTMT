
#      Ho va ten : Do Duc Thuan
#      MSSV      : 20176884


##################### De Bai ####################
# Dau vao la cac so tu 0 - 999 999 999. In ra cach doc 
#################################################

#################### Huong giai quyet #############
# B1 : kiem tra dau vao
# B2 : chia so dau vao cho 1,000,000. Tach phan du va phan thuong. Neu phan thuong != 0 , tiep tuc chia 100 va chia 10 de lay phan tu
#      cua hang triu. Neu phan thuong == 0 chuyen sang buoc 3.
# B3 : lay phan du cua buoc 2 chia 1000. Tach phan du va phan thuong. Neu phan thuong != 0 , tiep tuc chia 100 va chia 10 de lay phan tu
#      cua hang nghin. Neu phan thuong == 0 chuyen sang buoc 4
# B4 : Lay phan du cua buoc 3 chia cho 100 va 10  
# Note : Sau khi doc duoc 1 chu so ta them vi tri tuong ung cua so do voi " trieu, nghin, tram, muoi" vao sau

###################################################
# bai lam gom co 1 ham main va 5 thu tuc ( trong do co cac thu tuc con)

.data 
list: .space 128          # Du tru 128 byte duoc chi dinh tiep theo o Data segment
nhapvao: .asciiz "Ban hay nhap vao mot so nguyen [0;999 999 999]: " 
new: .asciiz "\n" 

linh: .asciiz "linh "                 #gan 1 xau ki tu cho nhan
khong0: .asciiz "khong "              # gan "khong" cho nhan khong0
mot1: .asciiz "mot "                  # gan "mot" cho nhan mot1
hai2: .asciiz "hai "                  # gan "hai" cho nhan hai2
ba3: .asciiz "ba "                    #gan "ba" cho nhan ba3
bon4: .asciiz "bon "                  #gan "bon" cho nhan bon4
nam5: .asciiz "nam "                  #gan "nam " cho nhan nam5
sau6: .asciiz "sau "                  #gan "sau " cho nhan sau6
bay7: .asciiz "bay "                  #gan "bay " cho nhan bay7
tam8: .asciiz "tam "                  #gan "tam " cho nhan tam8
chin9: .asciiz "chin "                #gan "chin " cho nhan chin9
muoi10: .asciiz "muoi "               #gan "muoi " cho nhan muoi10
muoimot11: .asciiz "muoi mot "        #gan "muoi mot " cho nhan muoimot11
muoihai12: .asciiz "muoi hai "        #gan "muoi hai " cho nhan muoihai12
muoiba13: .asciiz "muoi ba "          #gan "muoi ba " cho nhan muoiba13
muoibon14: .asciiz "muoi bon "         #gan "muoi bon " cho nhan muoibon14
muoinam15: .asciiz "muoi nam "        #gan "muoi nam " cho nhan muoinam15
muoisau16: .asciiz "muoi sau "        #gan "muoi sau " cho nhan muoisau16
muoibay17: .asciiz "muoi bay "        #gan "muoi bay " cho nhan muoibay17
muoitam18: .asciiz "muoi tam "        #gan "muoi tam " cho nhan muoitam18
muoichin19: .asciiz "muoi chin "      #gan "muoi chin " cho nhan muoichin19
tram100: .asciiz "tram "              #gan "tram" cho nhan tram
nghin: .asciiz "nghin "               #gan "nghin" cho nhan nghin
trieu: .asciiz "trieu "               #gan "trieu" cho nhan trieu

str_number: .asciiz "dang so: "

new_line: .asciiz "\ndang chu: "
warning_input: .asciiz "du lieu nhap khong hop le!\n"
.text
######################################
#main
 
######################################
main:
    
 input:
  #messgae input
  la $a0, nhapvao                #load address into $a0
#  li $v0, 4                      #call to print string
 # syscall
  # input integer
  li $v0, 51                      #read integer
  syscall                        # thuc hien
  beq $a1, -3, warning
  beq $a1, -1, warning
  move $s0, $a0                  #inter stored in $s0 $t0 isn't saved registry , copy value $v0 -> $s0
  #check input
  blt $s0, $zero, warning 	 #if s0 < 0 then warning
  ble $s0, 999999999, end_warning      # if s0 <= 999999999 then end_warning
warning:
  la $a0, warning_input
  li $a1, 2
  li $v0, 55
  syscall
  j input
end_warning:
  la $a0, str_number
  li $v0, 4
  syscall

  add $a0, $s0, $0
  li $v0, 1
  syscall
  
  la $a0, new_line
  li $v0, 4
  syscall
  
  bne $s0, $0, xuly              # if $s0 != 0 then xuly
  jal convert0to19               # if $s0 = 0 then convert0to19
  j exit                         # thoat
 xuly:

  jal chiamottrieu              # thuc hien produce chiamottrieu   

  jal chiamotnghin              # thuc hien produce chiamotnghin

  jal chiamottram               # thuc hien produce chiamottram

 
 exit:
  li $v0, 10                   # option exit (terminate execution)
  syscall                      #thuc hien
 end_main:
  
  # end main      
                    
 ##################################################
 #procedure convert0to19
 #doc so tu 0 den 19 sang tieng viet
 ##################################################    
convert0to19 :                 #convert0to19: dan den duong linh tuong ung cua tung so
 addi $sp , $sp, -4            # create stack 
  sw  $ra, 0($sp)	       # cat du lieu vao stack
switch:
 khong:
  bne $s0,0,mot                  # if $s0 != 0 then lable mot
  li $v0, 4                     # goi toi print string
  la $a0, khong0                # gan addr label khong0 -> $a0
  syscall                      # thuc hien lenh tren
  j end_switch                 # ket thuc switch
 mot:
  bne $s0,1,hai
  li $v0, 4  
  la $a0, mot1
  syscall
  j end_switch
 hai:
  bne $s0,2,ba
  li $v0, 4  
  la $a0, hai2
  syscall
  j end_switch 
 ba:
  bne $s0,3,bon
  li $v0, 4  
  la $a0, ba3
  syscall
  j end_switch
 bon:
  bne $s0,4,nam
  li $v0, 4  
  la $a0, bon4
  syscall
  j end_switch
 nam: 
  bne $s0,5,sau
  li $v0, 4  
  la $a0, nam5
  syscall 
  j end_switch
 sau:
  bne $s0,6,bay
  li $v0, 4  
  la $a0, sau6
  syscall
  j end_switch
 bay: 
  bne $s0,7,tam
  li $v0, 4  
  la $a0, bay7
  syscall
  j end_switch
 tam:
  bne $s0,8,chin
  li $v0, 4  
  la $a0, tam8
  syscall
  j end_switch
 chin:
  bne $s0,9,muoi
  li $v0, 4  
  la $a0, chin9
  syscall
  j end_switch
 muoi:
  bne $s0,10,muoimot
  li $v0, 4  
  la $a0, muoi10
  syscall
  j end_switch
 muoimot:
  bne $s0,11,muoihai
  li $v0, 4  
  la $a0, muoimot11
  syscall
  j end_switch
 muoihai:
  bne $s0,12,muoiba
  li $v0, 4  
  la $a0, muoihai12
  syscall
  j end_switch
 muoiba:
  bne $s0,13,muoibon
  li $v0, 4  
  la $a0, muoiba13
  syscall
  j end_switch
 muoibon:
  bne $s0,14,muoinam
  li $v0, 4  
  la $a0, muoibon14
  syscall
  j end_switch
 muoinam:
  bne $s0,15,muoisau
  li $v0, 4  
  la $a0, muoinam15
  syscall
  j end_switch
 muoisau:
  bne $s0,16,muoibay
  li $v0, 4  
  la $a0, muoisau16
  syscall
  j end_switch
 muoibay:
  bne $s0,17,muoitam
  li $v0, 4  
  la $a0, muoibay17
  syscall
  j end_switch
 muoitam:
  bne $s0,18,muoichin
  li $v0, 4  
  la $a0, muoitam18
  syscall
  j end_switch
 muoichin:
  bne $s0,19,end_switch
  li $v0, 4  
  la $a0, muoichin19
  syscall

end_switch:                      # ket thuc switch
  
end_convert0to19:                # ket thuc produce convert0to19
 
 lw $ra, 0($sp)                  
 addi $sp, $sp, 4                # nhay $sp len 4 byte
 jr $ra                          # back thu tuc goi produce hien tai ( produce convert0to19)
###    end convert0to19


###########################################
#PRODUCE chiamottrieu
# doc he so truoc hang 1 trieu
##########################################
 
chiamottrieu:
    addi $sp , $sp, -4                     # create stack
    sw  $ra, 0($sp)                        # doc du lieu vao stack
            
    li $t1,1000000	                 # gan t1 = 1000000     
    div $s0,$t1                            #s0 chia 1.000.000
    mflo $s0                               # s0 = s0 /1.000.000
    mfhi $s1                               # s1 = S1 %1.000.000
    beq $s0, $0, end_chiamottrieu          # if $s0 == 0 -> khong co so hang trieu - > end_chiamottrieu 
    
    jal chiamottram                        # tro den produce chiamottram
    
    li $v0, 4                              # call to print string
    la $a0, trieu                          # print " trieu"
    syscall                                # thuc hien
end_chiamottrieu:                        # ket thuc chiamottrieu
    add $s0,$s1,$zero                      # s0 = S0 %1.000.000 , gan phan du cho $s0
 
    lw $ra, 0($sp)                         # lay du lieu tu stack vao $ra
    addi $sp, $sp, 4                       # cho stack xuong        
    jr $ra
######################
#end produce chiamottrieu
###################### 
  
 
  
################################ 
# PRODUCE chiamotnghin
# doc he so hang nghin
###############################
chiamotnghin:
    addi $sp , $sp, -4
    sw  $ra, 0($sp)                         # cat du lieu thanh ghi $ra vao stack pointer
  
    beq $s0,$zero,end_chiamotnghin          # if $s0==0 -> khong co so hang nghin -> end_chiamotnghin
    li $t1,1000                             # gan $t1 = 1000
    div $s0,$t1                             #s0 chia 1000
    mflo $s0                                # s0 = s0 /1000
    mfhi $s1                                # s1 = s1 %1000
    beq $s0,$zero,end_chiamotnghin          # if $s0 = 0 -> end_chiamotnghin
    jal chiamottram                         # nhay den produce chiamottram
  
  
    li $v0, 4                               # call to print string
    la $a0, nghin                           # print " nghin"
    syscall                                 # thuc hien
end_chiamotnghin:                        # ket thuc produce chiamotnghin
    add $s0,$s1,$zero                       # gan phan du cho $s0
  

    lw $ra, 0($sp)                           #luu $sp vao $ra
    addi $sp, $sp, 4
    jr $ra

##############################
#end produce chiamotnghin
##############################


############################# 
## PRODUCE chiamottram
# doc so o hang tram 
#############################
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
chiamottram:
    addi $sp , $sp, -4                          #create stack
    sw  $ra, 0($sp)
  
    beq $s0,$zero,end_chiamottram               # if $s0 = 0 -> end_chiamottram                  
 
    li $t1,100                                  # gan $t1 = 100    
    div $s0,$t1                                 #s0 chia 100
    mflo $s0                                    # s0 = s0 /100 ( phan thuong )
    mfhi $s7                                    # $s7 = phan du
    beq $s0, $0, lbl_lbl_chiamuoi               # if $s0 = 0 -> lbl_lbl_chiamuoi
    jal convert0to19                            # doc so
 
  
  
    li $v0, 4                                  # call to print string
    la $a0, tram100                            # print "string"
    syscall                                    # thuc hien
  
  
    add $s0, $s7, $0                           # gan phan du cho $s0
    beq $s0, $0, end_chiamottram               # if $s0 = 0 -> end_chiamottram
  
    slti $t1,$s0,10                            # 2lenh : if s0 < 10 then xuatlinh
    beq  $t1,1,xuatlinh                        # if $t1=1 -> xuat linh vd 101 : mot tram linh mot ( <>mot tram mot)
 lbl_lbl_chiamuoi:
    mfhi $s0                                   # s0 = S0 %100
    beq $s0,$zero,end_chiamottram              # phan du bang 0 -> end_chiamottram
    jal chiamuoi                               # nhay den produce chiamuoi
    j end_chiamottram                          # ket thuc produce chiamottram
  # in ra " linh" vd: 101 - mot tram linh mot
  xuatlinh:
      li $v0, 4                              #call to print string
      la $a0, linh                           #print "linh"
      syscall 
 zero_ok:
    jal convert0to19                          # doc so
end_chiamottram:
   lw $ra, 0($sp)                         # lay du lieu tu stack pointer vao $ra
   addi $sp, $sp, 4
   jr $ra                                 
 
#########################
#end produce chiamottram
#########################


#########################
#  PROCDUCE chiamuoi
#  doc ra hang chuc
#########################
  
chiamuoi:
    addi $sp, $sp, -4                        # create stack
    sw $ra, 0($sp) 
    bge $s0, 20, duyet                       #if $s0 > 20 ->  product duyet                     
    jal convert0to19                         # doc so
    j end_chiamuoi                           #ket thuc chiamuoi
# thuc hien neu $s0 > 20
duyet:
    li $t1,10                                # gan $t1 = 10
    div $s0,$t1                              # $s0 chia 10
    mflo $s0                                 # gan $s0 = thuong
    beq $s0, $0, continue_chiamuoi           # if $s0 = 0 -> continue_chiamuoi
    jal convert0to19                         # doc
    li $v0, 4                                # call to print string
    la $a0, muoi10                           # print "muoi"
    syscall
 continue_chiamuoi:
    mfhi $s0                                 # gan phan du cho $s0
    beq $s0,$zero,end_chiamuoi               # if $s0 = 0 ->end_chimuoi
    jal convert0to19                         # doc
end_chiamuoi:                              # ket thuc produce chiamuoi
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra
########################
# end produce chiamuoi
########################

  
