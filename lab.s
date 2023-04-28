section .data
n:
        db      4
m:
        db      2
arr:
        dd      60, 50 
        dd      40, 30
        dd      20, 10
        dd      5, 3
lines:
        times   32 db 0 ; times x db 0 where x is (8 * n) 24
sums:
        times   16 db 0 ; times x db 0 where x is (4 * n) 12
factor:
;        dd      1055696089, 1072952593
        dt      1.3

section .text
global _start

_start:
        push    rbp
        mov     rbp, rsp
        mov     DWORD [rbp-4], 0
        jmp     .L2
.L3:
        mov     eax, DWORD [rbp-4]
        add     eax, eax
        cdqe
        sal     rax, 2
        lea     rdx, arr[rax]
        mov     eax, DWORD [rbp-4]
        cdqe
        mov     QWORD lines[0+rax*8], rdx
        add     DWORD [rbp-4], 1
.L2:
        ;cmp     DWORD [rbp-4], 2
        mov     eax, DWORD [rbp-4]
        movzx   ebx, BYTE [n]
        dec     ebx
        cmp     eax, ebx

        jle     .L3
        mov     DWORD [rbp-8], 0
        jmp     .L4
.L7:
        mov     DWORD [rbp-12], 0
        jmp     .L5
.L6:
        mov     eax, DWORD [rbp-8]
        cdqe
        mov     edx, DWORD sums[0+rax*4]
        mov     eax, DWORD [rbp-8]
        lea     ecx, [rax+rax]
        mov     eax, DWORD [rbp-12]
        add     eax, ecx
        cdqe
        mov     eax, DWORD arr[0+rax*4]
        add     edx, eax
        mov     eax, DWORD [rbp-8]
        cdqe
        mov     DWORD sums[0+rax*4], edx
        add     DWORD [rbp-12], 1
.L5:
        ;cmp     DWORD [rbp-12], 1
        mov     eax, DWORD [rbp-12]
        movzx   ebx, BYTE [m]
        dec     ebx
        cmp     eax, ebx

        jle     .L6
        add     DWORD [rbp-8], 1
.L4:
        ;cmp     DWORD [rbp-8], 2
        mov     eax, DWORD [rbp-8]
        movzx   ebx, BYTE [n]
        dec     ebx
        cmp     eax, ebx

        jle     .L7
        ;mov     DWORD [rbp-16], 2
        movzx   eax, BYTE [n]
        dec     eax
        mov     DWORD [rbp-16], eax

        jmp     .L8
.L12:
        mov     DWORD [rbp-20], 0
        jmp     .L9
.L11:
        mov     eax, DWORD [rbp-20]
        cdqe
        mov     edx, DWORD sums[0+rax*4]
        mov     ecx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, ecx
        cdqe
        mov     eax, DWORD sums[0+rax*4]
%ifdef DESC
        cmp     eax, edx
%else
        cmp     edx, eax
%endif
        jle     .L10
        mov     eax, DWORD [rbp-20]
        cdqe
        mov     rax, QWORD lines[0+rax*8]
        mov     QWORD [rbp-32], rax
        mov     edx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, edx
        cdqe
        mov     rdx, QWORD lines[0+rax*8]
        mov     eax, DWORD [rbp-20]
        cdqe
        mov     QWORD lines[0+rax*8], rdx
        mov     edx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, edx
        cdqe
        mov     rdx, QWORD [rbp-32]
        mov     QWORD lines[0+rax*8], rdx
        mov     eax, DWORD [rbp-20]
        cdqe
        mov     eax, DWORD sums[0+rax*4]
        mov     DWORD [rbp-36], eax
        mov     edx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, edx
        cdqe
        mov     edx, DWORD sums[0+rax*4]
        mov     eax, DWORD [rbp-20]
        cdqe
        mov     DWORD sums[0+rax*4], edx
        mov     edx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, edx
        cdqe
        mov     edx, DWORD [rbp-36]
        mov     DWORD sums[0+rax*4], edx
.L10:
        add     DWORD [rbp-20], 1
.L9:
        mov     edx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, edx
        ;cmp     eax, 2
        movzx   ebx, BYTE [n]
        dec     ebx
        cmp     eax, ebx

        jle     .L11
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, DWORD [rbp-16]
        movsd   xmm1, QWORD [factor]
        divsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     DWORD [rbp-16], eax
.L8:
        cmp     DWORD [rbp-16], 0
        jg      .L12

        mov     eax, 1
        mov     ebx, 0
        pop     rbp
        int     0x80
