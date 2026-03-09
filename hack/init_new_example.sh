#!/usr/bin/env bash
# this initializes a new example subtree.
# Usage: ./init_new_example.sh name
NAME=$1
UCNAME="$(echo "${NAME}" | tr '[:lower:]' '[:upper:]' )"


# Returns 0 (true) if forbidden chars are found, 1 (false) if clean

has_forbidden_chars() {
	local input="$1"

	# Define the pattern in a variable (no extra quotes inside the brackets)
# This matches: any whitespace, a literal backslash, or a literal dot
forbidden_pattern='[[:space:]\\.]'

	# The regex checks for whitespace, backslash, or dot
	# We use [[:space:]] to catch tabs and newlines as well
	if [[ "${input}" =~ ${forbidden_pattern} ]]
       then
		return 1
	fi
return 0

}

name_is_valid() {
	local name="$1"
	if [[ -z "${name}" ]]
	then
		echo "name may not be empty."
		return 1
	elif has_forbidden_chars "${name}"
	then
		echo "Name contains forbidden characters (whitespace,/,\, '.')."
		return 1
	fi
	return 0
}


if ! name_is_valid "${NAME}"
then
	exit 1
fi

# Define paths
BASE="examples/${NAME}"
LIB="${BASE}/library"
DEMO="${BASE}/demo"

create_dir() {
dir="$1"

if [[ -e "${dir}" ]]; then
		echo "ERROR: ${dir} exists"
		exit 1
fi
 mkdir -p "${dir}"

}


# Create the directory structure
create_dir "${LIB}/src"
create_dir "${LIB}/include"
create_dir "${DEMO}/src"


file="${LIB}/module.mk"
echo "starting file 1 (${file})"
# Create Library module.mk
cat <<EOF1 > "${file}"
# Captured directory for this module
LIB${UCNAME}_BASE_DIR := \$(call GET_SELF_DIR)
LIB${UCNAME}_LIB_DIR := \$(LIB${UCNAME}_BASE_DIR)/lib
LIB${UCNAME}_INC_DIR := \$(LIB${UCNAME}_BASE_DIR)/include
LIB${UCNAME}_SRC_DIR := \$(LIB${UCNAME}_BASE_DIR)/src
LIB${UCNAME}_OBJ_DIR := \$(LIB${UCNAME}_BASE_DIR)/obj
LIB${UCNAME}_LIB_A := \$(LIB${UCNAME}_LIB_DIR)/lib${NAME}.a
LIB${UCNAME}_HDR := \$(LIB${UCNAME}_INC_DIR)/${NAME}.h
LIB${UCNAME}_PC_DIR := \$(LIB${UCNAME}_LIB_DIR)/pkgconfig
LIB${UCNAME}_PC     := \$(LIB${UCNAME}_PC_DIR)/lib${NAME}.pc

