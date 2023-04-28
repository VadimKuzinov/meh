     1                                  section .data
     2                                  n:
     3 00000000 04                              db      4
     4                                  m:
     5 00000001 02                              db      2
     6                                  arr:
     7 00000002 3C00000032000000                dd      60, 50 
     8 0000000A 280000001E000000                dd      40, 30
     9 00000012 140000000A000000                dd      20, 10
    10 0000001A 0500000003000000                dd      5, 3
    11                                  lines:
    12 00000022 00<rep 20h>                     times   32 db 0 ; times x db 0 where x is (8 * n) 24
    13                                  sums:
    14 00000042 00<rep 10h>                     times   16 db 0 ; times x db 0 where x is (4 * n) 12
    15                                  factor:
    16                                  ;        dd      1055696089, 1072952593
    17 00000052 66666666666666A6FF-             dt      1.3
    17 0000005B 3F                 
    18                                  
    19                                  section .text
    20                                  global _start
    21                                  
    22                                  _start:
    23 00000000 55                              push    rbp
    24 00000001 4889E5                          mov     rbp, rsp
    25 00000004 C745FC00000000                  mov     DWORD [rbp-4], 0
    26 0000000B EB23                            jmp     .L2
    27                                  .L3:
    28 0000000D 8B45FC                          mov     eax, DWORD [rbp-4]
    29 00000010 01C0                            add     eax, eax
    30 00000012 4898                            cdqe
    31 00000014 48C1E002                        sal     rax, 2
    32 00000018 488D90[02000000]                lea     rdx, arr[rax]
    33 0000001F 8B45FC                          mov     eax, DWORD [rbp-4]
    34 00000022 4898                            cdqe
    35 00000024 488914C5[22000000]              mov     QWORD lines[0+rax*8], rdx
    36 0000002C 8345FC01                        add     DWORD [rbp-4], 1
    37                                  .L2:
    38                                          ;cmp     DWORD [rbp-4], 2
    39 00000030 8B45FC                          mov     eax, DWORD [rbp-4]
    40 00000033 0FB61C25[00000000]              movzx   ebx, BYTE [n]
    41 0000003B FFCB                            dec     ebx
    42 0000003D 39D8                            cmp     eax, ebx
    43                                  
    44 0000003F 7ECC                            jle     .L3
    45 00000041 C745F800000000                  mov     DWORD [rbp-8], 0
    46 00000048 EB50                            jmp     .L4
    47                                  .L7:
    48 0000004A C745F400000000                  mov     DWORD [rbp-12], 0
    49 00000051 EB32                            jmp     .L5
    50                                  .L6:
    51 00000053 8B45F8                          mov     eax, DWORD [rbp-8]
    52 00000056 4898                            cdqe
    53 00000058 8B1485[42000000]                mov     edx, DWORD sums[0+rax*4]
    54 0000005F 8B45F8                          mov     eax, DWORD [rbp-8]
    55 00000062 8D0C00                          lea     ecx, [rax+rax]
    56 00000065 8B45F4                          mov     eax, DWORD [rbp-12]
    57 00000068 01C8                            add     eax, ecx
    58 0000006A 4898                            cdqe
    59 0000006C 8B0485[02000000]                mov     eax, DWORD arr[0+rax*4]
    60 00000073 01C2                            add     edx, eax
    61 00000075 8B45F8                          mov     eax, DWORD [rbp-8]
    62 00000078 4898                            cdqe
    63 0000007A 891485[42000000]                mov     DWORD sums[0+rax*4], edx
    64 00000081 8345F401                        add     DWORD [rbp-12], 1
    65                                  .L5:
    66                                          ;cmp     DWORD [rbp-12], 1
    67 00000085 8B45F4                          mov     eax, DWORD [rbp-12]
    68 00000088 0FB61C25[01000000]              movzx   ebx, BYTE [m]
    69 00000090 FFCB                            dec     ebx
    70 00000092 39D8                            cmp     eax, ebx
    71                                  
    72 00000094 7EBD                            jle     .L6
    73 00000096 8345F801                        add     DWORD [rbp-8], 1
    74                                  .L4:
    75                                          ;cmp     DWORD [rbp-8], 2
    76 0000009A 8B45F8                          mov     eax, DWORD [rbp-8]
    77 0000009D 0FB61C25[00000000]              movzx   ebx, BYTE [n]
    78 000000A5 FFCB                            dec     ebx
    79 000000A7 39D8                            cmp     eax, ebx
    80                                  
    81 000000A9 7E9F                            jle     .L7
    82                                          ;mov     DWORD [rbp-16], 2
    83 000000AB 0FB60425[00000000]              movzx   eax, BYTE [n]
    84 000000B3 FFC8                            dec     eax
    85 000000B5 8945F0                          mov     DWORD [rbp-16], eax
    86                                  
    87 000000B8 E9F2000000                      jmp     .L8
    88                                  .L12:
    89 000000BD C745EC00000000                  mov     DWORD [rbp-20], 0
    90 000000C4 E9AF000000                      jmp     .L9
    91                                  .L11:
    92 000000C9 8B45EC                          mov     eax, DWORD [rbp-20]
    93 000000CC 4898                            cdqe
    94 000000CE 8B1485[42000000]                mov     edx, DWORD sums[0+rax*4]
    95 000000D5 8B4DEC                          mov     ecx, DWORD [rbp-20]
    96 000000D8 8B45F0                          mov     eax, DWORD [rbp-16]
    97 000000DB 01C8                            add     eax, ecx
    98 000000DD 4898                            cdqe
    99 000000DF 8B0485[42000000]                mov     eax, DWORD sums[0+rax*4]
   100                                  %ifdef DESC
   101                                          cmp     eax, edx
   102                                  %else
   103 000000E6 39C2                            cmp     edx, eax
   104                                  %endif
   105 000000E8 0F8E86000000                    jle     .L10
   106 000000EE 8B45EC                          mov     eax, DWORD [rbp-20]
   107 000000F1 4898                            cdqe
   108 000000F3 488B04C5[22000000]              mov     rax, QWORD lines[0+rax*8]
   109 000000FB 488945E0                        mov     QWORD [rbp-32], rax
   110 000000FF 8B55EC                          mov     edx, DWORD [rbp-20]
   111 00000102 8B45F0                          mov     eax, DWORD [rbp-16]
   112 00000105 01D0                            add     eax, edx
   113 00000107 4898                            cdqe
   114 00000109 488B14C5[22000000]              mov     rdx, QWORD lines[0+rax*8]
   115 00000111 8B45EC                          mov     eax, DWORD [rbp-20]
   116 00000114 4898                            cdqe
   117 00000116 488914C5[22000000]              mov     QWORD lines[0+rax*8], rdx
   118 0000011E 8B55EC                          mov     edx, DWORD [rbp-20]
   119 00000121 8B45F0                          mov     eax, DWORD [rbp-16]
   120 00000124 01D0                            add     eax, edx
   121 00000126 4898                            cdqe
   122 00000128 488B55E0                        mov     rdx, QWORD [rbp-32]
   123 0000012C 488914C5[22000000]              mov     QWORD lines[0+rax*8], rdx
   124 00000134 8B45EC                          mov     eax, DWORD [rbp-20]
   125 00000137 4898                            cdqe
   126 00000139 8B0485[42000000]                mov     eax, DWORD sums[0+rax*4]
   127 00000140 8945DC                          mov     DWORD [rbp-36], eax
   128 00000143 8B55EC                          mov     edx, DWORD [rbp-20]
   129 00000146 8B45F0                          mov     eax, DWORD [rbp-16]
   130 00000149 01D0                            add     eax, edx
   131 0000014B 4898                            cdqe
   132 0000014D 8B1485[42000000]                mov     edx, DWORD sums[0+rax*4]
   133 00000154 8B45EC                          mov     eax, DWORD [rbp-20]
   134 00000157 4898                            cdqe
   135 00000159 891485[42000000]                mov     DWORD sums[0+rax*4], edx
   136 00000160 8B55EC                          mov     edx, DWORD [rbp-20]
   137 00000163 8B45F0                          mov     eax, DWORD [rbp-16]
   138 00000166 01D0                            add     eax, edx
   139 00000168 4898                            cdqe
   140 0000016A 8B55DC                          mov     edx, DWORD [rbp-36]
   141 0000016D 891485[42000000]                mov     DWORD sums[0+rax*4], edx
   142                                  .L10:
   143 00000174 8345EC01                        add     DWORD [rbp-20], 1
   144                                  .L9:
   145 00000178 8B55EC                          mov     edx, DWORD [rbp-20]
   146 0000017B 8B45F0                          mov     eax, DWORD [rbp-16]
   147 0000017E 01D0                            add     eax, edx
   148                                          ;cmp     eax, 2
   149 00000180 0FB61C25[00000000]              movzx   ebx, BYTE [n]
   150 00000188 FFCB                            dec     ebx
   151 0000018A 39D8                            cmp     eax, ebx
   152                                  
   153 0000018C 0F8E37FFFFFF                    jle     .L11
   154 00000192 660FEFC0                        pxor    xmm0, xmm0
   155 00000196 F20F2A45F0                      cvtsi2sd        xmm0, DWORD [rbp-16]
   156 0000019B F20F100C25-                     movsd   xmm1, QWORD [factor]
   156 000001A0 [52000000]         
   157 000001A4 F20F5EC1                        divsd   xmm0, xmm1
   158 000001A8 F20F2CC0                        cvttsd2si       eax, xmm0
   159 000001AC 8945F0                          mov     DWORD [rbp-16], eax
   160                                  .L8:
   161 000001AF 837DF000                        cmp     DWORD [rbp-16], 0
   162 000001B3 0F8F04FFFFFF                    jg      .L12
   163                                  
   164 000001B9 B801000000                      mov     eax, 1
   165 000001BE BB00000000                      mov     ebx, 0
   166 000001C3 5D                              pop     rbp
   167 000001C4 CD80                            int     0x80
