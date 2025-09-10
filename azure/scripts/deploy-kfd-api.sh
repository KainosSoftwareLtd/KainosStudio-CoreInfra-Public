#!/bin/bash

# Deploy KFD Services API (AWS-Compatible)
# This script deploys only the KFD Services API to an existing API Management service

set -e

ENVIRONMENT=${1:-dev}
OPERATION=${2:-plan}

echo "🚀 Deploying KFD Services API (AWS-Compatible) for environment: $ENVIRONMENT"
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

# Run the specified operation with target for KFD Services API only
case $OPERATION in
    plan)
        echo "📝 Planning KFD Services API deployment..."
        terraform plan \
            -target="module.kfd_services_api" \
            -out="plan-kfd-api-${ENVIRONMENT}.tfplan"
        ;;
    apply)
        if [ -f "plan-kfd-api-${ENVIRONMENT}.tfplan" ]; then
            echo "🚀 Applying KFD Services API deployment from plan..."
            terraform apply "plan-kfd-api-${ENVIRONMENT}.tfplan"
        else
            echo "🚀 Applying KFD Services API deployment..."
            terraform apply \
                -target="module.kfd_services_api" \
                -auto-approve
        fi
        ;;
    destroy)
        echo "🗑️  Destroying KFD Services API..."
        terraform destroy \
            -target="module.kfd_services_api" \
            -auto-approve
        ;;
esac

echo "✅ KFD Services API $OPERATION completed for environment: $ENVIRONMENT"

# Show endpoint information after successful deployment
if [ "$OPERATION" = "apply" ]; then
    echo ""
    echo "🔗 AWS-Compatible Endpoints:"
    echo "   PUT /          - Upload files"
    echo "   DELETE /services/{id} - Delete files"
fi
