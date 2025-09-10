#!/bin/bash

# Deploy API Management Service (Base Infrastructure)
# This script deploys only the base API Management service without any APIs

set -e

ENVIRONMENT=${1:-dev}
OPERATION=${2:-plan}

echo "🚀 Deploying API Management Service for environment: $ENVIRONMENT"
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

# Run the specified operation with target for API Management Service only
case $OPERATION in
    plan)
        echo "📝 Planning API Management Service deployment..."
        terraform plan \
            -target="module.api_management_service" \
            -out="plan-apim-service-${ENVIRONMENT}.tfplan"
        ;;
    apply)
        if [ -f "plan-apim-service-${ENVIRONMENT}.tfplan" ]; then
            echo "🚀 Applying API Management Service deployment from plan..."
            terraform apply "plan-apim-service-${ENVIRONMENT}.tfplan"
        else
            echo "🚀 Applying API Management Service deployment..."
            terraform apply \
                -target="module.api_management_service" \
                -auto-approve
        fi
        ;;
    destroy)
        echo "🗑️  Destroying API Management Service..."
        terraform destroy \
            -target="module.api_management_service" \
            -auto-approve
        ;;
esac

echo "✅ API Management Service $OPERATION completed for environment: $ENVIRONMENT"
