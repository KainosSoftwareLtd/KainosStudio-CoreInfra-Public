# Makefile for managing Terraform environments with pre-commit hooks
# This Makefile supports multiple environments and includes pre-commit hooks for code quality checks.
# It also integrates Checkov for security scanning of Terraform configurations.
# Usage: make <action> <env>
# Actions: init, plan, apply, destroy, fmt, validate, checkov, check, pre-commit-install, pre-commit-run
# Environments: global, prod, prod-rds-conf, roles

DEFAULT_GOAL := help

ifneq ($(words $(MAKECMDGOALS)),0)
ACTION := $(firstword $(MAKECMDGOALS))
ENV := $(word 2, $(MAKECMDGOALS))
$(info Action: $(ACTION), Environment: $(ENV))
$(eval ENV=$(ENV))
MAKECMDGOALS := $(ACTION)
endif

ENV ?= global

DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

BACKEND_CONFIG := ../tf-backends/backend-$(ENV).tf

$(info Environment: $(ENV))

.PHONY: init plan apply destroy fmt validate checkov check global prod prod-rds-conf roles help pre-commit-install pre-commit-run

global:
	@:

prod:
	@:

prod-rds-conf:
	@:

roles:
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
		if command -v pip3 >/dev/null 2>&1; then \
			echo "Using pip3 to install pre-commit"; \
			pip3 install pre-commit; \
		elif command -v pip >/dev/null 2>&1; then \
			echo "Using pip to install pre-commit"; \
			pip install pre-commit; \
		else \
			echo "pip or pip3 not found. Please install pre-commit manually."; \
			exit 1; \
		fi; \
		echo "pre-commit installed successfully"; \
	}
	@echo "Updating and installing pre-commit hooks"
	pre-commit autoupdate
	pre-commit install
	pre-commit install --hook-type commit-msg

plan:
	@echo "Creating Terraform plan for environment: $(ENV)"
	terraform -chdir=$(DIR)/$(ENV) plan -out=$(DIR)/$(ENV)/plan-$(ENV).tfplan

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
	checkov -d $(DIR)/$(ENV) --quiet --config-file checkov.yaml

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
	@echo "  global              Global shared resources (default)"
	@echo "  prod                Production environment"
	@echo "  prod-rds-conf       Production RDS configuration"
	@echo "  roles               IAM roles and permissions"
	@echo ""
	@echo "Examples:"
	@echo "  make init global"
	@echo "  make plan prod"
	@echo "  make apply prod-rds-conf"
	@echo "  make destroy prod"
	@echo "  make check roles"
	@echo "  make pre-commit-install"
	@echo "  make pre-commit-run"