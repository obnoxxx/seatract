/*
 * module providing an array of integers
 */


#ifndef SEATRACT_EXAMPLE_LIBARRAY_ARRAY_H
#define SEATRACT_EXAMPLE_LIBARRAY_ARRAY_H

typedef struct {
    int data[10];
    int size;
} IntArray;

/*
 * retrieve an element from the array
 */
int get_array_element(IntArray *array, int index);
#endif  /* _SEATRACT_EXAMPLE_LIBARRAY_ARRAY_H */

