.PHONY: help init plan apply destroy fmt validate checkov check test pre-commit-install pre-commit-run

# Environment (default to dev)
ENV ?= dev

# Help target
help:
	@echo "Available targets:"
	@echo "  init            - Initialize Terraform and pre-commit for dev environment"
	@echo "  plan            - Create a Terraform plan for dev environment"
	@echo "  apply           - Apply Terraform changes for dev environment"
	@echo "  destroy         - Destroy Terraform infrastructure for dev environment"
	@echo "  fmt             - Format Terraform files"
	@echo "  validate        - Validate Terraform configuration"
	@echo "  checkov         - Run Checkov security scan for dev environment"
	@echo "  check           - Run fmt, validate, and checkov"
	@echo "  test            - Run deployment tests"
	@echo "  pre-commit-install - Install pre-commit hooks"
	@echo "  pre-commit-run  - Run pre-commit hooks"
	@echo ""
	@echo "Examples:"
	@echo "  make init"
	@echo "  make plan"
	@echo "  make apply"

# Initialize Terraform backend and pre-commit
init:
	@echo "Initializing Terraform for dev environment..."
	terraform init
	@echo "Installing pre-commit hooks..."
	pre-commit install
	@echo "Initialization complete for dev environment"

# Create Terraform plan
plan:
	@echo "Creating Terraform plan for dev environment..."
	terraform plan -out=dev.tfplan

# Apply Terraform changes
apply:
	@if [ ! -f dev.tfplan ]; then \
		echo "Error: No plan file found. Run 'make plan' first"; \
		exit 1; \
	fi
	@echo "Applying Terraform changes for dev environment..."
	terraform apply dev.tfplan

# Destroy Terraform infrastructure
destroy:
	@echo "WARNING: This will destroy all infrastructure in dev environment!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		terraform destroy; \
	else \
		echo "Destruction cancelled"; \
	fi

# Format Terraform files
fmt:
	@echo "Formatting Terraform files..."
	terraform fmt -recursive .

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform init -backend=false && terraform validate

# Run Checkov security scan
checkov:
	@echo "Running Checkov security scan for dev environment..."
	checkov --config-file ../checkov.yaml --framework terraform -d .

# Run all checks
check: fmt validate checkov
	@echo "All checks completed for dev environment"

# Test deployment
test:
	@echo "Running deployment tests..."
	../test-deployment.sh

# Install pre-commit hooks
pre-commit-install:
	@echo "Installing pre-commit hooks..."
	pre-commit install

# Run pre-commit hooks
pre-commit-run:
	@echo "Running pre-commit hooks..."
	pre-commit run --all-files