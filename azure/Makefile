# This Makefile is used to manage Terraform configurations and pre-commit hooks for different Azure environments.
# It supports the following actions:
#
# Actions:
#   init                Initialize Terraform and pre-commit dependencies
#   plan                Create Terraform plan
#   apply               Apply Terraform changes using the plan
#   destroy             Destroy Terraform infrastructure
#   fmt                 Format Terraform files
#   validate            Validate Terraform configuration
#   checkov             Run Checkov security scan
#   check               Run fmt, validate, and Checkov scan
#   test                Run deployment tests
#   pre-commit-install  Install pre-commit hooks
#   pre-commit-run      Run pre-commit hooks
#
# Environments:
#   dev                 Development environment (default)
#   staging             Staging environment
#   prod                Production environment
#   global              Global resources
#   rbac                RBAC resources
#
# Usage:
#   make <action> <env>
#
# Examples:
#   make init dev
#   make plan staging
#   make apply prod
#   make destroy dev
#   make check global
#   make test dev
#   make pre-commit-install
#   make pre-commit-run


ifneq ($(words $(MAKECMDGOALS)),0)
ACTION := $(firstword $(MAKECMDGOALS))
ENV := $(word 2, $(MAKECMDGOALS))
OPERATION := $(word 3, $(MAKECMDGOALS))
$(info Action: $(ACTION), Environment: $(ENV), Operation: $(OPERATION))
$(eval ENV=$(ENV))
$(eval OPERATION=$(OPERATION))
MAKECMDGOALS := $(ACTION)
endif

ENV ?= dev
OPERATION ?= plan

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

$(info Environment: $(ENV))

.PHONY: init plan apply destroy fmt validate checkov check test dev staging prod global rbac help pre-commit-install pre-commit-run deploy-apim-service deploy-core-api deploy-kfd-api

dev:
	@:

staging:
	@:

prod:
	@:

global:
	@:

rbac:
	@:

init: ## Initialize Terraform and pre-commit dependencies
	@echo "Initializing Terraform for Azure environment: $(ENV)"
	@if [ ! -d "$(DIR)/$(ENV)" ]; then \
		echo "Error: Environment directory '$(ENV)' does not exist"; \
		echo "Available environments: dev, staging, prod, global, rbac"; \
		exit 1; \
	fi
	terraform -chdir=$(DIR)/$(ENV) init
	@command -v pre-commit >/dev/null 2>&1 || { \
		echo "pre-commit not found. Installing pre-commit"; \
		pip install pre-commit; \
	}
	@echo "Updating and installing pre-commit hooks"
	pre-commit autoupdate
	pre-commit install
	pre-commit install --hook-type commit-msg

plan: ## Create Terraform plan
	@echo "Creating Terraform plan for Azure environment: $(ENV)"
	@if [ ! -d "$(DIR)/$(ENV)" ]; then \
		echo "Error: Environment directory '$(ENV)' does not exist"; \
		exit 1; \
	fi
	@if [ -z "$$ARM_SUBSCRIPTION_ID" ]; then \
		echo "Error: ARM_SUBSCRIPTION_ID environment variable is not set"; \
		echo "Run: export ARM_SUBSCRIPTION_ID=\$$(az account show --query id --output tsv)"; \
		echo "Or use: ./scripts/setup-azure-auth.sh"; \
		exit 1; \
	fi
	@echo "Using subscription: $$ARM_SUBSCRIPTION_ID"
	terraform -chdir=$(DIR)/$(ENV) plan -out=$(DIR)/$(ENV)/plan-$(ENV).tfplan

apply: ## Apply Terraform changes
	@echo "Applying Terraform plan for Azure environment: $(ENV)"
	@if [ ! -f "$(DIR)/$(ENV)/plan-$(ENV).tfplan" ]; then \
		echo "Error: No plan file found for $(ENV). Run 'make plan $(ENV)' first"; \
		exit 1; \
	fi
	@if [ -z "$$ARM_SUBSCRIPTION_ID" ]; then \
		echo "Error: ARM_SUBSCRIPTION_ID environment variable is not set"; \
		echo "Run: export ARM_SUBSCRIPTION_ID=\$$(az account show --query id --output tsv)"; \
		echo "Or use: ./scripts/setup-azure-auth.sh"; \
		exit 1; \
	fi
	@echo "Using subscription: $$ARM_SUBSCRIPTION_ID"
	terraform -chdir=$(DIR)/$(ENV) apply -auto-approve $(DIR)/$(ENV)/plan-$(ENV).tfplan

