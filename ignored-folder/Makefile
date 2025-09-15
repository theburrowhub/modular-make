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
	@echo "${CYAN}Hello from ignored-folder!${NC}"
	@echo "${YELLOW}This target won't be available from the main Makefile.${NC}"
	@echo "${GREEN}This Makefile is ignored by .make/.makeignore${NC}"

ignored-build: ## Build something in ignored folder
	@echo "${BLUE}Building in ignored folder...${NC}"
	@echo "This would normally be included in the main help."
	@echo "Creating sample build artifact..."
	@touch build.tmp
	@echo "${GREEN}✓ Build complete${NC}"

ignored-test: ## Run tests in ignored folder
	@echo "${YELLOW}Running tests in ignored folder...${NC}"
	@echo "Test 1: Checking isolation... ${GREEN}✓${NC}"
	@echo "Test 2: Verifying exclusion... ${GREEN}✓${NC}"
	@echo "These tests are isolated from the main build system."

ignored-clean: ## Clean ignored folder artifacts
	@echo "${RED}Cleaning ignored folder...${NC}"
	@rm -f *.tmp *.log build.* test.*
	@echo "${GREEN}✓ Cleanup complete${NC}"

ignored-info: ## Show information about this ignored Makefile
	@echo "${CYAN}=== Ignored Makefile Information ===${NC}"
	@echo ""
	@echo "Location: ignored-folder/Makefile"
	@echo "Status: ${RED}Excluded from main build${NC}"
	@echo ""
	@echo "This Makefile demonstrates that:"
	@echo "  1. It exists and is functional"
	@echo "  2. It's excluded from auto-discovery"
	@echo "  3. It can still be run directly"
	@echo ""
	@echo "To run targets from this Makefile:"
	@echo "  ${GREEN}cd ignored-folder && make <target>${NC}"
	@echo "  or"
	@echo "  ${GREEN}make -C ignored-folder <target>${NC}"

# This target would normally be called by clean-all if not ignored
clean: ignored-clean

help: ## Show help for this ignored Makefile
	@echo "${CYAN}Ignored Folder Makefile${NC}"
	@echo ""
	@echo "This Makefile is in an ignored directory."
	@echo "Available targets:"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${GREEN}%-20s${NC} %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: ignored-hello ignored-build ignored-test ignored-clean ignored-info clean help

##? Examples:
# make ignored-hello    # Won't work from main Makefile
# make ignored-build    # Must run: make -C ignored-folder ignored-build
# make ignored-test     # Must be run from within this directory
# make ignored-info     # Shows information about this Makefile
