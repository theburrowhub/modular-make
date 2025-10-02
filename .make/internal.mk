# Internal utilities and control targets for Makefile system
# This file contains targets for managing the Makefile infrastructure

# Note: Colors are defined in colors.mk which is included by the main Makefile

##@ Makefile System Utilities

utils: ## Show all system utilities
	@echo "${CYAN}System Utilities Available:${NC}"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; section=""} \
		/^##@/ { section = substr($$0, 5); printf "\n${YELLOW}%s:${NC}\n", section; next } \
		/^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${GREEN}%-25s${NC} %s\n", $$1, $$2 }' .make/internal.mk
	@echo ""
	@echo "${CYAN}Quick Access:${NC}"
	@echo "  ${GREEN}make check-deps${NC}   - Check all dependencies status"
	@echo "  ${GREEN}make deps-update${NC}  - Auto-install missing dependencies"
	@echo "  ${GREEN}make deps-list${NC}    - List all dependencies"
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

list-ignored: ## Show directories being ignored by .makeignore
	@echo "${CYAN}Ignored Directories (.make/.makeignore):${NC}"
	@echo ""
	@if [ -f .make/.makeignore ]; then \
		echo "${YELLOW}Patterns in .makeignore:${NC}"; \
		grep -v '^\#' .make/.makeignore | sed 's/\#.*$$//g' | grep -v '^$$' | sed 's/^[[:space:]]*//;s/[[:space:]]*$$//' | while read pattern; do \
			echo "  ${CYAN}$$pattern${NC}"; \
		done; \
		echo ""; \
		echo "${YELLOW}Directories with Makefiles that are ignored:${NC}"; \
		found_ignored=0; \
		for dir in $(ALL_SUBDIRS); do \
			is_included=0; \
			for included in $(SUBDIRS); do \
				if [ "$$dir" = "$$included" ]; then \
					is_included=1; \
					break; \
				fi; \
			done; \
			if [ $$is_included -eq 0 ]; then \
				echo "  ${RED}✗${NC} $$dir/ (ignored)"; \
				found_ignored=1; \
			fi; \
		done; \
		if [ $$found_ignored -eq 0 ]; then \
			echo "  ${GREEN}None currently ignored${NC}"; \
		fi; \
	else \
		echo "${YELLOW}No .make/.makeignore file found${NC}"; \
		echo "Create one to exclude directories from auto-discovery."; \
	fi

edit-ignore: ## Edit the .makeignore file
	@$${EDITOR:-vi} .make/.makeignore

ignore-init: ## Initialize .makeignore from example file
	@if [ -f .make/.makeignore ]; then \
		echo "${YELLOW}⚠️  .make/.makeignore already exists. Use 'make edit-ignore' to modify it.${NC}"; \
		echo "    To reset, delete .make/.makeignore first: rm .make/.makeignore"; \
	else \
		if [ -f .make/.makeignore.example ]; then \
			cp .make/.makeignore.example .make/.makeignore; \
			echo "${GREEN}✅ Created .make/.makeignore from example file${NC}"; \
			echo "    Edit it with: make edit-ignore"; \
			echo "    View ignored: make list-ignored"; \
		else \
			echo "${YELLOW}Creating basic .make/.makeignore file...${NC}"; \
			echo "# Makefile Ignore Patterns" > .make/.makeignore; \
			echo "# Add directories to exclude from auto-discovery" >> .make/.makeignore; \
			echo "" >> .make/.makeignore; \
			echo "# Version control" >> .make/.makeignore; \
			echo ".git" >> .make/.makeignore; \
			echo ".svn" >> .make/.makeignore; \
			echo "" >> .make/.makeignore; \
			echo "# Dependencies" >> .make/.makeignore; \
			echo "node_modules" >> .make/.makeignore; \
			echo "vendor" >> .make/.makeignore; \
			echo "" >> .make/.makeignore; \
			echo "# Build outputs" >> .make/.makeignore; \
			echo "build" >> .make/.makeignore; \
			echo "dist" >> .make/.makeignore; \
			echo "out" >> .make/.makeignore; \
			echo "" >> .make/.makeignore; \
			echo "# Temporary" >> .make/.makeignore; \
			echo "tmp" >> .make/.makeignore; \
			echo "temp" >> .make/.makeignore; \
			echo "${GREEN}✅ Created basic .make/.makeignore file${NC}"; \
		fi \
	fi

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

##@ Dependencies and Tools Management

