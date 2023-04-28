section .data
rows_qty equ        4
columns_qty equ     2

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
        mov     al, BYTE [rbp-1]        ;
                                        ;
        mov     bl, BYTE [m]            ;
        imul    bl                      ;
        cdqe                            ;
        lea     rdx, arr[rax]           ;
        mov     al, BYTE [rbp-1]        ;
        cdqe                            ;
        mov     QWORD lines[rax*8], rdx ;
        add     BYTE [rbp-1], 1         ;lines[i] = &arr[i*m]
.L2:
        mov     al, BYTE [rbp-1]
        cmp     al, BYTE [n]

        jl      .L3
        mov     BYTE [rbp-2], 0
        jmp     .L4
.L7:
        mov     BYTE [rbp-3], 0
        jmp     .L5
.L6:
        mov     al, BYTE [rbp-2]        ;
        cdqe                            ;
        mov     dl, BYTE sums[rax]      ;
        mov     al, BYTE [rbp-2]        ;
                                        ;
        mov     bl, BYTE [m]            ;
        imul    bl                      ;
        mov     cl, al                  ;
        mov     al, BYTE [rbp-3]        ;
        add     al, cl                  ;
        cdqe                            ;
        mov     al, BYTE arr[rax]       ;
        add     dl, al                  ;
        mov     al, BYTE [rbp-2]        ;
        cdqe                            ;
        mov     BYTE sums[rax], dl      ;
        add     BYTE [rbp-3], 1         ;sums[i] += arr[i*m + j]
.L5:
        mov     al, BYTE [rbp-3]
        cmp     al, BYTE [m]

        jl      .L6
        add     BYTE [rbp-2], 1
.L4:
        mov     al, BYTE [rbp-2]
        cmp     al, BYTE [n]

        jl     .L7                 
        mov     al, BYTE [n]            ;
        dec     al                      ;
        mov     BYTE [rbp-4], al        ;initalizing step with value of n - 1

        jmp     .L8
.L12:
        mov     BYTE [rbp-5], 0
        jmp     .L9
.L11:
        mov     al, BYTE [rbp-5]        ;
        cdqe                            ;
        mov     dl, BYTE sums[rax]      ;
        mov     cl, BYTE [rbp-5]        ;
        mov     al, BYTE [rbp-4]        ;
        add     al, cl                  ;
        cdqe                            ;
        mov     al, BYTE sums[rax]      ;
%ifdef DESC                             ;check (desc)
        cmp     al, dl                  ;sums[i] < sums[i + step]
%else                                   ;check (asc)
        cmp     dl, al                  ;sums[i + step] < sums[i]
%endif                                  ;
        jle     .L10                    ;

        mov     al, BYTE [rbp-5]        ;
        cdqe                            ;
        mov     rax, QWORD lines[rax*8] ;
        mov     QWORD [rbp-31], rax     ;
                                        ;
        xor     rax, rax                ;
        xor     rdx, rdx                ;
        mov     dl, BYTE [rbp-5]        ;
        mov     al, BYTE [rbp-4]        ;
        add     al, dl                  ;
                                        ;
        cdqe                            ;
        mov     rdx, QWORD lines[rax*8] ;
        mov     al, BYTE [rbp-5]        ;
        cdqe                            ;
        mov     QWORD lines[rax*8], rdx ;
        mov     dl, BYTE [rbp-5]        ;
        mov     al, BYTE [rbp-4]        ;
        add     al, dl                  ;
        cdqe                            ;
        mov     rdx, QWORD [rbp-31]     ;
        mov     QWORD lines[rax*8], rdx ;swap lines[i], lines[i + step]

        mov     al, BYTE [rbp-5]        ;
        cdqe                            ;
        mov     al, BYTE sums[rax]      ;
        mov     BYTE [rbp-36], al       ;
        mov     dl, BYTE [rbp-5]        ;
        mov     al, BYTE [rbp-4]        ;
        add     al, dl                  ;
        cdqe                            ;
        mov     dl, BYTE sums[rax]      ;
        mov     al, BYTE [rbp-5]        ;
        cdqe                            ;
        mov     BYTE sums[rax], dl      ;
        mov     dl, BYTE [rbp-5]        ;
        mov     al, BYTE [rbp-4]        ;
        add     al, dl                  ;
        cdqe                            ;
        mov     dl, BYTE [rbp-36]       ;
        mov     BYTE sums[rax], dl      ;swap sums[i], sums[i + step]
.L10:                                   
        add     BYTE [rbp-5], 1         
.L9:                                    
        mov     dl, BYTE [rbp-5]        ;
        mov     al, BYTE [rbp-4]        ;
        add     al, dl                  ;
        cmp     al, BYTE [n]            ;
                                        ;
        jl     .L11                     ;check i + step < n
                                        
        movzx   eax, BYTE [rbp-4]       ;
                                        ;
        pxor    xmm0, xmm0              ;
        cvtsi2sd xmm0, eax              ;
        movsd   xmm1, QWORD [factor]    ;
        divsd   xmm0, xmm1              ;
        cvttsd2si eax, xmm0             ;
        mov     BYTE [rbp-4], al        ;divide step by factor
.L8:
        cmp     BYTE [rbp-4], 0         ;
        jg      .L12                    ;check step >= 1

        mov     eax, 1
        mov     ebx, 0
        pop     rbp
        int     0x80
