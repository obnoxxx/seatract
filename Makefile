CC = gcc
CFLAGS = -I./include -Wall -Wextra
EXAMPLES_DIR = examples
SOURCES = $(wildcard $(EXAMPLES_DIR)/*.c)
BINS = $(SOURCES:.c=)
CHECKMAKE=go run github.com/checkmake/checkmake/cmd/checkmake@latest




.PHONY: all
all:$(BINS)

$(EXAMPLES_DIR)/%: $(EXAMPLES_DIR)/%.c
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
