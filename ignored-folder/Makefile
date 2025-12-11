# Example Makefile in ignored-folder
# =====================================
# This Makefile demonstrates the .makeignore functionality
# 
# This file would normally be auto-discovered and included by the main Makefile,
# but since "ignored-folder" is listed in .make/.makeignore, it will be excluded.

# Include color definitions if available
-include ../.make/colors.mk

##@ Ignored Folder Operations

ignored-hello: ##! Say hello from ignored folder
	@printf "${CYAN}Hello from ignored-folder!${NC}\n"
	@printf "${YELLOW}This target won't be available from the main Makefile.${NC}\n"
	@printf "${GREEN}This Makefile is ignored by .make/.makeignore${NC}\n"

ignored-build: ## Build something in ignored folder
	@printf "${BLUE}Building in ignored folder...${NC}\n"
	@printf "This would normally be included in the main help.\n"
	@printf "Creating sample build artifact...\n"
	@touch build.tmp
	@printf "${GREEN}✓ Build complete${NC}\n"

ignored-test: ## Run tests in ignored folder
	@printf "${YELLOW}Running tests in ignored folder...${NC}\n"
	@printf "Test 1: Checking isolation... ${GREEN}✓${NC}\n"
	@printf "Test 2: Verifying exclusion... ${GREEN}✓${NC}\n"
	@printf "These tests are isolated from the main build system.\n"

ignored-clean: ## Clean ignored folder artifacts
	@printf "${RED}Cleaning ignored folder...${NC}\n"
	@rm -f *.tmp *.log build.* test.*
	@printf "${GREEN}✓ Cleanup complete${NC}\n"

ignored-info: ## Show information about this ignored Makefile
	@printf "${CYAN}=== Ignored Makefile Information ===${NC}\n"
	@printf "\n"
	@printf "Location: ignored-folder/Makefile\n"
	@printf "Status: ${RED}Excluded from main build${NC}\n"
	@printf "\n"
	@printf "This Makefile demonstrates that:\n"
	@printf "  1. It exists and is functional\n"
	@printf "  2. It's excluded from auto-discovery\n"
	@printf "  3. It can still be run directly\n"
	@printf "\n"
	@printf "To run targets from this Makefile:\n"
	@printf "  ${GREEN}cd ignored-folder && make <target>${NC}\n"
	@printf "  or\n"
	@printf "  ${GREEN}make -C ignored-folder <target>${NC}\n"

# This target would normally be called by clean-all if not ignored
clean: ignored-clean

help: ## Show help for this ignored Makefile
	@printf "${CYAN}Ignored Folder Makefile${NC}\n"
	@printf "\n"
	@printf "This Makefile is in an ignored directory.\n"
	@printf "Available targets:\n"
	@printf "\n"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${GREEN}%-20s${NC} %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: ignored-hello ignored-build ignored-test ignored-clean ignored-info clean help

##? Examples:
# make ignored-hello    # Won't work from main Makefile
# make ignored-build    # Must run: make -C ignored-folder ignored-build
# make ignored-test     # Must be run from within this directory
# make ignored-info     # Shows information about this Makefile
