# Main Project Makefile
# This file contains the primary operational targets
#
# Conventions:
# - ##@ marks section headers/groups
# - ##? marks example sections
# - ##! marks important targets to show in help
# - ##  marks regular targets

# Include centralized color definitions
-include .make/colors.mk

# Save the main Makefile name
MAIN_MAKEFILE := $(firstword $(MAKEFILE_LIST))

# Automatically find all subdirectories containing Makefiles
ALL_SUBDIRS := $(shell find . -mindepth 2 -maxdepth 2 -name Makefile -type f | xargs -I {} dirname {} | sed 's|^\./||' | sort)

# Filter out directories matching patterns in .make/.makeignore
# Uses a temporary file to handle patterns with wildcards safely
ifneq ($(wildcard .make/.makeignore),)
SUBDIRS := $(shell \
	tmpfile=$$(mktemp); \
	grep -v '^\#' .make/.makeignore | sed 's/\#.*$$//g' | grep -v '^$$' | sed 's/^[[:space:]]*//;s/[[:space:]]*$$//' > $$tmpfile; \
	for dir in $(ALL_SUBDIRS); do \
		if ! echo "$$dir" | grep -qf $$tmpfile 2>/dev/null; then \
			echo "$$dir"; \
		fi; \
	done; \
	rm -f $$tmpfile \
)
else
SUBDIRS := $(ALL_SUBDIRS)
endif

# Include internal utilities first (for variables and helpers)
-include .make/internal.mk

# Include all found subdirectory Makefiles
-include $(addsuffix /Makefile,$(SUBDIRS))

# Default target
.DEFAULT_GOAL := quick

# Main examples:
# make all                              # Run complete build and deploy pipeline
# make clean-all                         # Clean all resources across subdirectories

# Quick help without examples (default target)
.PHONY: quick
quick: ## Show quick help (without examples)
	@printf "${CYAN}Project Makefile${NC}\n"
	@printf "\n"
	@printf "Usage: make [target] [VARIABLES]\n"
	@printf "\n"
	@# Show targets from main Makefile with section headers
	@awk 'BEGIN {FS = ":.*##!?"; section=""} \
		/^##@/ { section = substr($$0, 5); printf "\n${YELLOW}%s${NC}\n", section; next } \
		/^[a-zA-Z_0-9-]+:.*?##[^!]/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' $(MAIN_MAKEFILE)
	@printf "\n"
	@# Automatically show marked targets from all subdirectory Makefiles
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ] && grep -q "##!" $$dir/Makefile 2>/dev/null; then \
			dir_name=$$(echo $$dir | sed 's/[_-]/ /g' | awk '{for(i=1;i<=NF;i++) $$i=toupper(substr($$i,1,1)) tolower(substr($$i,2))}1'); \
			printf "${YELLOW}$${dir_name} Operations:${NC}\n"; \
			awk 'BEGIN {FS = ":.*##!"} /^[a-zA-Z_0-9-]+:.*?##!/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' $$dir/Makefile; \
			printf "\n"; \
		fi \
	done
	@printf "${CYAN}Tips:${NC}\n"
	@printf "  ${CYAN}• Use 'make help' to see examples and full documentation${NC}\n"
	@printf "  ${CYAN}• Use 'make utils' to see all system utilities${NC}\n"
	@printf "  ${CYAN}• Use 'make list-all' to see all available targets${NC}\n"

