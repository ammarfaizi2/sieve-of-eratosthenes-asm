
CC       = gcc
CLFAGS   = -Wall -Wextra -ggdb3 -Og
VALGRIND = valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes


BIN_FILES = main
main: main.o eratosthenes.o my_allocator.o
	$(CC) $(CLFAGS) main.o eratosthenes.o my_allocator.o -o $(@)

main.o: main.c
	$(CC) $(CLFAGS) -c main.c -o $(@)

eratosthenes.o: eratosthenes.S
	$(CC) $(CLFAGS) -c eratosthenes.S -o $(@)

####### my_allocator #######
my_allocator.o: my_allocator.S
	$(CC) $(CLFAGS) -c my_allocator.S -o $(@)
############################


######## Test allocator ########
BIN_FILES += tests/bin/test_my_allocator
tests/bin/test_my_allocator: tests/test_my_allocator.o my_allocator.o
	$(CC) $(CLFAGS) tests/test_my_allocator.o my_allocator.o -o $(@)

tests/test_my_allocator.o: tests/test_my_allocator.c
	$(CC) $(CLFAGS) -c tests/test_my_allocator.c -o $(@)

test_my_allocator: tests/bin/test_my_allocator
	$(VALGRIND) tests/bin/test_my_allocator
################################

all: main

test: test_my_allocator

clean:
	find -name '*.o' | xargs rm -vf
	rm -vf $(BIN_FILES)