LIB${UCNAME}_SRCS := \$(wildcard \$(LIB${UCNAME}_SRC_DIR)/*.c)
LIB${UCNAME}_OBJS := \$(patsubst \$(LIB${UCNAME}_SRC_DIR)/%.c, \$(LIB${UCNAME}_OBJ_DIR)/%.o, \$(LIB${UCNAME}_SRCS))
LIB${UCNAME}_OBJ := \$(LIB${UCNAME}_OBJ_DIR)/${NAME}.o

# 1. Set cflags for building these objects
\$(LIB${UCNAME}_OBJS): CFLAGS += \$(CFLAGS_USE_SEATRACT) -I\$(LIB${UCNAME}_INC_DIR)

# cflags, ldflags, and ldlibs for using this library:
LDLIBS_USE_LIB${UCNAME} := -l${NAME}
LDFLAGS_USE_LIB${UCNAME} := -L\$(LIB${UCNAME}_LIB_DIR)
CPPFLAGS_USE_LIB${UCNAME} := -I\$(LIB${UCNAME}_INC_DIR)
CFLAGS_USE_LIB${UCNAME} :=  \$(CPPFLAGS_USE_LIB${UCNAME})




# 2. Rule to  build the objects (requires seatract include)
\$(${NAME}_LIB${UCNAME}_OBJ_DIR)/%.o: \$(LIB${UCNAME}_SRC_DIR)/%.c \$(SEATRACT_H) \$(LIB${UCNAME}_HDR) \$(LIB${UCNAME}_OBJ_DIR)D \$(${NAME}_LIB_SRC)/%.c
		\$(CC) \$(CFLAGS) \$(GLOBAL_CFLAGS) -c \$< -o \$@

\$(LIB${UCNAME}_OBJ_DIR):
		@mkdir -p \$@

\$(LIB${UCNAME}_LIB_DIR):
		@mkdir -p \$@

\$(LIB${UCNAME}_PC_DIR):
	@mkdir -p \$@

\$(LIB${UCNAME}_PC): \$(LIB${UCNAME}_BASE_DIR)/lib${NAME}.pc.in | \$(LIB${UCNAME}_PC_DIR)
	sed -e 's|@LIBDIR@|\$(LIB${UCNAME}_LIB_DIR)|g' \\
	    -e 's|@INCLUDEDIR@|\$(LIB${UCNAME}_INC_DIR)|g' \\
	    \$< > \$@

.PHONY: lib${NAME}
lib${NAME}: \$(LIB${UCNAME}_LIB_A)

.PHONY: ${NAME}.library
${NAME}.library: lib${NAME}



# 3. Rule: to create the archive library
\$(LIB${UCNAME}_LIB_A): \$(LIB${UCNAME}_OBJS) \$(LIB${UCNAME}_LIB_DIR)
	\$(AR) -rc \$@ \$(LIB${UCNAME}_OBJS)

# populate the globals:
ALL_TARGETS += \$(LIB${UCNAME}_LIB_A) \$(LIB${UCNAME}_PC)
CLEAN_LIST  += \$(LIB${UCNAME}_LIB_A) \$(LIB${UCNAME}_OBJS) \$(LIB${UCNAME}_OBJ_DIR) \$(LIB${UCNAME}_PC) \$(LIB${UCNAME}_PC_DIR) \$(LIB${UCNAME}_LIB_DIR)
EOF1

echo "finished file 1 (${file})."


file="${LIB}/include/${NAME}.h"
echo "starting file 2 (${file})."
# Create template header for library
cat <<EOF2 > "${file}"
/*
 * module providing ${NAME}
 */

#ifndef SEATRACT_EXAMPLE_LIB${UCNAME}_${UCNAME}_H
#define  SEATRACT_EXAMPLE_LIB${UCNAME}_${UCNAME}_H



#endif /* SEATRACT_EXAMPLE_LIB${UCNAME}_${UCNAME}_H */
EOF2

echo "finished file 2 (${file})."

file="${LIB}/lib${NAME}.pc.in"

echo "starting file 3 (${file})."
# Create pkg-config template for library
cat <<EOF3PC > "${file}"
libdir=@LIBDIR@
includedir=@INCLUDEDIR@

Name: lib${NAME}
Description: Example ${NAME} library demonstrating seatract design-by-contract
Version: 0.1
Libs: -L\${libdir} -l${NAME}
Cflags: -I\${includedir}
EOF3PC

echo "finished file 3 (${file})."

file="${LIB}/src/${NAME}.c"

echo "starting file 4 (${file})."
# Create template source for library
cat <<EOF4 > "${file}"

/*
 * module providing ${NAME}.
 */

#include "seatract.h"
#include "${NAME}.h"

/* code here... */
EOF4

echo "finished file 4 (${file})."

file="${DEMO}/module.mk"

echo "starting file 5 (${file})."
# Create Demo module.mk
cat <<EOF5 > "${file}"
${UCNAME}_DEMO_BASE_DIR := \$(call GET_SELF_DIR)
${UCNAME}_DEMO_SRC_DIR  := \$(${UCNAME}_DEMO_BASE_DIR)/src
${UCNAME}_DEMO_BIN_DIR  := \$(${UCNAME}_DEMO_BASE_DIR)/bin

${UCNAME}_DEMO_BIN_VALID := \$(${UCNAME}_DEMO_BIN_DIR)/${NAME}_demo_valid

# # find all .c files in demo/src and plan their output in demo/bin/
${UCNAME}_DEMO_SOURCES := \$(wildcard \$(${UCNAME}_DEMO_SRC_DIR)/*.c)
${UCNAME}_DEMO_BASE_NAMES := \$(foreach src,\$(${UCNAME}_DEMO_SOURCES),\$(basename \$(notdir \$(src))))
${UCNAME}_DEMO_BINS  := \$(patsubst \$(${UCNAME}_DEMO_SRC_DIR)/%.c, \$(${UCNAME}_DEMO_BIN_DIR)/${NAME}_demo_%, \$(${UCNAME}_DEMO_SOURCES))

# 1. Set flags for the demo: use pkg-config if the local .pc is available, else fall back to manual flags
${UCNAME}_PKG_CONFIG_PATH := \$(LIB${UCNAME}_PC_DIR):\$(PKG_CONFIG_PATH)
${UCNAME}_PC_CFLAGS  := \$(shell PKG_CONFIG_PATH=\$(${UCNAME}_PKG_CONFIG_PATH) pkg-config --cflags lib${NAME} 2>/dev/null)
${UCNAME}_PC_LDFLAGS := \$(shell PKG_CONFIG_PATH=\$(${UCNAME}_PKG_CONFIG_PATH) pkg-config --libs-only-L lib${NAME} 2>/dev/null)
${UCNAME}_PC_LDLIBS  := \$(shell PKG_CONFIG_PATH=\$(${UCNAME}_PKG_CONFIG_PATH) pkg-config --libs-only-l lib${NAME} 2>/dev/null)
ifeq (\$(${UCNAME}_PC_CFLAGS),)
${UCNAME}_PC_CFLAGS  := \$(CFLAGS_USE_LIB${UCNAME})
${UCNAME}_PC_LDFLAGS := \$(LDFLAGS_USE_LIB${UCNAME})
${UCNAME}_PC_LDLIBS  := \$(LDLIBS_USE_LIB${UCNAME})
endif

\$(${UCNAME}_DEMO_BINS): CFLAGS  += \$(${UCNAME}_PC_CFLAGS)
\$(${UCNAME}_DEMO_BINS): LDFLAGS += \$(${UCNAME}_PC_LDFLAGS)
\$(${UCNAME}_DEMO_BINS): LDLIBS  += \$(${UCNAME}_PC_LDLIBS)

# Rule: Build demos (links against example library)
# note that the CC command directly references the static library file to avoid linker issues.
# the dependencies include the phony library build target as the library file dep did not work.
\$(${UCNAME}_DEMO_BIN_DIR)/${NAME}_demo_%: \$(${UCNAME}_DEMO_SRC)/%.c lib${NAME} \$(iLIB${UCNAME}_LIB_A) \$(${UCNAME}_DEMO_BIN_DIR)
\\$(CC) \$(CFLAGS) \$(GLOBAL_CFLAGS) \$(LDFLAGS) \$(LDLIBS) \$< \$(LIB${UCNAME}_LIB_A) -o \$@

\$(${UCNAME}_DEMO_BIN_DIR):
		@mkdir -p \$@

.PHONY: ${NAME}.demos
${NAME}.demos: \$(${UCNAME}_DEMO_BINS)



# populate the globals:
ALL_TARGETS += \$(${UCNAME}_DEMO_BINS)
CLEAN_LIST += \$(${UCNAME}_DEMO_BINS) \$(${UCNAME}_DEMO_BIN_DIR)
EXAMPLES_VALID += \$(${UCNAME}_DEMO_BIN_VALID)
EXAMPLES_DEMO_BINS += \$(${UCNAME}_DEMO_BINS)

EOF5

echo "finished file 5 (${file})."


file="${DEMO}/src/valid.c"

echo "starting file 6 (${file})."
# Create template source for a valid demo
cat <<EOF6 > "${file}"

/*
 * A demo program that uses the ${NAME} library in a valid way.
 */

#include "${NAME}.h"

int main() {


return 0;

}
EOF6

echo "finished file 6 (${file})."

file="${DEMO}/src/violate.c"

echo "starting file 7 (${file})."

# Create template source for a violating demo
cat <<EOF7 > "${file}"

/*
 * A demo program that uses the ${NAME} library in a way that violates the contract.
 */

#include "${NAME}.h"

int main() {


return 0;

}
EOF7

echo "finished file 7 (${file})."


echo "example structure for '${NAME}' created under ${BASE}"





