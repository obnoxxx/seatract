# seatract

**seatract** is a lightweight Design by Contract (DbC) framework for C, inspired by the **gontract** research project. It aims to bridge the "Procedural Gap" in C development by providing explicit mechanisms for preconditions, postconditions, and invariants.

## Core Pillars
* **Contract Decoupling:** Separating safety logic from business logic.
* **Zero-Overhead Option:** Leverages standard C mechanisms to allow contracts to be stripped in production builds using `NDEBUG`.
* **Safety Assertions:** Provides immediate feedback upon contract violation during development.

---

## API Reference

| Macro | Purpose | Usage |
| :--- | :--- | :--- |
| `Require(cond)` | **Precondition**: Verifies caller-provided input. | Start of function. |
| `Ensure(cond)` | **Postcondition**: Verifies function logic/return values. | Before return. |

---

## Usage Example

```c
#include "seatract.h"

float divide(int a, int b) {
    // Precondition: Divisor must not be zero
    Require(b != 0);

    float result = (float)a / (float)b;

    // Postcondition: Simple mathematical verification
    Ensure(result * b == (float)a); 

    return result;
}
