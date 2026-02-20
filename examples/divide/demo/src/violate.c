/*
 * A demo program using the divide library in a way that violates the contract
 */

#include "divide.h"
#include <stdio.h>

int main() {
/* A valid use of divide: */
    printf("Result of 10 / 2: %.2f\n", divide(10, 2));

    /* This call triggers a contract violation in divide: */
    printf("Result of 10 / 0: %.2f\n", divide(10, 0));

    return 0;
}
