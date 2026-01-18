SHELL := /usr/bin/env bash

.PHONY: help deps fmt lint test check

help:
	@echo "Targets:"
	@echo "  deps   Install dev deps (shfmt, shellcheck) if available via apt"
	@echo "  fmt    Format shell scripts with shfmt"
	@echo "  lint   Run shellcheck"
	@echo "  test   Run smoke tests"
	@echo "  check  Run fmt + lint + test"

deps:
	@command -v apt >/dev/null 2>&1 && sudo apt update && sudo apt install -y shellcheck || true
	@command -v shfmt >/dev/null 2>&1 || echo "shfmt missing. Install from your package manager or release binaries."

fmt:
	@command -v shfmt >/dev/null 2>&1 || (echo "shfmt not found" && exit 1)
	shfmt -w -i 2 -ci -bn bin/*.sh scripts/*.sh test/*.sh

lint:
	@command -v shellcheck >/dev/null 2>&1 || (echo "shellcheck not found" && exit 1)
	shellcheck -x -S warning -P bin:scripts:test -f gcc bin/*.sh scripts/*.sh test/*.sh

test:
	bash test/smoke.sh

check: fmt lint test
