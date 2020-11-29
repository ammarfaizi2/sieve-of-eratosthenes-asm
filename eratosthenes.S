
/**
 * @author Ammar Faizi <ammarfaizi2@gmail.com>
 */

.text
        .global eratosthenes
        .extern myCalloc        # void *myCalloc(size_t nmemb, size_t size);
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
        cmpl    $2, %edi                # if (n <= 2)
        jbe     .ret_null               #   goto .ret_null;

        pushq   %rbx
        pushq   %r12
        pushq   %r13
        pushq   %r14

        movq    %rdi, %rbx
        movq    %rsi, %r12

        movl    $8, %esi
        callq   myCalloc                # uint64_t *arr;
        movq    %rax, %r13              # arr = (uint64_t *)myCalloc(n, sizeof(uint64_t));

        movq    %rbx, %rdi
        movl    $1, %esi
        callq   myCalloc                # bool *table;
        movq    %rax, %r14              # table = (bool *)myMalloc(n, sizeof(bool));

        movl    $2, %edi                # uint64_t p = 2;
        movl    $1, %ecx                # uint64_t i = 1;

.traverse_p:
        incq    %rcx
        movq    %rcx, %rax
        mulq    %rdi                    # uint64_t ip = i * p;
        cmpq    %rbx, %rax              # if (ip >= n)
        jae     .next_check             #   goto .next_check;

        movb    $1, (%r14, %rax, 1)     # table[i] = true;
        jmp     .traverse_p             # goto .traverse_p;

.next_check:
        movq    %rdi, %rcx              # uint64_t smallest_idx = p;

        # // Find the next smallest index of table which is false.
.table_check_smallest:
        incq    %rcx                    # smallest_idx++;

        cmpq    %rbx, %rcx              # if (smallest_idx >= n)
        jae     .mark_finished          #   goto .mark_finished;

        testb   $1, (%r14, %rcx, 1)     # if (!table[smallest_idx])
        jz      .got_next_smallest_idx  #   goto .got_next_smallest_idx

        jmp     .table_check_smallest   # goto .table_check_smallest

.got_next_smallest_idx:
        movq    %rcx, %rdi              # p = i;
        movl    $2, %ecx                # i = 2;
        jmp     .traverse_p             # goto .traverse_p

.mark_finished:
        xorl    %esi, %esi              # uint64_t c = 0;
        movl    $1, %ecx                # i = 1;
.fill_array:
        incq    %rcx                    # i++;

        cmpq    %rbx, %rcx              # if (rcx >= n)
        jae     .epilogue               #   goto .epilogue;

        testb   $1, (%r14, %rcx, 1)     # if (!table[i])
        jz      .do_fill                #   goto .do_fill;

        jmp     .fill_array             # goto .fill_array;
.do_fill:
        movq    %rcx, (%r13, %rsi, 8)   # arr[c] = i;
        incq    %rsi                    # c++;
        jmp     .fill_array             # goto .fill_array;

.epilogue:
        movq    %rsi, (%r12)            # *m = c;
        movq    %r14, %rdi
        callq   myFree                  # myFree(table);

        movq    %r13, %rax              # return arr;
        popq    %r14
        popq    %r13
        popq    %r12
        popq    %rbx
        ret

.ret_null:
        xorl    %eax, %eax
        movq    %rax, (%rsi)            # *m = 0;
        ret                             # return NULL;