destroy: ## Destroy Terraform infrastructure
	@echo "WARNING: This will destroy all Azure infrastructure in $(ENV) environment!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		terraform -chdir=$(DIR)/$(ENV) destroy; \
	else \
		echo "Destruction cancelled"; \
	fi

fmt: ## Format Terraform files
	@echo "Formatting Terraform files for Azure environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) fmt -recursive

validate: ## Validate Terraform configuration
	@echo "Validating Terraform configuration for Azure environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) init -backend=false && terraform -chdir=$(DIR)/$(ENV) validate

checkov: ## Run Checkov security scan
	@echo "Running Checkov security scan for Azure environment: $(ENV)"
	zsh -i -c "checkov -d $(DIR)/$(ENV) --quiet --compact --config-file $(DIR)/checkov.yaml"

check: fmt validate checkov ## Run all checks (fmt, validate, checkov)
	@echo "Check completed: fmt, validate, and Checkov scan passed for Azure environment: $(ENV)"

test: ## Run deployment tests (only for dev environment)
	@echo "Running Azure deployment tests for environment: $(ENV)"
	@if [ "$(ENV)" != "dev" ]; then \
		echo "Warning: Deployment tests are currently only configured for dev environment"; \
	fi
	@if [ -f "$(DIR)/test-deployment.sh" ]; then \
		cd $(DIR)/$(ENV) && ../scripts/test-deployment.sh; \
	else \
		echo "Error: test-deployment.sh not found in $(DIR)"; \
		exit 1; \
	fi

pre-commit-install: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks"
	pre-commit install

pre-commit-run: ## Run pre-commit hooks
	@echo "Running pre-commit hooks"
	pre-commit run --all-files

help: ## Show this help message
	@echo "Usage: make <action> <env>"
	@echo ""
	@echo "Actions:"
	@echo "  init                Initialize Terraform and pre-commit dependencies"
	@echo "  plan                Create Terraform plan"
	@echo "  apply               Apply Terraform changes using the plan"
	@echo "  destroy             Destroy Terraform infrastructure"
	@echo "  fmt                 Format Terraform files"
	@echo "  validate            Validate Terraform configuration"
	@echo "  checkov             Run Checkov security scan"
	@echo "  check               Run fmt, validate, and Checkov scan"
	@echo "  test                Run deployment tests"
	@echo "  pre-commit-install  Install pre-commit hooks"
	@echo "  pre-commit-run      Run pre-commit hooks"
	@echo ""
	@echo "Environments:"
	@echo "  dev                 Development environment (default)"
	@echo "  staging             Staging environment"
	@echo "  prod                Production environment"
	@echo "  global              Global resources"
	@echo "  rbac                RBAC resources"
	@echo ""
	@echo "Examples:"
	@echo "  make init dev"
	@echo "  make plan staging"
	@echo "  make apply prod"
	@echo "  make destroy dev"
	@echo "  make check global"
	@echo "  make test dev"
	@echo "  make pre-commit-install"
	@echo "  make pre-commit-run"
	@echo ""
	@echo "Individual API Deployment:"
	@echo "  make deploy-apim-service <env> <operation>   Deploy API Management Service (plan/apply/destroy)"
	@echo "  make deploy-core-api <env> <operation>       Deploy Core API independently (plan/apply/destroy)"
	@echo "  make deploy-kfd-api <env> <operation>        Deploy KFD Services API independently (plan/apply/destroy)"
	@echo ""
	@echo "API Examples:"
	@echo "  make deploy-apim-service dev plan           Plan API Management Service deployment"
	@echo "  make deploy-core-api dev apply              Deploy Core API"
	@echo "  make deploy-kfd-api staging destroy         Remove KFD Services API"

# Individual API Management Deployments
deploy-apim-service: ## Deploy API Management Service independently
	@echo "Deploying API Management Service for environment: $(ENV)"
	@$(DIR)/scripts/deploy-apim-service.sh $(ENV) $(OPERATION)

deploy-core-api: ## Deploy Core API independently  
	@echo "Deploying Core API for environment: $(ENV)"
	@$(DIR)/scripts/deploy-core-api.sh $(ENV) $(OPERATION)

deploy-kfd-api: ## Deploy KFD Services API independently
	@echo "Deploying KFD Services API for environment: $(ENV)"
	@$(DIR)/scripts/deploy-kfd-api.sh $(ENV) $(OPERATION)
