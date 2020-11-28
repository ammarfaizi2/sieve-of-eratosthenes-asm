
/** 
 * @ref https://t.me/AssemblyID/4653
 */

.text
        .global nlog

nlog:
        push    %rbp
        mov     %rsp, %rbp

        push    %rdi

        fld     rec_log2e(%rip)
        fild    -8(%rbp)
        fyl2x
        fistp   -8(%rbp)

        pop     %rax

        mov     %rbp, %rsp
        pop     %rbp
        ret

.data
rec_log2e:
        .float  6.93147180e-1

