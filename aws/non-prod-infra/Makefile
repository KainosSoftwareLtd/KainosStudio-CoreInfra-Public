# This Makefile is used to manage Terraform configurations and pre-commit hooks for different environments.
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
#   pre-commit-install  Install pre-commit hooks
#   pre-commit-run      Run pre-commit hooks
#
# Environments:
#   dev                 Development environment (default)
#   staging             Staging environment
#   pipeline            Pipeline environment
#   prod                Production environment
#
# Usage:
#   make <action> <env>
#
# Examples:
#   make init dev
#   make plan staging
#   make apply pipeline
#   make destroy prod
#   make check dev
#   make pre-commit-install
#   make pre-commit-run


ifneq ($(words $(MAKECMDGOALS)),0)
ACTION := $(firstword $(MAKECMDGOALS))
ENV := $(word 2, $(MAKECMDGOALS))
$(info Action: $(ACTION), Environment: $(ENV))
$(eval ENV=$(ENV))
MAKECMDGOALS := $(ACTION)
endif

ENV ?= dev

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

BACKEND_CONFIG := ../tf-backends/backend-$(ENV).tf

$(info Environment: $(ENV))

.PHONY: init plan apply destroy fmt validate checkov check dev staging pipeline prod help pre-commit-install pre-commit-run

dev:
	@:

staging:
	@:

pipeline:
	@:

prod:
	@:

init: ## Initialize Terraform and pre-commit dependencies
	@echo "Initializing Terraform for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) init -backend-config=$(BACKEND_CONFIG)
	@if [ "$(CURRENT_TF_VERSION)" != "$(EXPECTED_TF_VERSION)" ]; then \
		tfenv install; \
		tfenv use; \
	fi
	@command -v pre-commit >/dev/null 2>&1 || { \
		echo "pre-commit not found. Installing pre-commit"; \
		pip install pre-commit; \
	}
	@echo "Updating and installing pre-commit hooks"
	pre-commit autoupdate
	pre-commit install
	pre-commit install --hook-type commit-msg

plan:
	@echo "Creating Terraform plan for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) plan -var="env=$(ENV)" -out=$(DIR)/$(ENV)/plan-$(ENV).tfplan

apply:
	@echo "Applying Terraform plan for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) apply -auto-approve $(DIR)/$(ENV)/plan-$(ENV).tfplan

destroy:
	@echo "Destroying Terraform infrastructure for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) destroy

fmt:
	@echo "Formatting Terraform files for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) fmt

validate:
	@echo "Validating Terraform configuration for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) validate

checkov:
	@echo "Running Checkov security scan for environment: $(ENV)"
	checkov -d $(DIR)/$(ENV) --quiet --compact --config-file checkov.yaml

check: fmt validate checkov
	@echo "Check completed: fmt, validate, and Checkov scan passed for environment: $(ENV)"

pre-commit-install:
	@echo "Installing pre-commit hooks"
	pre-commit install

pre-commit-run:
	@echo "Running pre-commit hooks"
	pre-commit run --all-files

help:
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
	@echo "  pre-commit-install  Install pre-commit hooks"
	@echo "  pre-commit-run      Run pre-commit hooks"
	@echo ""
	@echo "Environments:"
	@echo "  dev                 Development environment (default)"
	@echo "  staging             Staging environment"
	@echo "  pipeline            Pipeline environment"
	@echo "  prod                Production environment"
	@echo ""
	@echo "Examples:"
	@echo "  make init dev"
	@echo "  make plan staging"
	@echo "  make apply pipeline"
	@echo "  make destroy prod"
	@echo "  make check dev"
	@echo "  make pre-commit-install"
	@echo "  make pre-commit-run"
