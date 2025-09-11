# Test Makefile

# Include centralized color definitions
-include ../.make/colors.mk

# Default values
TEST_DIR ?= ./tests
COVERAGE_THRESHOLD ?= 80

##? Examples:
# make test                             # Run all tests
# make lint                             # Run code quality checks
# make unit                             # Run unit tests only
# make coverage COVERAGE_THRESHOLD=90   # Generate coverage with 90% threshold

test: ##! Run all tests
	@echo "${BLUE}🧪 Running all tests...${NC}"
	@echo "[Running unit tests...]"
	@echo "[Running integration tests...]"
	@echo "${GREEN}✅ All tests passed!${NC}"

lint: ##! Run code linters
	@echo "${BLUE}🔍 Running linters...${NC}"
	@echo "[Checking code style...]"
	@echo "[Running ESLint/Pylint/Golint...]"
	@echo "${GREEN}✅ Code quality checks passed!${NC}"

unit: ## Run unit tests only
	@echo "${CYAN}🔬 Running unit tests...${NC}"
	@echo "[pytest tests/unit/ or npm test:unit]"
	@echo "${GREEN}✅ Unit tests completed!${NC}"

integration: ## Run integration tests
	@echo "${CYAN}🔗 Running integration tests...${NC}"
	@echo "[pytest tests/integration/ or npm test:integration]"
	@echo "${GREEN}✅ Integration tests completed!${NC}"

coverage: ## Generate test coverage report
	@echo "${BLUE}📊 Generating coverage report...${NC}"
	@echo "  Threshold: ${GREEN}$(COVERAGE_THRESHOLD)%${NC}"
	@echo ""
	@echo "[Running tests with coverage...]"
	@echo "[Coverage: 85.2%]"
	@echo "${GREEN}✅ Coverage report generated!${NC}"

.PHONY: test lint unit integration coverage
