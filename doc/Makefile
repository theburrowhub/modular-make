# Documentation Makefile

# Include centralized color definitions
-include ../.make/colors.mk

##? Examples:
# make generate                         # Generate API documentation
# make serve                            # Start local documentation server
# make doc-clean                        # Clean generated documentation

generate: ##! Generate API documentation
	@echo "${GREEN}📚 Generating API documentation...${NC}"
	@echo "[Converting api-spec.yaml to HTML documentation]"
	@echo "Documentation generated!"

serve: ##! Serve documentation locally
	@echo "${GREEN}🌐 Starting documentation server...${NC}"
	@echo "[Starting local server on http://localhost:8080/docs]"
	@echo "Documentation server running!"

doc-clean: ## Clean generated documentation
	@echo "${GREEN}🧹 Cleaning generated docs...${NC}"
	@echo "[Removing build/, dist/ directories]"
	@echo "Cleaned!"

.PHONY: generate serve doc-clean
