ARRAY_DEMO_BASE_DIR := $(call GET_SELF_DIR)
ARRAY_DEMO_SRC_DIR := $(ARRAY_DEMO_BASE_DIR)/src
ARRAY_DEMO_BIN_DIR := $(ARRAY_DEMO_BASE_DIR)/bin

ARRAY_DEMO_BIN_VALID := $(ARRAY_DEMO_BIN_DIR)/array_demo_valid




# find all .c files in src and plan their output in bin/
ARRAY_DEMO_SOURCES := $(wildcard $(ARRAY_DEMO_SRC_DIR)/*.c)
#ARRAY_DEMO_BASE_NAMES := $(foreach src,$(ARRAY_DEMO_SOURCES),$(basename $(notdir $(src))))
#ARRAY_DEMO_BINS := $(foreach name,$(ARRAY_DEMO_BASE_NAMES),$(ARRAY_DEMO_BIN_DIR)/array_demo_$(name))
ARRAY_DEMO_BINS  := $(patsubst $(ARRAY_DEMO_SRC_DIR)/%.c, $(ARRAY_DEMO_BIN_DIR)/array_demo_%, $(ARRAY_DEMO_SOURCES))

# Find all .c files in demo/src and plan their output in demo/bin
##ARRAY_DEMO_BINS := $(patsubst $(array_DEMO_SRC_DIR)/%.c, $(ARRAY_DEMO_BIN_DIR)/array_demo_%, $(wildcard $(ARRAY_DEMO_SRC_DIR)/*.c))

#ARRAY_DEMO_BINS  := $(addprefix $(ARRAY_DEMO_BIN_DIR)/, \
#	             $(subst /,_,$(patsubst $(SRC_DIR)/%.c,array/demo/%,$(SOURCES))))

# 1. Set flags for the demo (it needs the library include):
$(ARRAY_DEMO_BINS): CFLAGS += $(CFLAGS_USE_LIBARRAY)
$(ARRAY_DEMO_BINS): LDFLAGS += $(LDFLAGS_USE_LIBARRAY)
$(ARRAY_DEMO_BINS): LDLIBS += $(LDLIBS_USE_LIBARRAY)



#DEPFLAGS := -MMD -MP # Flags to generate dependency files




# # Pattern Rule

# note that the CC command direvtly references the static library file to avoid linker issues.
# the dependencies contain the phony library build target because the library file dep did not work. :o
# # % matches the base name (e.g., 'foo')
$(ARRAY_DEMO_BIN_DIR)/array_demo_%: $(ARRAY_DEMO_SRC_DIR)/%.c libarray $(LIBARRAY_LIB_A) $(ARRAY_DEMO_BIN_DIR)
	@$(CC) $(CFLAGS) $(GLOBAL_CFLAGS) $(LDFLAGS) $(LDLIBS) $< $(LDFLAGS) $(LDLIBS) $(LIBARRAY_LIB_A) -o $@
$(ARRAY_DEMO_BIN_DIR):
	@mkdir -p $(ARRAY_DEMO_BIN_DIR)

.PHONY: array.demos
array.demos: $(ARRAY_DEMO_BINS)

# 3. POPULATE THE GLOBALS
ALL_TARGETS += $(ARRAY_DEMO_BINS)
CLEAN_LIST  += $(ARRAY_DEMO_BINS) $(ARRAY_DEMO_BIN_DIR)
EXAMPLES_VALID +=  $(ARRAY_DEMO_BIN_VALID)
EXAMPLES_DEMO_BINS += $(ARRAY_DEMO_BINS)