# Full help with examples
.PHONY: help
help: ## Show full help with examples
	@printf "${CYAN}Project Makefile${NC}\n"
	@printf "\n"
	@printf "Usage: make [target] [VARIABLES]\n"
	@printf "\n"
	@# Show targets from main Makefile with section headers
	@awk 'BEGIN {FS = ":.*##!?"; section=""} \
		/^##@/ { section = substr($$0, 5); printf "\n${YELLOW}%s${NC}\n", section; next } \
		/^[a-zA-Z_0-9-]+:.*?##[^!]/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' $(MAIN_MAKEFILE)
	@printf "\n"
	@# Automatically show marked targets from all subdirectory Makefiles
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ] && grep -q "##!" $$dir/Makefile 2>/dev/null; then \
			dir_name=$$(echo $$dir | sed 's/[_-]/ /g' | awk '{for(i=1;i<=NF;i++) $$i=toupper(substr($$i,1,1)) tolower(substr($$i,2))}1'); \
			printf "${YELLOW}$${dir_name} Operations:${NC}\n"; \
			awk 'BEGIN {FS = ":.*##!"} /^[a-zA-Z_0-9-]+:.*?##!/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' $$dir/Makefile; \
			printf "\n"; \
		fi \
	done
	@# Show utilities from internal.mk if present
	@if [ -f .make/internal.mk ] && grep -q "##" .make/internal.mk 2>/dev/null; then \
		printf "${YELLOW}System Utilities:${NC}\n"; \
		awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_0-9-]+:.*?##[^!@]/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' .make/internal.mk | head -5; \
		printf "  ${CYAN}... use 'make utils' to see all utilities${NC}\n"; \
		echo ""; \
	fi
	@printf "${YELLOW}Examples:${NC}\n"
	@printf "${CYAN}Main Operations:${NC}\n"
	@printf "  make all                   # Run complete pipeline\n"
	@printf "  make clean-all             # Clean all resources\n"
	@printf "\n"
	@# Display examples from each subdirectory Makefile
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ] && grep -q '##?' $$dir/Makefile 2>/dev/null; then \
			dir_name=$$(echo $$dir | sed 's/[_-]/ /g' | awk '{for(i=1;i<=NF;i++) $$i=toupper(substr($$i,1,1)) tolower(substr($$i,2))}1'); \
			printf "${CYAN}$${dir_name} Examples:${NC}\n"; \
			awk '/##\? Examples:/,/^$$/ { if (/^# /) { sub(/^# /, "  "); print } }' $$dir/Makefile; \
			printf "\n"; \
		fi \
	done
	@printf "${CYAN}Tips:${NC}\n"
	@printf "  ${CYAN}• Use 'make utils' to see all system utilities${NC}\n"
	@printf "  ${CYAN}• Use 'make list-all' to see all available targets${NC}\n"

##@ Main Operations

self-update: ## Auto-update Makefile system using cherry-go
	@printf "${CYAN}🔄 Syncing Makefile system with cherry-go...${NC}\n"
	@cherry-go sync full-install
	@printf "${GREEN}✅ Update completed!${NC}\n"

self-cherry-add: ## Add cherry bunch configuration from repository
	@printf "${CYAN}📦 Adding cherry bunch configuration...${NC}\n"
	@cherry-go add cb https://raw.githubusercontent.com/theburrowhub/modular-make/refs/heads/main/full-install.cherrybunch
	@printf "${GREEN}✅ Cherry bunch configuration added!${NC}\n"

all: ## Run all build and deploy steps
	@printf "${BLUE}🚀 Running complete build and deploy pipeline...${NC}\n"
	@# Try to run docker build if available
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ] && grep -q "^build:" $$dir/Makefile 2>/dev/null; then \
			printf "Building in $$dir...\n"; \
			$(MAKE) -C $$dir build 2>/dev/null || true; \
		fi \
	done
	@# Try to run deploy if available
	@$(MAKE) deploy 2>/dev/null || printf "${YELLOW}Deploy target not available${NC}\n"
	@printf "${GREEN}✅ Pipeline completed!${NC}\n"

clean-all: ## Clean all generated files and resources
	@printf "${RED}🧹 Cleaning all resources...${NC}\n"
	@# Run specific clean targets for each subdirectory
	@if [ -f docker/Makefile ]; then \
		printf "Cleaning Docker resources...\n"; \
		$(MAKE) docker-clean 2>/dev/null || true; \
	fi
	@if [ -f doc/Makefile ]; then \
		printf "Cleaning documentation...\n"; \
		$(MAKE) doc-clean 2>/dev/null || true; \
	fi
	@# Check for other subdirectories with clean targets
	@for dir in $(SUBDIRS); do \
		if [ "$$dir" != "docker" ] && [ "$$dir" != "doc" ] && [ -f $$dir/Makefile ]; then \
			if grep -q "^$$dir-clean:" $$dir/Makefile 2>/dev/null; then \
				printf "Cleaning $$dir...\n"; \
				$(MAKE) $$dir-clean 2>/dev/null || true; \
			elif grep -q "^clean:" $$dir/Makefile 2>/dev/null; then \
				printf "Cleaning $$dir...\n"; \
				$(MAKE) -C $$dir clean 2>/dev/null || true; \
			fi \
		fi \
	done
	@printf "${GREEN}✅ Cleanup completed!${NC}\n"

.PHONY: quick help all clean-all self-update self-cherry-add