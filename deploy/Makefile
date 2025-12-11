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
	@printf "${BLUE}🚀 Deploying application to Kubernetes...${NC}\n"
	@printf "  Cluster: ${GREEN}$(CLUSTER)${NC}\n"
	@printf "  Namespace: ${GREEN}$(NAMESPACE)${NC}\n"
	@printf "  Deployment: ${GREEN}$(DEPLOYMENT)${NC}\n"
	@printf "  Image Tag: ${GREEN}$(IMAGE_TAG)${NC}\n"
	@printf "\n"
	@printf "${YELLOW}[kubectl apply -f kubernetes.yaml -n $(NAMESPACE)]${NC}\n"
	@printf "${GREEN}✅ Deployment successful!${NC}\n"

rollback: ##! Rollback to previous deployment version
	@printf "${YELLOW}⏪ Rolling back deployment...${NC}\n"
	@printf "${YELLOW}[kubectl rollout undo deployment/$(DEPLOYMENT) -n $(NAMESPACE)]${NC}\n"
	@printf "${GREEN}✅ Rollback completed!${NC}\n"

delete: ## Delete Kubernetes deployment
	@printf "${RED}🗑️  Deleting deployment...${NC}\n"
	@printf "  Namespace: ${YELLOW}$(NAMESPACE)${NC}\n"
	@printf "  Deployment: ${YELLOW}$(DEPLOYMENT)${NC}\n"
	@printf "\n"
	@printf "${YELLOW}[kubectl delete deployment $(DEPLOYMENT) -n $(NAMESPACE)]${NC}\n"
	@printf "${GREEN}✅ Deployment deleted!${NC}\n"


##@ Monitoring

status: ##! Check deployment status
	@printf "${BLUE}📊 Checking deployment status...${NC}\n"
	@printf "${YELLOW}[kubectl get deployment $(DEPLOYMENT) -n $(NAMESPACE)]${NC}\n"
	@printf "\n"
	@printf "${CYAN}Pod Status:${NC}\n"
	@printf "${YELLOW}[kubectl get pods -l app=$(DEPLOYMENT) -n $(NAMESPACE)]${NC}\n"
	@printf "\n"
	@printf "${CYAN}Service Status:${NC}\n"
	@printf "${YELLOW}[kubectl get svc -l app=$(DEPLOYMENT) -n $(NAMESPACE)]${NC}\n"

logs: ## View pod logs
	@printf "${BLUE}📜 Fetching logs...${NC}\n"
	@printf "${YELLOW}[kubectl logs -f deployment/$(DEPLOYMENT) -n $(NAMESPACE)]${NC}\n"
	@printf "${CYAN}Streaming logs... (Press Ctrl+C to stop)${NC}\n"

##@ Validation

validate: ## Validate Kubernetes manifests
	@printf "${BLUE}✔️  Validating manifests...${NC}\n"
	@printf "${YELLOW}[kubectl apply -f kubernetes.yaml --validate=true --dry-run=client]${NC}\n"
	@printf "${GREEN}✅ Manifests are valid!${NC}\n"

.PHONY: deploy rollback delete status logs validate
