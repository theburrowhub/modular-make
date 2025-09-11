# Internal utilities and control targets for Makefile system
# This file contains targets for managing the Makefile infrastructure

# Note: Colors are defined in colors.mk which is included by the main Makefile

##@ Makefile System Utilities

utils: ## Show all system utilities
	@echo "${CYAN}System Utilities Available:${NC}"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; section=""} \
		/^##@/ { section = substr($$0, 5); printf "\n${YELLOW}%s:${NC}\n", section; next } \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' internal.mk
	@echo ""
	@echo "${CYAN}Use any of these utilities directly, e.g., 'make info'${NC}"

utilities: utils ## Alias for utils

list-all: ## List all available targets from all Makefiles
	@echo "${CYAN}All available targets:${NC}"
	@echo ""
	@echo "${YELLOW}From main Makefile:${NC}"
	@awk 'BEGIN {FS = ":.*##!?"; section=""} \
		/^##@/ { section = substr($$0, 5); printf "\n  ${CYAN}%s:${NC}\n", section; next } \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "    ${GREEN}%-23s${NC} %s\n", $$1, $$2 }' $(MAIN_MAKEFILE)
	@echo ""
	@# List targets from all subdirectory Makefiles
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ]; then \
			echo "${YELLOW}From $$dir/Makefile:${NC}"; \
			(cd $$dir && awk 'BEGIN {FS = ":.*##!?"; section=""} \
				/^##@/ { section = substr($$0, 5); printf "\n  ${CYAN}%s:${NC}\n", section; next } \
				/^[a-zA-Z_0-9-]+:.*?##/ { \
					if (section != "") { printf "    ${GREEN}%-23s${NC} %s\n", $$1, $$2 } \
					else { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 } \
				}' Makefile); \
			echo ""; \
		fi \
	done

list-subdirs: ## List all discovered subdirectories with Makefiles
	@echo "${CYAN}Discovered Makefiles in:${NC}"
	@for dir in $(SUBDIRS); do \
		echo "  ${GREEN}$$dir/${NC}"; \
	done
	@echo ""
	@echo "${YELLOW}Total: $$(echo '$(SUBDIRS)' | wc -w) subdirectories${NC}"

list-marked: ## List only marked targets from all Makefiles
	@echo "${CYAN}Marked targets across all Makefiles:${NC}"
	@echo ""
	@# Check main Makefile for marked targets
	@if grep -q "##!" $(MAIN_MAKEFILE) 2>/dev/null; then \
		echo "${YELLOW}From main Makefile:${NC}"; \
		awk 'BEGIN {FS = ":.*##!"} /^[a-zA-Z_0-9-]+:.*?##!/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' $(MAIN_MAKEFILE); \
		echo ""; \
	fi
	@# Check subdirectory Makefiles for marked targets
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ] && grep -q "##!" $$dir/Makefile 2>/dev/null; then \
			echo "${YELLOW}From $$dir/:${NC}"; \
			awk 'BEGIN {FS = ":.*##!"} /^[a-zA-Z_0-9-]+:.*?##!/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' $$dir/Makefile; \
			echo ""; \
		fi \
	done

deps-init: ## Initialize dependencies file from example
	@if [ -f .make-deps ]; then \
		echo "${YELLOW}⚠️  .make-deps already exists. Use 'make deps-edit' to modify it.${NC}"; \
		echo "    To reset, delete .make-deps first: rm .make-deps"; \
	else \
		if [ -f .make-deps.example ]; then \
			cp .make-deps.example .make-deps; \
			echo "${GREEN}✅ Created .make-deps from example file${NC}"; \
			echo "    Edit it with: make deps-edit"; \
		else \
			echo "${YELLOW}Creating basic .make-deps file...${NC}"; \
			echo "# Project Dependencies" > .make-deps; \
			echo "make:GNU Make:required" >> .make-deps; \
			echo "docker:Docker:recommended" >> .make-deps; \
			echo "kubectl:Kubernetes CLI:recommended" >> .make-deps; \
			echo "${GREEN}✅ Created basic .make-deps file${NC}"; \
		fi \
	fi

deps-edit: ## Edit the dependencies configuration file
	@$${EDITOR:-vi} .make-deps

deps-show: ## Show the dependencies configuration
	@echo "${CYAN}Dependencies Configuration (.make-deps):${NC}"
	@echo ""
	@if [ -f .make-deps ]; then \
		cat .make-deps | while IFS= read -r line; do \
			if [ -z "$$line" ]; then \
				echo ""; \
			elif [ "$${line:0:1}" = "#" ]; then \
				echo "${CYAN}$$line${NC}"; \
			else \
				echo "$$line"; \
			fi; \
		done; \
	else \
		echo "${YELLOW}No .make-deps file found${NC}"; \
	fi

