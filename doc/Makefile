# Documentation Makefile

# Include centralized color definitions
-include ../.make/colors.mk

##? Examples:
# make generate                         # Generate API documentation
# make serve                            # Start local documentation server
# make doc-clean                        # Clean generated documentation

generate: ##! Generate API documentation
	@printf "${GREEN}📚 Generating API documentation...${NC}\n"
	@printf "[Converting api-spec.yaml to HTML documentation]\n"
	@printf "Documentation generated!\n"

serve: ##! Serve documentation locally
	@printf "${GREEN}🌐 Starting documentation server...${NC}\n"
	@printf "[Starting local server on http://localhost:8080/docs]\n"
	@printf "Documentation server running!\n"

doc-clean: ## Clean generated documentation
	@printf "${GREEN}🧹 Cleaning generated docs...${NC}\n"
	@printf "[Removing build/, dist/ directories]\n"
	@printf "Cleaned!\n"

.PHONY: generate serve doc-clean
