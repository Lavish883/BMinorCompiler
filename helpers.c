#include <stdio.h>
#include "helpers.h"

void indent(int level) {
	for (int i = 0; i < level; i++) {
		printf(" ");
	}
}