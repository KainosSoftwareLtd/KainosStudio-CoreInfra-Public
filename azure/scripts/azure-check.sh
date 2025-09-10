#!/bin/bash

# Azure Configuration Check Script
echo "=========================================="
echo "         Azure Configuration Check        "
echo "=========================================="
echo

# Check if Azure CLI is installed
if command -v az &> /dev/null; then
    echo "✅ Azure CLI is installed"
    echo "📦 Azure CLI Version:"
    az version --output table 2>/dev/null || az --version
    echo
else
    echo "❌ Azure CLI is not installed"
    echo "   Install with: brew install azure-cli"
    echo
fi

# Display current Azure environment variables
echo "🔧 Azure Environment Variables:"
echo "   ARM_SUBSCRIPTION_ID: ${ARM_SUBSCRIPTION_ID:-'Not set'}"
echo "   ARM_TENANT_ID: ${ARM_TENANT_ID:-'Not set'}"
echo "   ARM_CLIENT_ID: ${ARM_CLIENT_ID:-'Not set'}"
echo "   ARM_CLIENT_SECRET: ${ARM_CLIENT_SECRET:-'Not set (hidden for security)'}"
echo "   AZURE_SUBSCRIPTION_ID: ${AZURE_SUBSCRIPTION_ID:-'Not set'}"
echo "   AZURE_TENANT_ID: ${AZURE_TENANT_ID:-'Not set'}"
echo "   AZURE_CLIENT_ID: ${AZURE_CLIENT_ID:-'Not set'}"
echo "   AZURE_CLIENT_SECRET: ${AZURE_CLIENT_SECRET:-'Not set (hidden for security)'}"
echo

# Check current Azure CLI login status
echo "🔐 Azure CLI Login Status:"
if az account show &> /dev/null; then
    echo "   Status: ✅ Logged in"
    echo "   Current Account:"
    az account show --query '{Name:name, SubscriptionId:id, TenantId:tenantId, User:user.name}' --output table
    echo
    
    echo "📋 Available Subscriptions:"
    az account list --query '[].{Name:name, SubscriptionId:id, IsDefault:isDefault}' --output table
else
    echo "   Status: ❌ Not logged in"
    echo "   Run 'az login' to authenticate"
fi

echo
echo "🛠️  Quick Commands:"
echo "   Login:           az login"
echo "   Set subscription: az account set --subscription <subscription-id>"
echo "   List accounts:   az account list"
echo "   Show current:    az account show"
echo "=========================================="
