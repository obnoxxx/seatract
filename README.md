
[![Build Status](https://github.com/SeaTract/seatract/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/SeaTract/seatract/actions)
[![GPL license](https://img.shields.io/badge/license-GPL-blue.svg)](http://opensource.org/licenses/GPL)

# seatract

**seatract** is a lightweight Design by Contract (DbC) framework for C, inspired by the [gontract](https://github.com/gontract/gontract) project. It aims to bridge the "Procedural Gap" in C development by providing explicit mechanisms for preconditions (`Require`) and postconditions (`Ensure`).

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
```

---

## Building the Examples

```sh
make all
```

This builds the example libraries (`libdivide.a`, `libarray.a`), their demo binaries, and generates a `pkg-config` metadata file (`.pc`) for each library under `lib/pkgconfig/`.

---

## pkg-config Integration

Each example library ships a generated `.pc` file at `lib/pkgconfig/<name>.pc` after running `make all`.
To use it from an external project or shell session, point `PKG_CONFIG_PATH` at the generated directory:

```sh
# For libdivide:
export PKG_CONFIG_PATH=/path/to/seatract/examples/divide/library/lib/pkgconfig:$PKG_CONFIG_PATH
pkg-config --cflags libdivide   # e.g. -I/path/to/.../include
pkg-config --libs   libdivide   # e.g. -L/path/to/.../lib -ldivide

# For libarray:
export PKG_CONFIG_PATH=/path/to/seatract/examples/array/library/lib/pkgconfig:$PKG_CONFIG_PATH
pkg-config --cflags libarray
pkg-config --libs   libarray
```

The demo builds use `pkg-config` automatically when the `.pc` file is present, and fall back to manual flags otherwise, so the build always works regardless of build order.
