# libc_hsearch_r

`libhsearch_r` is designed to be a portable implementation of the hash table GNU extensions of `search.h` (C standard library).

libhsearch_r runs on operating systems that do not provide `hcreate_r()`, `hsearch_r()`, and `hdestroy_r()` GNU extensions (MacOS, Microsoft Windows, etc). These GNU extensions are a thread-safe re-entrant implementation of hash tables according the [Linux's manual page for HSEARCH(3)](http://man7.org/linux/man-pages/man3/hcreate.3.html).

Functions provided by libhsearch_r
----------------------------------

- `hcreate_r(size_t nel, struct hsearch_data *htab)` - Initializes hash table handle `htab` with `nel` elements.
`htab->table` must be initialized to NULL.
- `hdestroy_r(struct hsearch_data *htab)` - Frees all hash table resources allocated by `hcreate_r()`.
- `hsearch_r(ENTRY item, ACTION action, ENTRY **retval, struct hsearch_data *htab)` - Returns hash table `ENTRY` through `retval`. The `retval` argument is ignored if the `action` parameter is `FIND`.

How do I import libhsearch_r definitions in my application?
-----------------------------------------------------------

The target application must include the "search_hsearch_r.h" header file.
```c
#include "../relative/path/to/search_hsearch_r.h"
```

How do I compile libhsearch_r as a shared library?
--------------------------------------------------

With `make` (`make lib` also works):
```console
$ make
```

How do I statically link libhsearch_r in my application?
--------------------------------------------------------

With GCC, compile your application with `search_hsearch_r.c`:
```console
$ gcc -std=c99 -o c_application ./search_hsearch_r.c ./c_application
```

How do I dynamically link libhsearch_r in my application?
--------------------------------------------------------

With GCC, compile your application with `-L /path/to/lib/ -l hsearch_r` where /path/to/lib/ is the location of `libhsearch_r.(dll/so/dylib):
```console
$ gcc -std=c99 -o c_application -L /path/to/lib/ -l hsearch_r ./c_application
```

License
-------

The license can be found in [`LICENSE`](https://github.com/mikhail-j/libc_hsearch_r/blob/master/LICENSE).

## Acknowledgements

- Ulrich Drepper contributed the original GNU extensions `hcreate_r()`, `hdestroy_r()`, and `hsearch_r()` for the [GNU C Library](https://www.gnu.org/software/libc/) in 1993.

