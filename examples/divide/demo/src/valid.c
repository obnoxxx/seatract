/*
 *  A demo program that uses the divide library in a valid way.
 */

#include "divide.h"
#include <stdio.h>

int main() {
    printf("Result of 10 / 2: %.2f\n", divide(10, 2));

    printf("Result of 10 / 5: %.2f\n", divide(10, 5));
    printf("Result of 4 / 2: %.2f\n", divide(4, 2));
    printf("Result of 100 / 10: %.2f\n", divide(100, 10));

    return 0;
}
