DIVIDE_DEMO_BASE_DIR := $(call GET_SELF_DIR)
DIVIDE_DEMO_SRC_DIR := $(DIVIDE_DEMO_BASE_DIR)/src
DIVIDE_DEMO_BIN_DIR := $(DIVIDE_DEMO_BASE_DIR)/bin

# find all .c files in src and plan their output in bin/
DIVIDE_DEMO_SOURCES := $(wildcard $(DIVIDE_DEMO_SRC_DIR)/*.c)
#DIVIDE_DEMO_BASE_NAMES := $(foreach src,$(DIVIDE_DEMO_SOURCES),$(basename $(notdir $(src))))
#DIVIDE_DEMO_BINS := $(foreach name,$(DIVIDE_DEMO_BASE_NAMES),$(DIVIDE_DEMO_BIN_DIR)/divide_demo_$(name))
DIVIDE_DEMO_BINS    := $(patsubst $(DIVIDE_DEMO_SRC_DIR)/%.c, $(DIVIDE_DEMO_BIN_DIR)/divide_demo_%, $(DIVIDE_DEMO_SOURCES))

DIVIDE_DEMO_BIN_VALID := $(DIVIDE_DEMO_BIN_DIR)/divide_demo_valid

#	$(AR) -rc $@ $^
# Find all .c files in demo/src and plan their output in demo/bin
##DIVIDE_DEMO_BINS := $(patsubst $(divide_DEMO_SRC_DIR)/%.c, $(DIVIDE_DEMO_BIN_DIR)/divide_demo_%, $(wildcard $(DIVIDE_DEMO_SRC_DIR)/*.c))

#DIVIDE_DEMO_BINS  := $(addprefix $(DIVIDE_DEMO_BIN_DIR)/, \
#	             $(subst /,_,$(patsubst $(SRC_DIR)/%.c,divide/demo/%,$(SOURCES))))

# 1. Set flags for the demo (it needs the library include):
$(DIVIDE_DEMO_BINS): CFLAGS += $(CFLAGS_USE_LIBDIVIDE)
$(DIVIDE_DEMO_BINS): LDFLAGS += $(LDFLAGS_USE_LIBDIVIDE)
$(DIVIDE_DEMO_BINS): LDLIBS += $(LDLIBS_USE_LIBDIVIDE)




#DEPFLAGS := -MMD -MP # Flags to generate dependency files




# # Pattern Rule
# # note that the CC command direvtly references the static library file to avoid linker issues.
# # the dependencies include the phony library build target as the library file dep did not work.
# # % matches the base name (e.g., 'foo')
$(DIVIDE_DEMO_BIN_DIR)/divide_demo_%: $(DIVIDE_DEMO_SRC_DIR)/%.c libdivide $(LIBDIVIDE_LIB_A) $(DIVIDE_DEMO_BIN_DIR)
	$(CC) $(CFLAGS) $(GLOBAL_CFLAGS) $(LDFLAGS) $(LDLIBS) $< $(LIBDIVIDE_LIB_A) $(LDFLAGS) $(LDLIBS) -o $@
$(DIVIDE_DEMO_BIN_DIR):
	@mkdir -p $(DIVIDE_DEMO_BIN_DIR)

.PHONY: divide.demos
divide.demos: $(DIVIDE_DEMO_BINS)

# 3. POPULATE THE GLOBALS
ALL_TARGETS += $(DIVIDE_DEMO_BINS)
CLEAN_LIST  += $(DIVIDE_DEMO_BINS) $(DIVIDE_DEMO_BIN_DIR)

EXAMPLES_VALID += $(DIVIDE_DEMO_BIN_VALID)
