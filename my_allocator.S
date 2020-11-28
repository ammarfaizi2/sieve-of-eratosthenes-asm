
/**
 * @author Ammar Faizi <ammarfaizi2@gmail.com>
 */

.text
        .global myMalloc
        .global myCalloc
        .global myFree

# void *myMalloc(size_t);
myMalloc:
        addq    $16+15, %rdi    # // Add 16 to store mapped memory and length.
                                # // Add 15 to handle 16-byte aligned.
        pushq   %rdi            # // Save the length.
        movl    $9, %eax        # // eax = 9 (sys_mmap)
        movq    %rdi, %rsi      # size_t length = rdi;
        xorl    %edi, %edi      # int    addr   = NULL;
        movl    $0b011, %edx    # int    prot   = PROT_READ | PROT_WRITE;
        movl    $34, %r10d      # int    flags  = MAP_PRIVATE | MAP_ANONYMOUS;
        movl    $-1, %r8d       # int    fd     = -1;
        xorl    %r9d, %r9d      # off_t  offset = 0;

        # void *mmap(void *addr, size_t length, int prot, int flags,
        #            int fd, off_t offset);
        syscall
        movq    %rax, %rsi      # // Save the mapped memory start address.
        popq    %rdi            # // Get the length.

        # Make it be 16-byte aligned.
        addq    $16+15, %rax    # // rax += 16 + 15
        andq    $-16, %rax      # // rax &= ~0x0f

        movq    %rdi, -8(%rax)  # // Save the length.
        movq    %rsi, -16(%rax) # // Save the mapped memory start address.

        # // Now, rax is guaranteed to be 16-byte aligned
        # // and is usable memory.
        ret

# void myFree(void *);
myFree:
        movq    %rdi, %rdx
        movq    -8(%rdx), %rsi  # // The length of mapped memory.
        movq    -16(%rdx), %rdi # // The mapped memory start address.
        movl    $11, %eax       # // eax = 11 (sys_munmap)

        # int munmap(void *addr, size_t length);
        syscall
        ret


# void *myCalloc(size_t, size_t);
myCalloc:
        pushq   %rbx
        movq    %rdi, %rax
        mulq    %rsi
        movq    %rax, %rdi
        movq    %rdi, %rbx
        call    myMalloc

        movq    %rax, %rdi
        movq    %rbx, %rcx
        movq    %rdi, %rbx
        cld
        xor     %eax, %eax
        rep     stosb         # // It is like memset(%rdi, %eax, %rcx);

        movq    %rbx, %rax
        pop     %rbx
        ret
