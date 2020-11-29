
#include <stdio.h>
#include <stdint.h>

extern uint64_t *
eratosthenes(uint64_t n, uint64_t *m);

extern void myFree(void *ptr);

#define MY_TEST(N)                                                      \
do {                                                                    \
  uint64_t n = (N);                                                     \
  uint64_t num;                                                         \
  uint64_t *arr = eratosthenes(n, &num);                                \
                                                                        \
  printf("There are %ld prime numbers between 1 and %ld\n", num, n);    \
                                                                        \
  for (uint64_t i = 0; i < num; i++) {                                  \
    if ((i % 6) == 0) {                                                 \
      printf("\n");                                                     \
    }                                                                   \
    printf("%*ld ", 10, arr[i]);                                        \
  }                                                                     \
  printf("\n\n");                                                       \
  myFree(arr);                                                          \
} while (0)


int
main()
{
  MY_TEST(5);
  MY_TEST(10);
  MY_TEST(100);
  MY_TEST(1000);
  MY_TEST(10000);
  MY_TEST(100000);
  MY_TEST(1000000);
  MY_TEST(10000000);
}
