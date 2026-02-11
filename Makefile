CC = gcc
CFLAGS = -I./include -Wall -Wextra
CFLAGS_STRIP= -DNDEBUG

EXAMPLES_DIR = examples
SOURCES = $(wildcard $(EXAMPLES_DIR)/*.c)
BINS = $(SOURCES:.c=)
	BINS_STRIPPED = $(SOURCES:.c=_stripped)
CHECKMAKE=go run github.com/checkmake/checkmake/cmd/checkmake@latest




.PHONY: all
all: build build.stripped
.PHONY: build
build: examples
.PHONY: examples
examples:$(BINS)
.PHONY:build.stripped
build.stripped: examples.stripped
.PHONY: examples.stripped

examples.stripped: $(BINS_STRIPPED)
$(EXAMPLES_DIR)/%_stripped: $(EXAMPLES_DIR)/%.c Makefile
	$(CC) $(CFLAGS) $(CFLAGS_STRIP) $< -o $@

$(EXAMPLES_DIR)/%: $(EXAMPLES_DIR)/%.c Makefile
	$(CC) $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f $(BINS)

.PHONY: makeckmake
checkmake: ## lint the Makefile with checkmake.
	@$(CHECKMAKE) Makefile

.PHONY: check
check: checkmake

.PHONY: test
test: check