check-deps: ## Check all dependencies and show installation status
	@echo "${BLUE}🔍 Checking dependencies...${NC}"
	@echo ""
	@if [ ! -f .make/.make-deps ]; then \
		echo "${YELLOW}⚠️  Dependencies file '.make/.make-deps' not found${NC}"; \
		exit 1; \
	fi
	@# Parse and check each dependency
	@{ required_missing=0; recommended_missing=0; optional_missing=0; \
	required_installable=0; recommended_installable=0; optional_installable=0; \
	echo "${YELLOW}Required:${NC}"; \
	grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
		cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
		desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
		level=$$(echo "$$line" | awk -F':::' '{print $$3}'); \
		check_cmd=$$(echo "$$line" | awk -F':::' '{print $$4}'); \
		install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
		if [ -z "$$cmd" ]; then continue; fi; \
		if [ "$$level" = "required" ]; then \
			if command -v $$cmd >/dev/null 2>&1; then \
				version=$$(eval "$$check_cmd" 2>/dev/null | head -1 || echo "installed"); \
				echo "  ${GREEN}✓${NC} $$cmd - $$desc"; \
				echo "    $$version" | sed 's/^/    /' | head -1; \
			else \
				echo "  ${RED}✗${NC} $$cmd - $$desc"; \
				if [ ! -z "$$install_cmd" ]; then \
					echo "    ${CYAN}→ Install with: make deps-install TOOL=$$cmd${NC}"; \
					echo "REQ_INSTALLABLE"; \
				else \
					echo "    Manual installation required"; \
				fi; \
				echo "REQ_MISSING"; \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "${YELLOW}Recommended:${NC}"; \
	grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
		cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
		desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
		level=$$(echo "$$line" | awk -F':::' '{print $$3}'); \
		check_cmd=$$(echo "$$line" | awk -F':::' '{print $$4}'); \
		install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
		if [ -z "$$cmd" ]; then continue; fi; \
		if [ "$$level" = "recommended" ]; then \
			if command -v $$cmd >/dev/null 2>&1; then \
				version=$$(eval "$$check_cmd" 2>/dev/null | head -1 || echo "installed"); \
				echo "  ${GREEN}✓${NC} $$cmd - $$desc"; \
			else \
				echo "  ${YELLOW}○${NC} $$cmd - $$desc"; \
				if [ ! -z "$$install_cmd" ]; then \
					echo "    ${CYAN}→ Install with: make deps-install TOOL=$$cmd${NC}"; \
					echo "REC_INSTALLABLE"; \
				fi; \
				echo "REC_MISSING"; \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "${YELLOW}Optional:${NC}"; \
	grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
		cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
		desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
		level=$$(echo "$$line" | awk -F':::' '{print $$3}'); \
		check_cmd=$$(echo "$$line" | awk -F':::' '{print $$4}'); \
		install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
		if [ -z "$$cmd" ]; then continue; fi; \
		if [ "$$level" = "optional" ]; then \
			if command -v $$cmd >/dev/null 2>&1; then \
				echo "  ${GREEN}✓${NC} $$cmd - $$desc"; \
			else \
				echo "  ${CYAN}○${NC} $$cmd - $$desc"; \
				if [ ! -z "$$install_cmd" ]; then \
					echo "    ${CYAN}→ Install with: make deps-install TOOL=$$cmd${NC}"; \
				fi; \
			fi; \
		fi; \
	done; } | { \
		required_missing=0; required_installable=0; \
		recommended_missing=0; recommended_installable=0; \
		while IFS= read -r line; do \
			echo "$$line" | grep -q "^REQ_MISSING$$" && required_missing=$$((required_missing + 1)) && continue; \
			echo "$$line" | grep -q "^REQ_INSTALLABLE$$" && required_installable=$$((required_installable + 1)) && continue; \
			echo "$$line" | grep -q "^REC_MISSING$$" && recommended_missing=$$((recommended_missing + 1)) && continue; \
			echo "$$line" | grep -q "^REC_INSTALLABLE$$" && recommended_installable=$$((recommended_installable + 1)) && continue; \
			echo "$$line"; \
		done; \
		echo ""; \
		if [ "$$required_missing" -gt 0 ] 2>/dev/null; then \
			echo "${RED}⚠️  Missing $$required_missing required dependencies!${NC}"; \
			if [ "$$required_installable" -gt 0 ] 2>/dev/null; then \
				echo "${CYAN}   $$required_installable can be auto-installed with 'make deps-update'${NC}"; \
			fi; \
		elif [ "$$recommended_missing" -gt 0 ] 2>/dev/null; then \
			echo "${YELLOW}ℹ️  Missing $$recommended_missing recommended dependencies${NC}"; \
			if [ "$$recommended_installable" -gt 0 ] 2>/dev/null; then \
				echo "${CYAN}   $$recommended_installable can be auto-installed with 'make deps-update'${NC}"; \
			fi; \
		else \
			echo "${GREEN}✅ All required and recommended dependencies are installed!${NC}"; \
		fi; \
	}

