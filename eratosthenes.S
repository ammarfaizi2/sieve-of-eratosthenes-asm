
/**
 * @author Ammar Faizi <ammarfaizi2@gmail.com>
 */

// #define DEBUG_PRINT

#define SAVE_3_ARGS     \
        pushq %rdi;     \
        pushq %rsi;     \
        pushq %rdx;

#define REST_3_ARGS     \
        popq %rdi;      \
        popq %rsi;      \
        popq %rdx;

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

        movq    %rsi, %r15
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

        movl    $2, %r14d       # uint64_t p = 2; // current smallest prime (p)
        movl    $1, %ecx        # uint64_t i = 1; // counter (i)

        # // r14 = p
        # // rcx = i
        # // Enumerate np, while (ip < i);
        # uint64_t ip;
.traverse_r14:
        incq    %rcx
        movq    %rcx, %rax
        mulq    %r14            # ip = i * p;
        cmpq    %rbx, %rax
        jae     .next_check     # if (ip >= n) goto .next_check

        movb    $1, (%r13, %rax, 1) # table[ip] = true;

#ifdef DEBUG_PRINT
        SAVE_3_ARGS
        leaq    fmt1(%rip), %rdi
        movq    %rax, %rsi
        callq   safe_printf
        REST_3_ARGS
#endif

        jmp     .traverse_r14   # goto .traverse_r14;
.next_check:
        # // Now, find the smallest unmarked.
        movq    %r14, %rcx      # i = p;
.get_smallest_unmarked:
        incq    %rcx            # i++;

        cmpq    %rbx, %rcx
        jae     .all_non_prime_numbers_have_been_marked

        testb   $1, (%r13, %rcx, 1)
        jnz     .get_smallest_unmarked

        # // Smallest unmarked has been found.
        movq    %rcx, %r14      # p = i;
        movq    $1, %rcx
        jmp     .traverse_r14   # goto .traverse_r14;

.all_non_prime_numbers_have_been_marked:
        xorl    %edx, %edx
        movl    $1, %ecx
.fill_the_array:
        incq    %rcx
        cmpq    %rbx, %rcx
        jae     .epilogue
        testb   $1, (%r13, %rcx, 1)
        jz      .do_fill
        jmp     .fill_the_array
.do_fill:
        movq    %rcx, (%r12, %rdx, 8)
        incq    %rdx
        jmp     .fill_the_array
.epilogue:
        movq    %rdx, (%r15)
        movq    %r13, %rdi
        call    myFree

        movq    %r12, %rax
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
        pushfq
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
        popfq
        ret

.data
fmt1:
        .string "Num: %ld\n"

fmt2:
        .string "quo: %ld, rem: %ld\n"
#endif
