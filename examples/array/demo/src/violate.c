#include <stdio.h>
#include "array.h"


int main() {
		IntArray myVec = {{10, 20, 30}, 3};
		int x = get_array_element(&myVec, 1); /* Success: valid invocation */
		printf("Element: %d\n", x);

		int y = get_array_element(&myVec, 5); /* This triggers a contract violation */
		(void)y; /* Silence a not-used compiler warning by "using" the variable in a no-op cast*/

		return 0;
}

