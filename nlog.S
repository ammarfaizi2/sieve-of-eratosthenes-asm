
/** 
 * @ref https://t.me/AssemblyID/4653
 */

.text
        .global nlog

nlog:
        pushq   %rbp
        movq    %rsp, %rbp

        pushq   %rdi

        fld     rec_log2e(%rip)
        fild    -8(%rbp)
        fyl2x
        fistp   -8(%rbp)

        popq    %rax

        movq    %rbp, %rsp
        popq    %rbp
        ret

.data
rec_log2e:
        .float  6.93147180e-1
