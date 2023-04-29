section .data
rows_qty equ    4
columns_qty equ 2

n:
        db      rows_qty
m:
        db      columns_qty
arr:
        db      60, 50 
        db      40, 30
        db      20, 10
        db      5, 3
lines:
        times   rows_qty*8 db 0
sums:
        times   rows_qty db 0
factor:
        dq      1.3

section .text
global _start
_start:
        push    rbp
        mov     rbp, rsp
        mov     BYTE [rbp-1], 0
        jmp     .L2
.L3:
        movzx   rax, BYTE [m]           ;
        movzx   rbx, BYTE [rbp-1]       ;
        imul    rbx                     ;
        lea     rdx, arr[rax]           ;
        mov     QWORD lines[rbx*8], rdx ;
        inc     BYTE [rbp-1]            ;lines[i] = &arr[i*m]
.L2:
        mov     al, BYTE [rbp-1]        ;
        cmp     al, BYTE [n]            ;
        jl      .L3                     ;check i < n

        mov     BYTE [rbp-2], 0
        jmp     .L4
.L7:
        mov     BYTE [rbp-3], 0
        jmp     .L5
.L6:
        movzx   rax, BYTE [m]           ;
        movzx   rbx, BYTE [rbp-2]       ;
        imul    rbx                     ;
        movzx   rcx, BYTE [rbp-3]       ;
        mov     dl, BYTE arr[rax+rcx]   ;
        add     BYTE sums[rbx], dl      ;
        inc     BYTE [rbp-3]            ;sums[i] += arr[i*m + j]
.L5:
        mov     al, BYTE [rbp-3]        ;
        cmp     al, BYTE [m]            ;
        jl      .L6                     ;check j < m

        inc     BYTE [rbp-2]
.L4:
        mov     al, BYTE [rbp-2]        ;
        cmp     al, BYTE [n]            ;
        jl     .L7                      ;check i < n
       
        mov     al, BYTE [n]            ;
        dec     al                      ;
        mov     BYTE [rbp-4], al        ;initalizing step with value of n - 1

        jmp     .L8
.L12:
        mov     BYTE [rbp-5], 0
        jmp     .L9
.L11:
        mov     cl, BYTE sums[rax]      ;sums[i]

%ifdef DESC                             ;check (desc)
        cmp     BYTE sums[rbx], cl      ;sums[i+step] < sums[i]
%else                                   ;check (asc)
        cmp     cl, BYTE sums[rbx]      ;sums[i] < sums[i+step]
%endif                                  ;
        jle     .L10                    ;

        mov     rcx, QWORD lines[rax*8] ;
        xchg    rcx, QWORD lines[rbx*8] ;
        mov     QWORD lines[rax*8], rcx ;swap lines[i], lines[i+step]      

        mov     cl, BYTE sums[rax]      ;
        xchg    cl, BYTE sums[rbx]      ;
        mov     BYTE sums[rax], cl      ;swap sums[i], sums[i+step]

.L10:                                   
        inc     BYTE [rbp-5]
.L9:
        movzx   rax, BYTE [rbp-5]       ;rax = i
        movzx   rbx, BYTE [rbp-4]       ;
        add     rbx, rax                ;rbx = i + step
        cmp     bl, BYTE [n]            ;
        jl     .L11                     ;check i+step<n
                                        
        movzx   edx, BYTE [rbp-4]       ;
        pxor    xmm0, xmm0              ;
        cvtsi2sd xmm0, edx              ;
        movsd   xmm1, QWORD [factor]    ;
        divsd   xmm0, xmm1              ;
        cvttsd2si edx, xmm0             ;
        mov     BYTE [rbp-4], dl        ;divide step by factor
.L8:
        cmp     BYTE [rbp-4], 0         ;
        jg      .L12                    ;check step >= 1

        mov     eax, 1
        mov     ebx, 0
        pop     rbp
        int     0x80
