/*
 * module providing an array of integers
 */
#include "seatract.h"
#include "array.h"

int get_array_element(IntArray *array, int index) {
	/*
		PRECONDITIONS:
		Index must be within the current logical size
	*/
	Require(array != NULL);
	Require(index >= 0);
	Require(index < array->size);

	int val = array->data[index];
	
	/*
		POSTCONDITION:
		Ensure we aren't returning uninitialized-style data
		(Example logic: our array only stores positive integers)
	*/
	Ensure(val >= 0);
	
	return val;
 }
