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
	@printf "${BLUE}🧪 Running all tests...${NC}\n"
	@printf "[Running unit tests...]\n"
	@printf "[Running integration tests...]\n"
	@printf "${GREEN}✅ All tests passed!${NC}\n"

lint: ##! Run code linters
	@printf "${BLUE}🔍 Running linters...${NC}\n"
	@printf "[Checking code style...]\n"
	@printf "[Running ESLint/Pylint/Golint...]\n"
	@printf "${GREEN}✅ Code quality checks passed!${NC}\n"

unit: ## Run unit tests only
	@printf "${CYAN}🔬 Running unit tests...${NC}\n"
	@printf "[pytest tests/unit/ or npm test:unit]\n"
	@printf "${GREEN}✅ Unit tests completed!${NC}\n"

integration: ## Run integration tests
	@printf "${CYAN}🔗 Running integration tests...${NC}\n"
	@printf "[pytest tests/integration/ or npm test:integration]\n"
	@printf "${GREEN}✅ Integration tests completed!${NC}\n"

coverage: ## Generate test coverage report
	@printf "${BLUE}📊 Generating coverage report...${NC}\n"
	@printf "  Threshold: ${GREEN}$(COVERAGE_THRESHOLD)%%${NC}\n"
	@printf "\n"
	@printf "[Running tests with coverage...]\n"
	@printf "[Coverage: 85.2%%]\n"
	@printf "${GREEN}✅ Coverage report generated!${NC}\n"

.PHONY: test lint unit integration coverage
