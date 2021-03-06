
CC        = gcc
CLFAGS    = -fPIC -fpic -no-pie -Wall -Wextra -ggdb3 -Og
VALGRIND  = valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes
BIN_FILES = tests/bin/test_my_allocator tests/bin/test_eratosthenes



all: $(BIN_FILES)

test: do_test_my_allocator do_test_eratosthenes


clean:
	find -name '*.o' | xargs rm -vf
	rm -vf $(BIN_FILES)

tests/test_eratosthenes.o: tests/test_eratosthenes.c
	$(CC) $(CLFAGS) -c tests/test_eratosthenes.c -o $(@)


####### nlog #######
nlog.o: nlog.S
	$(CC) $(CLFAGS) -c nlog.S -o $(@)
####################


####### eratosthenes #######
eratosthenes.o: eratosthenes.S
	$(CC) $(CLFAGS) -c eratosthenes.S -o $(@)
############################


####### my_allocator #######
my_allocator.o: my_allocator.S
	$(CC) $(CLFAGS) -c my_allocator.S -o $(@)
############################


######## Test allocator ########
tests/bin/test_my_allocator: tests/test_my_allocator.o my_allocator.o
	$(CC) $(CLFAGS) tests/test_my_allocator.o my_allocator.o -o $(@)

tests/test_my_allocator.o: tests/test_my_allocator.c
	$(CC) $(CLFAGS) -c tests/test_my_allocator.c -o $(@)

do_test_my_allocator: tests/bin/test_my_allocator
	@echo "------------------------------"
	@echo "------- Test allocator -------"
	@echo "------------------------------"
	$(VALGRIND) tests/bin/test_my_allocator
################################


######## Test eratosthenes ########
tests/bin/test_eratosthenes: tests/test_eratosthenes.o eratosthenes.o my_allocator.o nlog.o
	$(CC) $(CLFAGS) tests/test_eratosthenes.o eratosthenes.o my_allocator.o nlog.o -o $(@)

do_test_eratosthenes: tests/bin/test_eratosthenes
	@echo "---------------------------------"
	@echo "------- Test eratosthenes -------"
	@echo "---------------------------------"
	$(VALGRIND) tests/bin/test_eratosthenes
###################################
