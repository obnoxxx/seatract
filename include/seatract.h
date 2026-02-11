/*
  seatract provides design-by-contract-like mechanisms to
  write preconditions and postconditions in C.

  preconditions and postconditions can be implemented using assert(3) but
  while still relying on abort, seatract offers more idiomatically named wrappers Require() and Ensure()
  Thatproduce more helpful error output than plain assert(3).
*/

 


#ifndef __SEATRACT_H
#define __SEATRACT_H

#include <stdio.h>
#include <stdlib.h>


/*
A simple internal handler as substitute for assert(3).
It adds useful context to the error output.
*/
#define CONTRACT_ASSERT(cond, type) \
	do { \
		if (!(cond)) { \
			fprintf(stderr, "SEATRACT VIOLATION [%s]: '%s' failed in %s (%s:%d)\n", \
				type, #cond, __func__, __FILE__, __LINE__); \
		 abort(); \
		} \
	while (0)

#define Require(cond) CONTRACT_ASSERT(cond, "Precondition")
#define Ensure(cond)  CONTRACT_ASSERT(cond, "Postcondition")



#endif /* __SEATRACT_H */
