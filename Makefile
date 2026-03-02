# /seatract/Makefile
include meta.mk

ALL_TARGETS :=
CLEAN_LIST :=

EXAMPLES_VALID :=
EXAMPLES_DEMO_BINS :=

CHECKMAKE=go run github.com/checkmake/checkmake/cmd/checkmake@v0.3.2




# Include the root module.mk first so shared variables are defined
include ./module.mk
# Then include example library module.mk files, followed by demo module.mk files, in a stable order
include $(shell find ./examples -path "*/library/module.mk" | sort)
include $(shell find ./examples -path "*/demo/module.mk" | sort)
.PHONY: checkmake
checkmake:
	@$(CHECKMAKE) Makefile


.PHONY: shellcheck
shellcheck:
	@shellcheck $(shell find . -name '*.sh')
.PHONY: lint

lint: checkmake shellcheck


.PHONY: run.examples.valid
run.examples.valid: $(EXAMPLES_VALID)
	@for cmd in $(EXAMPLES_VALID); do $$cmd ; done


.PHONY: examples.demos
examples.demos: $(EXAMPLES_DEMO_BINS)

.PHONY: all
all: $(ALL_TARGETS)

.PHONY: test
test: run.examples.valid

.PHONY: check
check: lint all test

.PHONY: clean
clean:
	rm -rf $(CLEAN_LIST)
