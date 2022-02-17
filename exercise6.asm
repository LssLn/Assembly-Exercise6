.data
ST: .space 8 ;# char NUM[8] = 8*1
V: .space 64 ;# int V[8] = 8*8
stack: .space 32

msg1: .asciiz "Inserisci una str di soli num\n"
msg2: .asciiz "Inserisci un numero\n"
msg3: .asciiz "Valore : %d\n" ;# val 1° arg msg2 (V[i] = val)

p1sys5: .space 8
val: .space 8 ;# 1° arg msg2

p1sys3: .word 0 ;#fd null
ind: .space 8
dim: .word 8 ;# numbyte da leggere <= ST 

.code
;# init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

    ;#printf msg1
daddi $t0,$0,msg1
sd $t0,p1sys5($0)
daddi r14,$0,p1sys5
syscall 5
    ;# scanf %s ST
daddi $t0,$0,ST
sd $t0,ind($0)
daddi r14,$0,p1sys3
syscall 3
;# salvo strlen non in $a1 ma in $s1 
move $s1,r1         ;# $s1 = strlen (ST)
    ;#    for(int i=0;i<strlen(NUM);i++){
daddi $s0,$0,0 ;# i=0
for:
    ;# $s0 (i) < $s1 (strlen)
    slt $t0,$s0,$s1 ;# $t0=0 quando $s0 (i) >= $s1 (strlen)
    beq $t0,$0,exit ;# exit quando $t0=0

        ;# printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
        ;# scanf %d, &a     a lo uso come $a1 direttamente, lo uso solo come parametro della funzione
    jal InputUnsigned
    move $a1,r1         ;# $a1 = a
        ;# passaggio parametri per confronta: $a1 = a, $a0 ST[i] ; non ST come solito
    daddi $s3,$0,ST     ;# $s3 = ST
    dadd $t0,$s3,$s0 ;# $t0 = &st[i] = st ($s3) + i ($s0)
    lbu $a0,0($t0)      ;# $a0 = st[i]
    jal processa
    ;# tornato dalla funzione, devo assegnare il return a V[i]
    dsll $s4,$s0,3     ;# $s4 = $s0 * 8 (multiplo di 8, int V[i], sarebbe 16 se fosse STR[i])
    sd r1,V($s4)   ;# val = return tmp from processa
    ;# printf msg3 1° arg = val = V[i]
    sd r1,val($0)   ;# non so come mettere V[i] come %d
        ;# printf msg3
    daddi $t0,$0,msg3
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5 

    ;# incremento for
    daddi $s0,$s0,1
    j for
processa:
    ;# char num, int val        $a0=num (st[i]), $a1 = val (int a)
    daddi $sp,$sp,-8 ;# solo tmp da salvare
    sd $s2,0($sp)   ;# tmp
    daddi $s2,$0,0  ;# tmp=0

    ;# if (num<58)
    slti $t0,$a0,58 ;#$t0=0 quando $a0>=58
    beq $t0,$0,else ;# se $t0=0, <58, else (salto if)
    ;# if (<58)
        ;# num-48 = $a0 - 48
        daddi $a0,$a0,-48
        ;# + val = $a1
        dadd $a0,$a0,$a1
        ;# /2
        dsra $s2,$a0,1 ;#divido per 2^1 (shif a dx)
else:
        ;# else (>=58)
        dadd $s2,$0,$a1 ;# tmp ($s2) = val ($a1)
return:
    ;# sia if che else arrivano qui
    move r1,$s2 ;#r1 = $s2 (=tmp)

    ld $s2,0($sp)
    daddi $sp,$sp,8

    jr $ra
exit:
    syscall 0

#include InputUnsigned.s

        