check-deps: ## Check required dependencies from .make-deps file
	@echo "${BLUE}🔍 Checking dependencies...${NC}"
	@echo ""
	@# Check if dependencies file exists
	@if [ ! -f .make-deps ]; then \
		echo "${YELLOW}⚠️  Dependencies file '.make-deps' not found${NC}"; \
		echo "Creating default dependencies file..."; \
		echo "# Add your dependencies here" > .make-deps; \
		echo "make:GNU Make:required" >> .make-deps; \
		echo "docker:Docker container runtime:recommended" >> .make-deps; \
		echo "kubectl:Kubernetes CLI:recommended" >> .make-deps; \
	fi
	@# Parse and check each dependency
	@required_missing=0; recommended_missing=0; \
	echo "${YELLOW}Required:${NC}"; \
	while IFS=: read -r cmd desc level || [ -n "$$cmd" ]; do \
		if [ -z "$$cmd" ] || [ "$${cmd:0:1}" = "#" ]; then continue; fi; \
		if [ "$$level" = "required" ]; then \
			if command -v $$cmd >/dev/null 2>&1; then \
				echo "  ${GREEN}✓${NC} $$desc ($$cmd)"; \
			else \
				echo "  ${RED}✗${NC} $$desc ($$cmd) - NOT FOUND"; \
				required_missing=$$((required_missing + 1)); \
			fi; \
		fi; \
	done < .make-deps; \
	echo ""; \
	echo "${YELLOW}Recommended:${NC}"; \
	while IFS=: read -r cmd desc level || [ -n "$$cmd" ]; do \
		if [ -z "$$cmd" ] || [ "$${cmd:0:1}" = "#" ]; then continue; fi; \
		if [ "$$level" = "recommended" ]; then \
			if command -v $$cmd >/dev/null 2>&1; then \
				echo "  ${GREEN}✓${NC} $$desc ($$cmd)"; \
			else \
				echo "  ${YELLOW}○${NC} $$desc ($$cmd) - not found"; \
				recommended_missing=$$((recommended_missing + 1)); \
			fi; \
		fi; \
	done < .make-deps; \
	echo ""; \
	echo "${YELLOW}Optional:${NC}"; \
	while IFS=: read -r cmd desc level || [ -n "$$cmd" ]; do \
		if [ -z "$$cmd" ] || [ "$${cmd:0:1}" = "#" ]; then continue; fi; \
		if [ "$$level" = "optional" ]; then \
			if command -v $$cmd >/dev/null 2>&1; then \
				echo "  ${GREEN}✓${NC} $$desc ($$cmd)"; \
			else \
				echo "  ${CYAN}○${NC} $$desc ($$cmd) - not installed"; \
			fi; \
		fi; \
	done < .make-deps; \
	echo ""; \
	if [ $$required_missing -gt 0 ]; then \
		echo "${RED}⚠️  Missing $$required_missing required dependencies!${NC}"; \
		exit 1; \
	elif [ $$recommended_missing -gt 0 ]; then \
		echo "${YELLOW}ℹ️  Missing $$recommended_missing recommended dependencies${NC}"; \
	else \
		echo "${GREEN}✅ All required and recommended dependencies are installed!${NC}"; \
	fi

check-conflicts: ## Check for target name conflicts across Makefiles
	@echo "${BLUE}🔍 Checking for target conflicts...${NC}"
	@echo ""
	@# Collect all targets and find duplicates
	@{ \
		awk -F: '/^[a-zA-Z_0-9-]+:/ {print $$1 " main"}' $(MAIN_MAKEFILE); \
		for dir in $(SUBDIRS); do \
			if [ -f $$dir/Makefile ]; then \
				awk -F: -v dir=$$dir '/^[a-zA-Z_0-9-]+:/ {print $$1 " " dir}' $$dir/Makefile; \
			fi \
		done \
	} | sort | awk '{ \
		target = $$1; location = $$2; \
		if (target == prev_target) { \
			if (!printed[target]) { \
				printf "${YELLOW}Target '\''%s'\'' found in:${NC}\n", target; \
				printf "  - %s\n", prev_location; \
				printed[target] = 1; \
			} \
			printf "  - %s\n", location; \
			found_conflicts = 1; \
		} \
		prev_target = target; prev_location = location; \
	} END { \
		if (!found_conflicts) { \
			printf "${GREEN}✓ No conflicts found!${NC}\n"; \
		} \
	}'

info: ## Show Makefile system information
	@echo "${CYAN}Makefile System Information${NC}"
	@echo ""
	@echo "${YELLOW}Configuration:${NC}"
	@echo "  Main Makefile: $(MAIN_MAKEFILE)"
	@echo "  Subdirectories: $(SUBDIRS)"
	@echo "  Total Makefiles: $$(echo '$(SUBDIRS)' | wc -w | xargs expr 1 +)"
	@echo ""
	@echo "${YELLOW}Statistics:${NC}"
	@printf "  Total targets in main: "
	@grep -c "^[a-zA-Z_0-9-].*:.*##" $(MAIN_MAKEFILE) 2>/dev/null || echo "0"
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ]; then \
			count=$$(grep -c "^[a-zA-Z_0-9-].*:.*##" $$dir/Makefile 2>/dev/null || echo "0"); \
			echo "  Total targets in $$dir: $$count"; \
		fi \
	done
	@echo ""
	@printf "  Total marked targets: "
	@{ grep -c "##!" $(MAIN_MAKEFILE) 2>/dev/null || echo "0"; \
	   for dir in $(SUBDIRS); do \
		   [ -f $$dir/Makefile ] && (grep -c "##!" $$dir/Makefile 2>/dev/null || echo "0"); \
	   done; } | awk '{sum += $$1} END {print sum}'

