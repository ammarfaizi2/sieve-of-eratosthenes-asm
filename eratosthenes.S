
/**
 * @author Ammar Faizi <ammarfaizi2@gmail.com>
 */

.text
        .global eratosthenes
        .extern myCalloc
        .extern ln
        

# unsigned int *eratosthenes(unsigned int n);
eratosthenes:
        pushq   %rbp
        pushq   %rbx
        pushq   %r12
        pushq   %r13

        call    nlog


        popq    %r13
        popq    %r12
        popq    %rbx
        popq    %rbp
        ret
