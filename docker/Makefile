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
	@echo "${BLUE}🐳 Building Docker image...${NC}"
	@echo "[docker build -t $(IMAGE_NAME):$(TAG) .]"
	@echo "${GREEN}✅ Image built successfully!${NC}"

run: ##! Run Docker container
	@echo "${BLUE}🚀 Running container...${NC}"
	@echo "[docker run -d $(IMAGE_NAME):$(TAG)]"
	@echo "${GREEN}✅ Container started!${NC}"

stop: ## Stop running containers
	@echo "${BLUE}⏹ Stopping containers...${NC}"
	@echo "[docker stop $(docker ps -q)]"
	@echo "${GREEN}✅ Containers stopped!${NC}"

docker-clean: ## Remove Docker images and containers
	@echo "${BLUE}🧹 Cleaning Docker resources...${NC}"
	@echo "[docker system prune -f]"
	@echo "${GREEN}✅ Cleanup completed!${NC}"

.PHONY: build run stop docker-clean