deps-update: ## Auto-install/update all installable dependencies
	@echo "${CYAN}🔧 Installing/updating dependencies with available installers...${NC}"
	@echo ""
	@if [ ! -f .make/.make-deps ]; then \
		echo "${YELLOW}⚠️  Dependencies file '.make/.make-deps' not found${NC}"; \
		exit 1; \
	fi
	@updated=0; failed=0; skipped=0; \
	grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
		cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
		desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
		level=$$(echo "$$line" | awk -F':::' '{print $$3}'); \
		check_cmd=$$(echo "$$line" | awk -F':::' '{print $$4}'); \
		install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
		if [ -z "$$cmd" ] || [ -z "$$install_cmd" ]; then continue; fi; \
		if ! command -v $$cmd >/dev/null 2>&1; then \
			echo "${BLUE}📦 Installing $$cmd ($$level)...${NC}"; \
			echo "  $$desc"; \
			if eval "$$install_cmd" 2>/dev/null; then \
				if command -v $$cmd >/dev/null 2>&1; then \
					version=$$(eval "$$check_cmd" 2>/dev/null | head -1 || echo "installed"); \
					echo "${GREEN}  ✅ $$cmd installed successfully${NC}"; \
					echo "     $$version" | head -1; \
					updated=$$((updated + 1)); \
				else \
					echo "${YELLOW}  ⚠️  $$cmd installed but not in PATH yet${NC}"; \
					echo "     You may need to restart your shell"; \
				fi; \
			else \
				echo "${RED}  ✗ Failed to install $$cmd${NC}"; \
				failed=$$((failed + 1)); \
			fi; \
			echo ""; \
		else \
			skipped=$$((skipped + 1)); \
		fi; \
	done | { \
		cat; \
		echo "${GREEN}✅ Dependencies update completed!${NC}"; \
		echo "   Already installed: $$skipped, Installed: $$updated, Failed: $$failed"; \
	}

deps-install: ## Install a specific dependency (use TOOL=name)
	@if [ -z "$(TOOL)" ]; then \
		echo "${RED}❌ Please specify a tool: make deps-install TOOL=cherry-go${NC}"; \
		echo ""; \
		echo "${CYAN}Available installable tools:${NC}"; \
		grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
			cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
			desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
			install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
			if [ ! -z "$$cmd" ] && [ ! -z "$$install_cmd" ]; then \
				if command -v $$cmd >/dev/null 2>&1; then \
					echo "  ${GREEN}✓${NC} $$cmd - $$desc (installed)"; \
				else \
					echo "  ${YELLOW}○${NC} $$cmd - $$desc"; \
				fi; \
			fi; \
		done; \
		exit 1; \
	fi
	@echo "${CYAN}🔧 Installing $(TOOL)...${NC}"
	@found=0; \
	grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
		cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
		desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
		check_cmd=$$(echo "$$line" | awk -F':::' '{print $$4}'); \
		install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
		if [ "$$cmd" = "$(TOOL)" ]; then \
			echo "FOUND"; \
			if [ -z "$$install_cmd" ]; then \
				echo "${RED}❌ $(TOOL) requires manual installation${NC}"; \
				echo "  $$desc"; \
				exit 1; \
			fi; \
			echo "  Description: $$desc"; \
			if command -v $$cmd >/dev/null 2>&1; then \
				echo "${YELLOW}  $(TOOL) is already installed${NC}"; \
				version=$$(eval "$$check_cmd" 2>/dev/null | head -1 || echo "installed"); \
				echo "  Version: $$version" | head -1; \
				echo ""; \
				echo "  Re-installing/updating..."; \
			fi; \
			eval "$$install_cmd"; \
			if command -v $$cmd >/dev/null 2>&1; then \
				version=$$(eval "$$check_cmd" 2>/dev/null | head -1 || echo "installed"); \
				echo "${GREEN}✅ $(TOOL) installed successfully${NC}"; \
				echo "  Version: $$version" | head -1; \
			else \
				echo "${YELLOW}⚠️  $(TOOL) installation may require PATH update or shell restart${NC}"; \
			fi; \
			break; \
		fi; \
	done | { \
		found=0; \
		while IFS= read -r line; do \
			if [ "$$line" = "FOUND" ]; then \
				found=1; \
				continue; \
			fi; \
			echo "$$line"; \
		done; \
		if [ $$found -eq 0 ]; then \
			echo "${RED}❌ Tool $(TOOL) not found in .make/.make-deps${NC}"; \
			exit 1; \
		fi; \
	}

