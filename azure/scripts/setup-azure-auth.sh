#!/bin/bash
set -e

# Azure CLI Setup and Validation Script for Terraform
# This script helps configure Azure authentication for Terraform deployment

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔐 Azure CLI Setup for Terraform Deployment${NC}"
echo "=================================================="

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI not found. Please install it first:${NC}"
    echo ""
    echo "macOS:   brew install azure-cli"
    echo "Windows: winget install Microsoft.AzureCLI"
    echo "Linux:   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Azure CLI found: $(az version --query \"azure-cli\" --output tsv)${NC}"

# Check if logged in
if ! az account show &>/dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Azure. Starting login process...${NC}"
    az login
else
    echo -e "${GREEN}✅ Already logged in to Azure${NC}"
fi

# Show current account
CURRENT_USER=$(az account show --query user.name --output tsv)
CURRENT_SUBSCRIPTION=$(az account show --query name --output tsv)
CURRENT_TENANT=$(az account show --query tenantId --output tsv)

echo -e "${BLUE}📋 Current Azure Configuration:${NC}"
echo "User: $CURRENT_USER"
echo "Subscription: $CURRENT_SUBSCRIPTION"
echo "Tenant: $CURRENT_TENANT"
echo ""

# List available subscriptions
echo -e "${BLUE}📋 Available Subscriptions:${NC}"
az account list --query "[].{Name:name, Id:id, IsDefault:isDefault}" --output table
echo ""

# Ask if user wants to change subscription
read -p "Do you want to change the active subscription? (y/N): " change_sub
if [[ $change_sub =~ ^[Yy]$ ]]; then
    echo "Enter subscription name or ID:"
    read subscription_input
    az account set --subscription "$subscription_input"
    echo -e "${GREEN}✅ Subscription changed to: $(az account show --query name --output tsv)${NC}"
fi

# Set ARM_SUBSCRIPTION_ID environment variable for Terraform
SUBSCRIPTION_ID=$(az account show --query id --output tsv)

echo -e "${BLUE}🔐 Setting up Terraform authentication...${NC}"
echo "ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: You must export this variable in your shell before running Terraform!${NC}"
echo -e "${YELLOW}Run this command in your terminal:${NC}"
echo -e "\n${BLUE}export ARM_SUBSCRIPTION_ID=\"$SUBSCRIPTION_ID\"${NC}\n"

# Validate access to required resources
echo -e "${BLUE}🔍 Validating access to required Azure resources...${NC}"

# Check Terraform state storage access
if az storage account show --name kainoscoreterraformsa --resource-group kainoscore-terraform-rg &>/dev/null; then
    echo -e "${GREEN}✅ Access to Terraform state storage account confirmed${NC}"
else
    echo -e "${RED}❌ Cannot access Terraform state storage account 'kainoscoreterraformsa'${NC}"
    echo "Required permissions: Storage Blob Data Contributor"
fi

# Check deployment container access
if az storage container show --account-name kainoscoreterraformsa --name deployment-packages --auth-mode login &>/dev/null; then
    echo -e "${GREEN}✅ Access to deployment-packages container confirmed${NC}"
else
    echo -e "${YELLOW}⚠️  Limited access to deployment-packages container${NC}"
    echo "This may affect function app deployments"
fi

# Check role assignments
echo -e "${BLUE}🔍 Checking role assignments...${NC}"
ROLES=$(az role assignment list --assignee "$CURRENT_USER" --query "[].roleDefinitionName" --output tsv | sort | uniq)
echo "Your assigned roles:"
while read -r role; do
    if [[ "$role" == *"Contributor"* ]] || [[ "$role" == *"Owner"* ]]; then
        echo -e "${GREEN}✅ $role${NC}"
    else
        echo -e "${YELLOW}📋 $role${NC}"
    fi
done <<< "$ROLES"

# Check if user has sufficient permissions
if echo "$ROLES" | grep -q -E "(Contributor|Owner)"; then
    echo -e "${GREEN}✅ Sufficient permissions for Terraform deployment${NC}"
else
    echo -e "${YELLOW}⚠️  You may need additional permissions for full deployment${NC}"
    echo "Required roles: Contributor or Owner on subscription/resource groups"
fi

# Test Terraform authentication
echo -e "${BLUE}🔍 Testing Terraform authentication...${NC}"
# cd "$(dirname "$0")/dev"  # Disabled to prevent shell switching when sourcing

if terraform version &>/dev/null; then
    echo -e "${GREEN}✅ Terraform found: $(terraform version | head -n1)${NC}"
    
    if terraform init &>/dev/null; then
        echo -e "${GREEN}✅ Terraform initialized successfully${NC}"
        
        if terraform plan -refresh-only &>/dev/null; then
            echo -e "${GREEN}✅ Terraform can authenticate with Azure${NC}"
        else
            echo -e "${YELLOW}⚠️  Terraform authentication test failed${NC}"
            echo "This may be expected if resources don't exist yet"
        fi
    else
        echo -e "${RED}❌ Terraform initialization failed${NC}"
        echo "Check your backend configuration"
    fi
else
    echo -e "${YELLOW}⚠️  Terraform not found. Install from: https://terraform.io${NC}"
fi

# Summary and next steps
echo ""
echo -e "${BLUE}📋 Setup Summary:${NC}"
echo -e "${GREEN}✅ Azure CLI configured and authenticated${NC}"
echo -e "${GREEN}✅ Connected to subscription: $CURRENT_SUBSCRIPTION${NC}"
echo -e "${GREEN}✅ ARM_SUBSCRIPTION_ID environment variable set${NC}"
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "1. Add to your shell profile:    export ARM_SUBSCRIPTION_ID=\"$SUBSCRIPTION_ID\""
echo "2. Deploy global environment:    cd azure/global && terraform apply"
echo "3. Deploy RBAC environment:      cd azure/rbac && terraform apply"
echo "4. Deploy dev environment:       cd azure/dev && terraform apply"
echo "5. Upload function packages:     See BLOB_DEPLOYMENT.md for details"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
echo "- Your Azure CLI session will expire after some time"
echo "- Run 'az login' again if you get authentication errors"
echo "- The ARM_SUBSCRIPTION_ID environment variable is required for Terraform"
echo "- Use 'az account set --subscription NAME' to switch subscriptions"
echo "- Check 'az account show' to verify your current context"
