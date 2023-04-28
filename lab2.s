section .data
arr:
        dd      60, 50, 40, 30, 20, 10
lines:
        times   24 db 0
sums:
        times   12 db 0
factor:
        dd      1055696089, 1072952593

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
        cmp     DWORD [rbp-4], 2
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
        cmp     DWORD [rbp-12], 1
        jle     .L6
        add     DWORD [rbp-8], 1
.L4:
        cmp     DWORD [rbp-8], 2
        jle     .L7
        mov     DWORD [rbp-16], 2
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
        cmp     edx, eax
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
.L10:
        add     DWORD [rbp-20], 1
.L9:
        mov     edx, DWORD [rbp-20]
        mov     eax, DWORD [rbp-16]
        add     eax, edx
        cmp     eax, 2
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
        mov     eax, 0
        pop     rbp
        ret
