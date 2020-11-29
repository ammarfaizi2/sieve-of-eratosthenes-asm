
#include <stdio.h>
#include <stdint.h>

extern uint64_t *
eratosthenes(uint64_t n, uint64_t *m);

extern void myFree(void *ptr);

int
main()
{
  uint64_t n = 121;
  uint64_t num;
  uint64_t *arr = eratosthenes(n, &num);

  printf("Number of prime numbers between 1 and %ld = %d\n", n, num);
  for (uint16_t i = 0; i < num; i++) {
    printf("%*ld ", 5, arr[i]);
    if ((i % 4) == 0) {
      printf("\n");
    }
  }

  printf("\n");

  myFree(arr);
}
