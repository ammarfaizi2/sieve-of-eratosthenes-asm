
#include <stdio.h>
#include <stdint.h>

extern uint64_t *
eratosthenes(uint64_t n, uint64_t *m);

extern void myFree(void *ptr);

void __attribute__((noinline))
my_test(uint64_t n)
{
  uint64_t num = 0;
  uint64_t *arr = eratosthenes(n, &num);
  printf("There are %ld prime numbers between 1 and %ld\n", num, n);
  /*for (uint64_t i = 0; i < num; i++) {
    if ((i % 6) == 0) {
      printf("\n");
    }
    printf("%*ld ", 10, arr[i]);
  }
  printf("\n\n");*/
  myFree(arr);
}

int
main()
{
  my_test(5);
  my_test(10);
  my_test(100);
  my_test(1000);
  my_test(10000);
  my_test(100000);
  my_test(1000000);
  my_test(10000000);
}
