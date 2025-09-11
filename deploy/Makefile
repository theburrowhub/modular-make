# Include centralized color definitions
-include ../.make/colors.mk

# Default values
NAMESPACE ?= default
DEPLOYMENT ?= my-app
REPLICAS ?= 3
IMAGE_TAG ?= latest
CLUSTER ?= production
KUBECONFIG ?= ~/.kube/config

##? Examples:
# make deploy                           # Deploy to default namespace
# make deploy NAMESPACE=staging         # Deploy to staging namespace
# make rollback                         # Rollback to previous version
# make status DEPLOYMENT=api-server     # Check status of api-server

##@ Core Operations

deploy: ##! Deploy application to Kubernetes cluster
	@echo "${BLUE}🚀 Deploying application to Kubernetes...${NC}"
	@echo "  Cluster: ${GREEN}$(CLUSTER)${NC}"
	@echo "  Namespace: ${GREEN}$(NAMESPACE)${NC}"
	@echo "  Deployment: ${GREEN}$(DEPLOYMENT)${NC}"
	@echo "  Image Tag: ${GREEN}$(IMAGE_TAG)${NC}"
	@echo ""
	@echo "${YELLOW}[kubectl apply -f kubernetes.yaml -n $(NAMESPACE)]${NC}"
	@echo "${GREEN}✅ Deployment successful!${NC}"

rollback: ##! Rollback to previous deployment version
	@echo "${YELLOW}⏪ Rolling back deployment...${NC}"
	@echo "${YELLOW}[kubectl rollout undo deployment/$(DEPLOYMENT) -n $(NAMESPACE)]${NC}"
	@echo "${GREEN}✅ Rollback completed!${NC}"

delete: ## Delete Kubernetes deployment
	@echo "${RED}🗑️  Deleting deployment...${NC}"
	@echo "  Namespace: ${YELLOW}$(NAMESPACE)${NC}"
	@echo "  Deployment: ${YELLOW}$(DEPLOYMENT)${NC}"
	@echo ""
	@echo "${YELLOW}[kubectl delete deployment $(DEPLOYMENT) -n $(NAMESPACE)]${NC}"
	@echo "${GREEN}✅ Deployment deleted!${NC}"


##@ Monitoring

status: ##! Check deployment status
	@echo "${BLUE}📊 Checking deployment status...${NC}"
	@echo "${YELLOW}[kubectl get deployment $(DEPLOYMENT) -n $(NAMESPACE)]${NC}"
	@echo ""
	@echo "${CYAN}Pod Status:${NC}"
	@echo "${YELLOW}[kubectl get pods -l app=$(DEPLOYMENT) -n $(NAMESPACE)]${NC}"
	@echo ""
	@echo "${CYAN}Service Status:${NC}"
	@echo "${YELLOW}[kubectl get svc -l app=$(DEPLOYMENT) -n $(NAMESPACE)]${NC}"

logs: ## View pod logs
	@echo "${BLUE}📜 Fetching logs...${NC}"
	@echo "${YELLOW}[kubectl logs -f deployment/$(DEPLOYMENT) -n $(NAMESPACE)]${NC}"
	@echo "${CYAN}Streaming logs... (Press Ctrl+C to stop)${NC}"

##@ Validation

validate: ## Validate Kubernetes manifests
	@echo "${BLUE}✔️  Validating manifests...${NC}"
	@echo "${YELLOW}[kubectl apply -f kubernetes.yaml --validate=true --dry-run=client]${NC}"
	@echo "${GREEN}✅ Manifests are valid!${NC}"

.PHONY: deploy rollback delete status logs validate
