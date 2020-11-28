
#include <stdio.h>
#include <assert.h>
#include <stdint.h>

extern void *myMalloc(size_t);
extern void *myCalloc(size_t, size_t);
extern void myFree(void *);

#define TEST_MEM(MEM, LENGTH)               \
  __asm__ volatile(                         \
    "movq     %[mem], %%rdx     \n\t"       \
    "xorl     %%ecx, %%ecx      \n\t"       \
    "pxor     %%xmm0, %%xmm0    \n\t"       \
    "1:                         \n\t"       \
    "movdqa   %%xmm0,  (%%rdx)  \n\t"       \
    "addq     $16, %%rcx        \n\t"       \
    "addq     $16, %%rdx        \n\t"       \
    "cmpq     %[len], %%rcx     \n\t"       \
    "jl       1b                \n\t"       \
    : [mem]"+r"(MEM)                        \
    : [len]"g"(LENGTH)                      \
    : "rcx", "rdx", "xmm0", "cc", "memory"  \
  )

void __attribute__((noinline))
test_mem(void *mem, size_t len)
{
  assert((((uintptr_t)mem) % 16) == 0);
  TEST_MEM(mem, len);
}

void
test_my_allocator()
{
  void *mem1, *mem2;

  for (size_t i = 0; i < 1000; i++) {
    mem1 = myMalloc(1024);
    mem2 = myMalloc(2048);
    test_mem(mem1, 1024);
    test_mem(mem2, 2048);
    myFree(mem1);
    myFree(mem2);
  }

  for (size_t i = 0; i < 1000; i++) {
    mem1 = myMalloc(1024);
    test_mem(mem1, 1024);

    mem2 = myMalloc(2048);
    test_mem(mem2, 2048);

    myFree(mem1);
    myFree(mem2);
  }

  for (size_t i = 0; i < 1000; i++) {
    mem1 = myCalloc(2, 512);
    mem2 = myCalloc(4, 512);
    test_mem(mem1, 1024);
    test_mem(mem2, 2048);
    myFree(mem1);
    myFree(mem2);
  }

  for (size_t i = 0; i < 1000; i++) {
    mem1 = myCalloc(2, 512);
    test_mem(mem1, 1024);

    mem2 = myCalloc(4, 512);
    test_mem(mem2, 2048);

    myFree(mem1);
    myFree(mem2);
  }
}

int
main()
{
  test_my_allocator();
}
