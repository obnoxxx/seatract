#include <stdio.h>
#include "array.h"


int main() {
		IntArray myArr = {{ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100}, 5};
		//int i;

		for (int i=1; i<= myArr.size; i++) {
			int x = get_array_element(&myArr, i-1);
			printf("Element number %d:\t%d\n", i,x);

		}
		return 0;
}

