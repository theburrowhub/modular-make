# Docker Makefile

# Include centralized color definitions
-include ../.make/colors.mk

# Default values
IMAGE_NAME ?= myapp
TAG ?= latest

##? Examples:
# make build                            # Build Docker image with default tag
# make build TAG=v1.2.3                 # Build with specific version tag
# make run IMAGE_NAME=backend           # Run backend container
# make docker-clean                     # Clean Docker resources

build: ##! Build Docker image
	@printf "${BLUE}🐳 Building Docker image...${NC}\n"
	@printf "[docker build -t $(IMAGE_NAME):$(TAG) .]\n"
	@printf "${GREEN}✅ Image built successfully!${NC}\n"

run: ##! Run Docker container
	@printf "${BLUE}🚀 Running container...${NC}\n"
	@printf "[docker run -d $(IMAGE_NAME):$(TAG)]\n"
	@printf "${GREEN}✅ Container started!${NC}\n"

stop: ## Stop running containers
	@printf "${BLUE}⏹ Stopping containers...${NC}\n"
	@printf "[docker stop $$(docker ps -q)]\n"
	@printf "${GREEN}✅ Containers stopped!${NC}\n"

docker-clean: ## Remove Docker images and containers
	@printf "${BLUE}🧹 Cleaning Docker resources...${NC}\n"
	@printf "[docker system prune -f]\n"
	@printf "${GREEN}✅ Cleanup completed!${NC}\n"

.PHONY: build run stop docker-clean
