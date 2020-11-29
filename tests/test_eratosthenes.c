
#include <stdio.h>
#include <stdint.h>

extern uint64_t *
eratosthenes(uint64_t n, uint64_t *m);

extern void myFree(void *ptr);

int
main()
{
  uint64_t n = 1000;
  uint64_t num;
  uint64_t *arr = eratosthenes(n, &num);

  printf("There are %ld prime numbers between 1 and %ld\n", num, n);

  for (uint64_t i = 0; i < num; i++) {
    if ((i % 6) == 0) {
      printf("\n");
    }

    printf("%*ld ", 5, arr[i]);
  }

  printf("\n");

  myFree(arr);
}
