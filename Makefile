# Makefile.starter — skeleton for Lab 02, Task 4 (ASSESSED).
#
# Rename this to  Makefile  and complete every TODO.
# Requirements are listed in Section 4.1 of the lab manual.
#
#     cp Makefile.starter Makefile
#     nano Makefile
#
# EVERY recipe line below must start with a real TAB, not spaces.
# Check yours with:  cat -A Makefile     (a tab shows as ^I)

SRC_DIR := src
OUT_DIR := out

# TODO 1: set SOURCES to every .txt file in $(SRC_DIR), using $(wildcard).
SOURCES := $(wildcard $(SRC_DIR)/*.txt)

# TODO 2: set OUTPUTS to the matching paths under $(OUT_DIR), using $(patsubst).
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

# TODO 3: list every action target here so make never mistakes one for a file.
.PHONY: all check build test clean ci

# The first target in the file is what a bare `make` runs.
all: test

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# TODO 4: the pattern rule. Announce the file with @echo, then convert it.
#         Use $< for the input and $@ for the output — no filenames by hand.
#         Keep the order-only prerequisite  | $(OUT_DIR)  exactly as it is.
$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt | $(OUT_DIR)
	@echo "  BUILD $< -> $@"
	@tr '[:lower:]' '[:upper:]' < $< > $@

# TODO 5: check — exit non-zero with a clear message when $(SRC_DIR) is
#         missing or holds no .txt files; otherwise report how many were
#         found. Hint: `test -d`, `$(words $(SOURCES))`, and remember that
#         each recipe line runs in its own shell.
check:
	@if [ ! -d "$(SRC_DIR)" ]; then \
		echo "CHECK FAILED: missing $(SRC_DIR)"; \
		exit 1; \
	elif [ "$(words $(SOURCES))" -eq 0 ]; then \
		echo "CHECK FAILED: no .txt files found in $(SRC_DIR)"; \
		exit 1; \
	else \
		echo "CHECK PASSED: $(words $(SOURCES)) source(s) found"; \
		fi

# The whole build stage. Nothing to add here — this line is the lesson.
build: $(OUTPUTS)

# TODO 6: test — depend on build, then fail if any output still contains a
#         lowercase letter. A multi-line if needs a backslash on every line
#         but the last. Print TEST PASSED on success.
test: build
	@if grep -q '[a-z]' $(OUTPUTS) >/dev/null 2>&1; then \
		echo "TEST FAILED: lowercase characters remain"; \
		exit 2; \
	fi
	@echo "TEST PASSED"

# TODO 7: clean — remove $(OUT_DIR) entirely.
clean:
	rm -rf $(OUT_DIR)

# A build server's entry point: clean, verify, then build and test.
ci: clean check test
count: build ## report how many words were built
	@wc -w $(OUTPUTS) | tail -1
