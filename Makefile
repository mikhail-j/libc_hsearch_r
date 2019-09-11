# SPDX-License-Identifier: GPL-2.0

CC=gcc
CFLAGS=-std=c99 -O2
OS_SHARED_LIBRARY_FLAGS=

ifeq ($(OS),Windows_NT)
	SHARED_LIB_EXT = .dll 
else
	OS_NAME := $(shell uname -s)
	ifeq ($(OS_NAME),Darwin)
		SHARED_LIB_EXT = .dylib
		OS_SHARED_LIBRARY_FLAGS = -dynamiclib
	else
		SHARED_LIB_EXT = .so
	endif
endif


.PHONY: test lib clean

default: lib

test:
	@if [ "$(shell $(CC) $(CFLAGS) -o test/test_hsearch_r ./search_hsearch_r.c ./test/test_hsearch_r.c && echo $$?)" = "0" ]; then \
		echo "Test #1 (without dynamic library linkage): compiled successfully!"; \
	else \
		echo "Test #1 (without dynamic library linkage): failed to compile!"; \
		exit 1; \
	fi;
	@if [ "$(shell $(CC) $(CFLAGS) -o test/test_hsearch_r_shared ./test/test_hsearch_r.c -L./ -l hsearch_r && echo $$?)" = "0" ]; then \
		echo "Test #2 (with dynamic library linkage): compiled successfully!"; \
	else \
		echo "Test #2 (with dynamic library linkage): failed to compile!"; \
		exit 1; \
	fi;

	@if [ "$$(test/test_hsearch_r | echo $$?)" = "0" ]; then \
		echo "Test #3: found no issues when executing test #1"; \
	else \
		echo "Test #3: encountered unexpected issue when executing test #1"; \
		exit 1; \
	fi;

	@if [ "$$(test/test_hsearch_r_shared | echo $$?)" = "0" ]; then \
		echo "Test #4: found no issues when executing test #2"; \
	else \
		echo "Test #4: encountered unexpected issue when executing test #2"; \
		exit 1; \
	fi;
#	[ "$$COMPILE_TEST_1" = "0"] && $(error "Test without dynamic library linkage failed to compile!") || @echo "WHAT"
#	[ '$COMPILE_TEST_1' != '0' ] && $(error "Test without dynamic library linkage failed to compile!") || @echo "WHAT"
#	test/test_hsearch_r
#	[ "$$?" != "0"] && $(error "Testing libhsearch_r without dynamic library linkage failed!")

lib: 
	$(CC) $(OS_SHARED_LIBRARY_FLAGS) $(CFLAGS) -fPIC -shared -o libhsearch_r$(SHARED_LIB_EXT) ./search_hsearch_r.c

clean:
	rm -f ./test/test_hsearch_r
	rm -f ./test/test_hsearch_r_shared
	rm -f ./libhsearch_r$(SHARED_LIB_EXT)

