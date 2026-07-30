; MIT License
; Copyright (c) 2026 RedHarlowCore
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

default rel

section .data
    msg_vendor db 'Vendor ID: ', 0
    len_vendor equ $ - msg_vendor

    msg_brand  db 'Processor Name: ', 0
    len_brand  equ $ - msg_brand

    msg_cores  db 'Logical Cores (Threads): ', 0
    len_cores  equ $ - msg_cores

    msg_aes    db 'AES Encryption Support: ', 0
    len_aes    equ $ - msg_aes

    msg_avx    db 'AVX Vector Math Support: ', 0
    len_avx    equ $ - msg_avx

    txt_supported    db 'Supported', 0Dh, 0Ah, 0
    len_supported    equ $ - txt_supported

    txt_unsupported  db 'Not Supported', 0Dh, 0Ah, 0
    len_unsupported  equ $ - txt_unsupported

    newline    db 0Dh, 0Ah, 0  

section .bss
    vendor_id     resb 13
    brand_string  resb 49
    core_count_str resb 4
    bytes_written resq 1       
    stdout_handle resq 1       

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .text
    global main

main:
    sub rsp, 40

    mov ecx, -11                
    call GetStdHandle
    mov [stdout_handle], rax

    mov eax, 0
    cpuid
    mov dword [vendor_id], ebx
    mov dword [vendor_id + 4], edx
    mov dword [vendor_id + 8], ecx
    mov byte  [vendor_id + 12], 0

    mov eax, 0x80000002
    cpuid
    mov dword [brand_string], eax
    mov dword [brand_string + 4], ebx
    mov dword [brand_string + 8], ecx
    mov dword [brand_string + 12], edx

    mov eax, 0x80000003
    cpuid
    mov dword [brand_string + 16], eax
    mov dword [brand_string + 20], ebx
    mov dword [brand_string + 24], ecx
    mov dword [brand_string + 28], edx

    mov eax, 0x80000004
    cpuid
    mov dword [brand_string + 32], eax
    mov dword [brand_string + 36], ebx
    mov dword [brand_string + 40], ecx
    mov dword [brand_string + 44], edx
    mov byte  [brand_string + 48], 0

    mov rcx, [stdout_handle]
    lea rdx, [msg_vendor]
    mov r8d, len_vendor
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [vendor_id]
    mov r8d, 12
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [newline]
    mov r8d, 2
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [msg_brand]
    mov r8d, len_brand
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [brand_string]
    mov r8d, 48
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [newline]
    mov r8d, 2
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov eax, 1
    cpuid
    
    mov r12d, ecx
    mov r13d, edx

    shr ebx, 16
    and ebx, 0xFF
    
    mov eax, ebx
    lea rdi, [core_count_str]
    call int_to_string

    mov rcx, [stdout_handle]
    lea rdx, [msg_cores]
    mov r8d, len_cores
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [core_count_str]
    mov r8d, 3
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [msg_aes]
    mov r8d, len_aes
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    bt r12d, 25
    jc .aes_ok
    lea rdx, [txt_unsupported]
    mov r8d, len_unsupported
    jmp .print_aes
.aes_ok:
    lea rdx, [txt_supported]
    mov r8d, len_supported
.print_aes:
    mov rcx, [stdout_handle]
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov rcx, [stdout_handle]
    lea rdx, [msg_avx]
    mov r8d, len_avx
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    bt r12d, 28
    jc .avx_ok
    lea rdx, [txt_unsupported]
    mov r8d, len_unsupported
    jmp .print_avx
.avx_ok:
    lea rdx, [txt_supported]
    mov r8d, len_supported
.print_avx:
    mov rcx, [stdout_handle]
    lea r9, [bytes_written]
    mov qword [rsp + 32], 0
    call WriteFile

    mov ecx, 0                  
    call ExitProcess

int_to_string:
    push rax
    push rbx
    push rcx
    push rdx
    
    mov ecx, 10
    mov ebx, 0
    
.loop1:
    xor edx, edx
    div ecx
    add edx, '0'
    push rdx
    inc ebx
    test eax, eax
    jnz .loop1

.loop2:
    pop rdx
    mov [rdi], dl
    inc rdi
    dec ebx
    jnz .loop2
    
    mov byte [rdi], 0Dh
    mov byte [rdi+1], 0Ah
    mov byte [rdi+2], 0
    
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
