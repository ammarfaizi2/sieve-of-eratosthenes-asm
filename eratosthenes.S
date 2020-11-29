
/**
 * @author Ammar Faizi <ammarfaizi2@gmail.com>
 */

#define DEBUG_PRINT

.text
        .global eratosthenes

        .extern myCalloc        # void *myCalloc(size_t nmemb, size_t size);
        .extern nlog            # int nlog(int n);
#ifdef DEBUG_PRINT
        .extern printf          # // debugging purpose...
#endif
 
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
        xorl    %eax, %eax
        cmpq    $2, %rdi
        jb      .ret
        pushq   %rbp
        pushq   %rbx
        pushq   %r12
        pushq   %r13
        pushq   %r14
        pushq   %r15

        movq    %rsp, %rbp
        subq    $8, %rsp

        movq    %rdi, %rbx      # // rbx = n
        callq   nlog            # // rax = ln(n)
        movq    %rax, %rdi
        subq    $2, %rdi        # // rdi = ln(n) - 2
        xorl    %edx, %edx
        movq    %rbx, %rax      # // rax = n
        divq    %rdi            # // rax = n / (ln(n) - 2)

        movq    %rax, %rdi
        movl    $8, %esi
                                # uint64_t *array;
        callq   myCalloc        # array = (uint64_t *)myCalloc(rax, sizeof(uint64_t));
        movq    %rax, %r12

        movq    %rbx, %rdi
        movl    $1, %esi
                                # bool *table;
        call    myCalloc        # table = (bool *)myCalloc(n, sizeof(bool));
        movq    %rax, %r13

        movl    $2, %ecx        # uint64_t rcx = 2; // counter (p)
        movl    %ecx, %r14d     # uint64_t r14 = 2; // current smallest prime (sp)

        xorl    %r15d, %r15d    # // r15  = 0 (array index counter)

.traverse_prime_p:

        ## Check whether %r14 is prime number or not.
        movl    $2, %r9d        # uint64_t r9 = 2;

        cmpq    %r14, %r9       # while (r9 < r14) {
        jae     .next_check     
.check_prime:
        movq    %r14, %rax
        xorl    %edx, %edx
        div     %r9
#ifdef DEBUG_PRINT
        leaq    fmt2(%rip), %rdi
        movq    %rax, %rsi
        callq   safe_printf
#endif
        testq   %rdx, %rdx      #   if ((r14 % r9) == 0) {
        jz      .is_not_prime   #     goto .is_not_prime;
        incq    %r9             #   }

        cmpq    %r14, %r9       #   if (r9 >= r14) {
        jb      .check_prime    #     break; // r14 is a prime number.
                                #   }
                                # } // end of while (r9 > r14)
.is_prime:
        jmp     .next_check
.is_not_prime:


.next_check:
#ifdef DEBUG_PRINT
        leaq    fmt1(%rip), %rdi
        movq    %r14, %rsi
        callq   safe_printf
#endif

        

        incq    %r14
        cmpq    %rbx, %r14
        jb      .traverse_prime_p
.epilogue:
        movq    %rbp, %rsp

        popq    %r15
        popq    %r14
        popq    %r13
        popq    %r12
        popq    %rbx
        popq    %rbp
.ret:
        ret

#ifdef DEBUG_PRINT
.text
/* Only safe for 3 arguments (max). */
/* rdi, rsi, rdx */
safe_printf:
        pushq   %rax
        pushq   %rcx
        pushq   %r8
        pushq   %r9
        pushq   %r10
        pushq   %r11
        pushq   %rbp

        movq    %rsp, %rbp
        andq    $-16, %rsp
        xorl    %eax, %eax
        callq   printf
        movq    %rbp, %rsp

        popq    %rbp
        popq    %r11
        popq    %r10
        popq    %r9
        popq    %r8
        popq    %rcx
        popq    %rax
        ret

.data
fmt1:
        .string "Num: %ld\n"

fmt2:
        .string "quo: %ld, rem: %ld\n"
#endif
