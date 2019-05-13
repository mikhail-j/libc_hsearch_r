/* Test re-entrant hash table search functions without dynamic library linkage.
 *
 * Copyright (C) 1993-2019 Free Software Foundation, Inc.
 * Contributed by Ulrich Drepper <drepper@gnu.ai.mit.edu>, 1993.
 * Copyright (C) 2019 Qijia (Michael) Jin
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

#include "../include/search_hsearch_r.h"

int main(int argc, char* argv[]) {

	struct hsearch_data* hash_table = (struct hsearch_data *)malloc(sizeof(struct hsearch_data));
	if (hash_table == NULL) {
		perror("malloc(): error");
		return 1;
	}
	//initialize 'hsearch_data->table' pointer to NULL value
	hash_table->table = NULL;

	char* key_str = (char *)malloc(4 * sizeof(char));
	if (key_str == NULL) {
		perror("malloc(): error");
		return 1;
	}
	memcpy(key_str, "KEY", (4 * sizeof(char)));

	char* val_str = (char *)malloc(6 * sizeof(char));
	if (val_str == NULL) {
		perror("malloc(): error");
		return 1;
	}
	memcpy(val_str, "VALUE", (6 * sizeof(char)));

	//initialize hash table with 100 elements
	assert(hcreate_r(100, hash_table) == 1);

	ENTRY item;
	item.key = key_str;
	item.data = (void *)val_str;

	//test hsearch_r() with 'retval' set to NULL
	assert(hsearch_r(item, ENTER, NULL, hash_table) == 1);

	//test hsearch_r() with non-NULL valued 'retval'
	ENTRY* answer;
	assert(hsearch_r(item, ENTER, &answer, hash_table) == 1);
	
	//test hsearch_r() with `FIND` ACTION
	assert(hsearch_r(item, FIND, &answer, hash_table) == 1);

	printf("key: %s | value: %s\n", answer->key, ((char *)answer->data));

	hdestroy_r(hash_table);

	free(val_str);
	free(key_str);
	free(hash_table);

	return 0;
}