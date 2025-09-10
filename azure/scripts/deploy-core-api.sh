#!/bin/bash

# Deploy Core API
# This script deploys only the Core API to an existing API Management service

set -e

ENVIRONMENT=${1:-dev}
OPERATION=${2:-plan}

echo "🚀 Deploying Core API for environment: $ENVIRONMENT"
echo "🔧 Operation: $OPERATION"

# Validate parameters
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo "❌ Error: Environment must be one of: dev, staging, prod"
    exit 1
fi

if [[ ! "$OPERATION" =~ ^(plan|apply|destroy)$ ]]; then
    echo "❌ Error: Operation must be one of: plan, apply, destroy"
    exit 1
fi

# Change to the environment directory
cd "$(dirname "$0")/../$ENVIRONMENT"

# Initialize Terraform
echo "📋 Initializing Terraform..."
terraform init -upgrade

# Run the specified operation with target for Core API only
case $OPERATION in
    plan)
        echo "📝 Planning Core API deployment..."
        terraform plan \
            -target="module.core_api" \
            -out="plan-core-api-${ENVIRONMENT}.tfplan"
        ;;
    apply)
        if [ -f "plan-core-api-${ENVIRONMENT}.tfplan" ]; then
            echo "🚀 Applying Core API deployment from plan..."
            terraform apply "plan-core-api-${ENVIRONMENT}.tfplan"
        else
            echo "🚀 Applying Core API deployment..."
            terraform apply \
                -target="module.core_api" \
                -auto-approve
        fi
        ;;
    destroy)
        echo "🗑️  Destroying Core API..."
        terraform destroy \
            -target="module.core_api" \
            -auto-approve
        ;;
esac

echo "✅ Core API $OPERATION completed for environment: $ENVIRONMENT"