deps-list: ## List all dependencies with installation capability
	@echo "${CYAN}All Dependencies:${NC}"
	@echo ""
	@grep -v '^#' .make/.make-deps | grep -v '^$$' | while IFS= read -r line; do \
		cmd=$$(echo "$$line" | awk -F':::' '{print $$1}'); \
		desc=$$(echo "$$line" | awk -F':::' '{print $$2}'); \
		level=$$(echo "$$line" | awk -F':::' '{print $$3}'); \
		install_cmd=$$(echo "$$line" | awk -F':::' '{print $$5}'); \
		if [ -z "$$cmd" ]; then continue; fi; \
		if command -v $$cmd >/dev/null 2>&1; then \
			echo "  ${GREEN}✓${NC} $$cmd ($$level) - $$desc"; \
		else \
			if [ ! -z "$$install_cmd" ]; then \
				echo "  ${YELLOW}○${NC} $$cmd ($$level) - $$desc ${CYAN}[auto-installable]${NC}"; \
			else \
				echo "  ${CYAN}○${NC} $$cmd ($$level) - $$desc ${DIM}[manual install]${NC}"; \
			fi; \
		fi; \
	done
	@echo ""
	@echo "${CYAN}Legend:${NC}"
	@echo "  ${GREEN}✓${NC} = installed"
	@echo "  ${YELLOW}○${NC} = can be installed with 'make deps-install TOOL=name'"
	@echo "  ${CYAN}○${NC} = requires manual installation"

deps-edit: ## Edit the dependencies configuration file
	@$${EDITOR:-vi} .make/.make-deps

deps-show: ## Show the raw dependencies configuration
	@echo "${CYAN}Dependencies Configuration (.make/.make-deps):${NC}"
	@echo ""
	@if [ -f .make/.make-deps ]; then \
		cat .make/.make-deps | while IFS= read -r line; do \
			if [ -z "$$line" ]; then \
				echo ""; \
			elif [ "$${line:0:1}" = "#" ]; then \
				echo "${CYAN}$$line${NC}"; \
			else \
				echo "$$line"; \
			fi; \
		done; \
	else \
		echo "${YELLOW}No .make/.make-deps file found${NC}"; \
	fi

deps-init: ## Initialize dependencies file from example
	@if [ -f .make/.make-deps ]; then \
		echo "${YELLOW}⚠️  .make/.make-deps already exists. Use 'make deps-edit' to modify it.${NC}"; \
		echo "    To reset, delete .make/.make-deps first: rm .make/.make-deps"; \
	else \
		if [ -f .make/.make-deps.example ]; then \
			cp .make/.make-deps.example .make/.make-deps; \
			echo "${GREEN}✅ Created .make/.make-deps from example file${NC}"; \
			echo "    Edit it with: make deps-edit"; \
		else \
			echo "${YELLOW}Creating basic .make/.make-deps file...${NC}"; \
			echo "# Makefile System Dependencies" > .make/.make-deps; \
			echo "# Format: command:::description:::level:::check_command:::install_command" >> .make/.make-deps; \
			echo "" >> .make/.make-deps; \
			echo "make:::GNU Make build tool:::required:::make --version:::" >> .make/.make-deps; \
			echo "docker:::Docker container runtime:::recommended:::docker --version:::" >> .make/.make-deps; \
			echo "kubectl:::Kubernetes CLI:::recommended:::kubectl version --client:::" >> .make/.make-deps; \
			echo "${GREEN}✅ Created basic .make/.make-deps file${NC}"; \
		fi \
	fi

.PHONY: utils utilities list-all list-subdirs list-ignored edit-ignore ignore-init list-marked deps-init deps-edit deps-show check-deps deps-update deps-install deps-list check-conflicts info graph validate-makefiles