graph: ## Show target dependency graph (dynamically generated)
	@echo "${CYAN}Makefile System Structure:${NC}"
	@echo ""
	@echo "${YELLOW}Main Orchestration (Makefile):${NC}"
	@printf "  ├── all ${GREEN}(orchestrates build pipeline)${NC}\n"
	@printf "  └── clean-all ${GREEN}(orchestrates cleanup)${NC}\n"
	@echo ""
	@echo "${YELLOW}Subdirectory Targets:${NC}"
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ]; then \
			echo ""; \
			echo "  ${CYAN}$$dir/${NC}"; \
			grep "^[a-zA-Z_0-9-].*:.*##" $$dir/Makefile | \
				awk -F':.*##' '{gsub(/^[ \t]+|[ \t]+$$/, "", $$2); \
					if ($$2 ~ /^!/) { \
						printf "    ├── %-20s ${GREEN}[MAIN]${NC}\n", $$1; \
					} else { \
						printf "    ├── %-20s\n", $$1; \
					}}' | \
				sed '$$s/├/└/'; \
		fi \
	done
	@echo ""
	@echo "${YELLOW}Cross-Makefile Dependencies:${NC}"
	@echo "  clean-all ${CYAN}(calls)${NC}"
	@first=1; \
	for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ]; then \
			if grep -q "^$$dir-clean:" $$dir/Makefile 2>/dev/null; then \
				if [ $$first -eq 1 ]; then \
					printf "    ├── $$dir-clean\n"; \
					first=0; \
				else \
					printf "    ├── $$dir-clean\n"; \
				fi; \
			elif grep -q "^clean:" $$dir/Makefile 2>/dev/null; then \
				printf "    ├── $$dir/clean (standard)\n"; \
			fi; \
		fi \
	done | sed '$$s/├/└/'
	@echo ""
	@echo "${YELLOW}Important Targets (shown in main help):${NC}"
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ]; then \
			marked=$$(grep "##!" $$dir/Makefile | awk -F':' '{print $$1}' | tr '\n' ' '); \
			if [ ! -z "$$marked" ]; then \
				printf "  %-10s: ${GREEN}%s${NC}\n" $$dir "$$marked"; \
			fi; \
		fi \
	done
	@echo ""
	@echo "${YELLOW}Makefiles with Examples:${NC}"
	@for dir in $(SUBDIRS); do \
		if [ -f $$dir/Makefile ] && grep -q "##?" $$dir/Makefile 2>/dev/null; then \
			printf "  ${GREEN}✓${NC} $$dir\n"; \
		fi \
	done
	@echo ""
	@echo "${YELLOW}Target Counts:${NC}"
	@total=0; \
	for dir in . $(SUBDIRS); do \
		if [ "$$dir" = "." ]; then \
			file="$(MAIN_MAKEFILE)"; \
			name="main"; \
		else \
			file="$$dir/Makefile"; \
			name="$$dir"; \
		fi; \
		if [ -f $$file ]; then \
			count=$$(grep -c "^[a-zA-Z_0-9-].*:.*##" $$file 2>/dev/null || echo "0"); \
			printf "  %-15s: %2d targets\n" $$name $$count; \
			total=$$((total + count)); \
		fi \
	done; \
	echo "  ${GREEN}──────────────────────${NC}"; \
	printf "  %-15s: %2d targets\n" "Total" $$total

##@ Makefile Maintenance

validate-makefiles: ## Validate syntax of all Makefiles
	@echo "${BLUE}✔️ Validating Makefile syntax...${NC}"
	@error=0; \
	for file in $(MAIN_MAKEFILE) $(addsuffix /Makefile,$(SUBDIRS)); do \
		if [ -f $$file ]; then \
			if make -n -f $$file -p >/dev/null 2>&1; then \
				echo "  ${GREEN}✓${NC} $$file is valid"; \
			else \
				echo "  ${RED}✗${NC} $$file has syntax errors"; \
				error=1; \
			fi; \
		fi \
	done; \
	[ $$error -eq 0 ] && echo "${GREEN}All Makefiles are valid!${NC}" || echo "${RED}Some Makefiles have errors${NC}"

.PHONY: utils utilities list-all list-subdirs list-marked deps-init deps-edit deps-show check-deps check-conflicts info graph validate-makefiles
