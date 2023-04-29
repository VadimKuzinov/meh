     1                                  section .data
     2                                  rows_qty equ    4
     3                                  columns_qty equ 2
     4                                  
     5                                  n:
     6 00000000 04                              db      rows_qty
     7                                  m:
     8 00000001 02                              db      columns_qty
     9                                  arr:
    10 00000002 3C32                            db      60, 50 
    11 00000004 281E                            db      40, 30
    12 00000006 140A                            db      20, 10
    13 00000008 0503                            db      5, 3
    14                                  lines:
    15 0000000A 00<rep 20h>                     times   rows_qty*8 db 0
    16                                  sums:
    17 0000002A 00<rep 4h>                      times   rows_qty db 0
    18                                  factor:
    19 0000002E CDCCCCCCCCCCF43F                dq      1.3
    20                                  
    21                                  section .text
    22                                  global _start
    23                                  _start:
    24 00000000 55                              push    rbp
    25 00000001 4889E5                          mov     rbp, rsp
    26 00000004 C645FF00                        mov     BYTE [rbp-1], 0
    27 00000008 EB24                            jmp     .L2
    28                                  .L3:
    29 0000000A 480FB60425-                     movzx   rax, BYTE [m]
    29 0000000F [01000000]         
    30 00000013 480FB65DFF                      movzx   rbx, BYTE [rbp-1]
    31 00000018 48F7EB                          imul    rbx
    32 0000001B 488D90[02000000]                lea     rdx, arr[rax]
    33 00000022 488914DD[0A000000]              mov     QWORD lines[rbx*8], rdx
    34 0000002A 8045FF01                        add     BYTE [rbp-1], 1
    35                                  .L2:
    36 0000002E 8A45FF                          mov     al, BYTE [rbp-1]
    37 00000031 3A0425[00000000]                cmp     al, BYTE [n]
    38                                  
    39 00000038 7CD0                            jl      .L3
    40 0000003A C645FE00                        mov     BYTE [rbp-2], 0
    41 0000003E EB4D                            jmp     .L4
    42                                  .L7:
    43 00000040 C645FD00                        mov     BYTE [rbp-3], 0
    44 00000044 EB37                            jmp     .L5
    45                                  .L6:
    46 00000046 8A45FE                          mov     al, BYTE [rbp-2]        ;
    47 00000049 4898                            cdqe                            ;
    48 0000004B 8A90[2A000000]                  mov     dl, BYTE sums[rax]      ;
    49 00000051 8A45FE                          mov     al, BYTE [rbp-2]        ;
    50                                                                          ;
    51 00000054 8A1C25[01000000]                mov     bl, BYTE [m]            ;
    52 0000005B F6EB                            imul    bl                      ;
    53 0000005D 88C1                            mov     cl, al                  ;
    54 0000005F 8A45FD                          mov     al, BYTE [rbp-3]        ;
    55 00000062 00C8                            add     al, cl                  ;
    56 00000064 4898                            cdqe                            ;
    57 00000066 8A80[02000000]                  mov     al, BYTE arr[rax]       ;
    58 0000006C 00C2                            add     dl, al                  ;
    59 0000006E 8A45FE                          mov     al, BYTE [rbp-2]        ;
    60 00000071 4898                            cdqe                            ;
    61 00000073 8890[2A000000]                  mov     BYTE sums[rax], dl      ;
    62 00000079 8045FD01                        add     BYTE [rbp-3], 1         ;sums[i] += arr[i*m + j]
    63                                  .L5:
    64 0000007D 8A45FD                          mov     al, BYTE [rbp-3]
    65 00000080 3A0425[01000000]                cmp     al, BYTE [m]
    66                                  
    67 00000087 7CBD                            jl      .L6
    68 00000089 8045FE01                        add     BYTE [rbp-2], 1
    69                                  .L4:
    70 0000008D 8A45FE                          mov     al, BYTE [rbp-2]
    71 00000090 3A0425[00000000]                cmp     al, BYTE [n]
    72                                  
    73 00000097 7CA7                            jl     .L7                 
    74 00000099 8A0425[00000000]                mov     al, BYTE [n]            ;
    75 000000A0 FEC8                            dec     al                      ;
    76 000000A2 8845FC                          mov     BYTE [rbp-4], al        ;initalizing step with value of n - 1
    77                                  
    78 000000A5 E985000000                      jmp     .L8
    79                                  .L12:
    80 000000AA C645FB00                        mov     BYTE [rbp-5], 0
    81 000000AE EB49                            jmp     .L9
    82                                  .L11:
    83 000000B0 8A88[2A000000]                  mov     cl, BYTE sums[rax]      ;sums[i]
    84                                  
    85                                  %ifdef DESC                             ;check (desc)
    86                                          cmp     BYTE sums[rbx], cl      ;sums[i+step] < sums[i]
    87                                  %else                                   ;check (asc)
    88 000000B6 3A8B[2A000000]                  cmp     cl, BYTE sums[rbx]      ;sums[i] < sums[i+step]
    89                                  %endif                                  ;
    90 000000BC 7E37                            jle     .L10                    ;
    91                                  
    92 000000BE 480FB645FB                      movzx   rax, BYTE [rbp-5]       ;rax = i 
    93 000000C3 480FB65DFC                      movzx   rbx, BYTE [rbp-4]       ;    
    94 000000C8 4801C3                          add     rbx, rax                ;rbx = i + step
    95                                                                          
    96 000000CB 488B0CC5[0A000000]              mov     rcx, QWORD lines[rax*8] ;
    97 000000D3 48870CDD[0A000000]              xchg    rcx, QWORD lines[rbx*8] ;
    98 000000DB 48890CC5[0A000000]              mov     QWORD lines[rax*8], rcx ;swap lines[i], lines[i+step]      
    99                                  
   100 000000E3 8A88[2A000000]                  mov     cl, BYTE sums[rax]      ;
   101 000000E9 868B[2A000000]                  xchg    cl, BYTE sums[rbx]      ;
   102 000000EF 8888[2A000000]                  mov     BYTE sums[rax], cl      ;swap sums[i], sums[i+step]
   103                                  
   104                                  .L10:                                   
   105 000000F5 8045FB01                        add     BYTE [rbp-5], 1         
   106                                  .L9:;!!!!!
   107 000000F9 480FB645FB                      movzx   rax, BYTE [rbp-5]       ;rax = i
   108 000000FE 480FB65DFC                      movzx   rbx, BYTE [rbp-4]       ;
   109 00000103 4801C3                          add     rbx, rax                ;rbx = i + step
   110 00000106 3A1C25[00000000]                cmp     bl, BYTE [n]            ;
   111 0000010D 7CA1                            jl     .L11                     ;check i+step<n
   112                                                                          
   113 0000010F 0FB655FC                        movzx   edx, BYTE [rbp-4]       ;
   114 00000113 660FEFC0                        pxor    xmm0, xmm0              ;
   115 00000117 F20F2AC2                        cvtsi2sd xmm0, edx              ;
   116 0000011B F20F100C25-                     movsd   xmm1, QWORD [factor]    ;
   116 00000120 [2E000000]         
   117 00000124 F20F5EC1                        divsd   xmm0, xmm1              ;
   118 00000128 F20F2CD0                        cvttsd2si edx, xmm0             ;
   119 0000012C 8855FC                          mov     BYTE [rbp-4], dl        ;divide step by factor
   120                                  .L8:
   121 0000012F 807DFC00                        cmp     BYTE [rbp-4], 0         ;
   122 00000133 0F8F71FFFFFF                    jg      .L12                    ;check step >= 1
   123                                  
   124 00000139 B801000000                      mov     eax, 1
   125 0000013E BB00000000                      mov     ebx, 0
   126 00000143 5D                              pop     rbp
   127 00000144 CD80                            int     0x80
