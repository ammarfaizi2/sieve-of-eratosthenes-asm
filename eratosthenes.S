
/**
 * @author Ammar Faizi <ammarfaizi2@gmail.com>
 */

.text
        .global eratosthenes

        .extern myCalloc        # void *myCalloc(size_t nmemb, size_t size);
        .extern nlog            # int nlog(int n);
 
/**
 * @param uint64_t n        Last number to be traversed.
 * @param uint64_t *m       The number of prime number between 1 and n.
 * @return uint64_t *       Array of prime numbers between 1 and n.
 *
 * The caller is responsible to call myFree(array), where array is the
 * return value of this function.
 */
# uint64_t *eratosthenes(uint64_t n, uint64_t *m);
eratosthenes:
        cmpq    $2, %rdi
        jb      .ret_null
        pushq   %rbp
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        movq    %rsp, %rbp

        movq    %rdi, %rbx      # // rbx = n
        call    nlog            # // rax = ln(n)
        movq    %rax, %rdi
        subq    $2, %rdi        # // rdi = ln(n) - 2
        xorl    %edx, %edx
        movq    %rbx, %rax      # // rax = n
        divq    %rdi            # // rax = n / (ln(n) - 2)

        movq    %rax, %rdi
        movl    $8, %esi
                                # uint64_t *array;
        call    myCalloc        # array = (uint64_t *)myCalloc(rax, sizeof(uint64_t));
        movq    %rax, %r12

        movq    %rbx, %rdi
        movl    $1, %esi
                                # bool *table;
        call    myCalloc        # table = (bool *)myCalloc(n, sizeof(bool));
        movq    %rax, %r13

        movl    $2, %ecx        # // rcx = 2 first prime (p)
        movl    %ecx, %ebp      # // rbp = 2 current smallest prime (sp)
                                # uint64_t p = 2, sp = 2;

.traverse_prime:

        cmpq    %rcx, %rbx
        jb      .traverse_prime
.epilogue:
        movq    %rbp, %rsp
        popq    %r13
        popq    %r12
        popq    %rbx
        popq    %rbp
.ret:
        ret

.ret_null:
        xorl    %eax, %eax
        ret
