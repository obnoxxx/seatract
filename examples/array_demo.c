#include "seatract.h"
#include <stdio.h>

typedef struct {
    int data[10];
    int size;
} IntArray;

int get_element(IntArray *array, int index) {
	/*
		RECONDITION: Index must be within the current logical size
	*/
	Require(array != NULL);
	Require(index >= 0 && index < array->size);

	int val = array->data[index];
	
	/*
		POSTCONDITION: Ensure we aren't returning uninitialized-style data
		(Example logic: our array only stores positive integers)
	*/
	Ensure(val >= 0);
	
	return val;
}

int main() {
		IntArray myVec = {{10, 20, 30}, 3};
		int x = get_element(&myVec, 1); // Success
		printf("Element: %d\n", x);

		int y = get_element(&myVec, 5); // This will trigger assert() and halt
		(void)y; /* Silence a not-used compiler warning by "using" the variable in a no-op cast*/

		return 0;
}

