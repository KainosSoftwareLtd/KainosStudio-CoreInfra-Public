#!/bin/bash

# Migration script to move static files from blob container to static website hosting
# This script migrates your existing static files to the $web container for optimal CDN delivery

STORAGE_ACCOUNT="kainoscorestaticdev"
SOURCE_CONTAINER="static-files"
TARGET_CONTAINER='$web'

echo "🚀 Azure Static Website Migration Script"
echo "========================================"
echo "Storage Account: $STORAGE_ACCOUNT"
echo "Source Container: $SOURCE_CONTAINER"
echo "Target Container: $TARGET_CONTAINER"
echo ""

# Step 1: Enable static website hosting
echo "📝 Step 1: Enabling static website hosting..."
az storage blob service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --static-website \
  --index-document index.html \
  --404-document 404.html

if [ $? -eq 0 ]; then
    echo "✅ Static website hosting enabled successfully"
else
    echo "❌ Failed to enable static website hosting"
    exit 1
fi

# Step 2: Check if $web container was created
echo ""
echo "📋 Step 2: Verifying $web container creation..."
az storage container show \
  --account-name $STORAGE_ACCOUNT \
  --name '$web' \
  --auth-mode login > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ $web container exists and is accessible"
else
    echo "❌ $web container not found or not accessible"
    echo "This might be expected if static website hosting just got enabled"
fi

# Step 3: List current files in source container
echo ""
echo "📂 Step 3: Checking current files in source container..."
echo "Files in $SOURCE_CONTAINER:"
az storage blob list \
  --account-name $STORAGE_ACCOUNT \
  --container-name $SOURCE_CONTAINER \
  --auth-mode login \
  --output table

# Step 4: Copy files from source container to $web container
echo ""
echo "📦 Step 4: Copying files to $web container..."
echo "This will preserve your folder structure (assets/, public/)"

# Get list of blobs and copy them
BLOB_LIST=$(az storage blob list \
  --account-name $STORAGE_ACCOUNT \
  --container-name $SOURCE_CONTAINER \
  --auth-mode login \
  --query '[].name' \
  --output tsv)

if [ -z "$BLOB_LIST" ]; then
    echo "⚠️  No files found in source container $SOURCE_CONTAINER"
    echo "You may need to upload your static files first"
else
    echo "Copying files..."
    while IFS= read -r blob_name; do
        if [ ! -z "$blob_name" ]; then
            echo "  Copying: $blob_name"
            
            # Copy blob from source container to $web container
            az storage blob copy start \
              --account-name $STORAGE_ACCOUNT \
              --destination-blob "$blob_name" \
              --destination-container '$web' \
              --source-uri "https://$STORAGE_ACCOUNT.blob.core.windows.net/$SOURCE_CONTAINER/$blob_name" \
              --auth-mode login
            
            if [ $? -eq 0 ]; then
                echo "    ✅ Copied successfully"
            else
                echo "    ❌ Failed to copy $blob_name"
            fi
        fi
    done <<< "$BLOB_LIST"
fi

# Step 5: Verify files in $web container
echo ""
echo "🔍 Step 5: Verifying files in $web container..."
az storage blob list \
  --account-name $STORAGE_ACCOUNT \
  --container-name '$web' \
  --auth-mode login \
  --output table

# Step 6: Get static website endpoint
echo ""
echo "🌐 Step 6: Getting static website endpoint..."
STATIC_WEBSITE_URL=$(az storage account show \
  --name $STORAGE_ACCOUNT \
  --query 'primaryEndpoints.web' \
  --output tsv)

echo "Static Website Endpoint: $STATIC_WEBSITE_URL"

# Step 7: Test a sample file
echo ""
echo "🧪 Step 7: Testing static website access..."
echo "You can test your static website at:"
echo "  Main endpoint: $STATIC_WEBSITE_URL"
echo "  Example asset: ${STATIC_WEBSITE_URL}assets/your-file.png"
echo "  Example public: ${STATIC_WEBSITE_URL}public/your-file.css"

# Step 8: CDN Configuration Info
echo ""
echo "⚙️  Step 8: CDN Configuration Update Needed"
echo "============================================="
echo "Your CDN should now point to the static website endpoint:"
echo "  Current blob endpoint: $STORAGE_ACCOUNT.blob.core.windows.net"
echo "  New static website endpoint: $(echo $STATIC_WEBSITE_URL | sed 's|https://||')"
echo ""
echo "The CDN is already configured correctly in your Terraform:"
echo "  static_origin_host = module.static_storage.storage_account_primary_web_host"
echo ""
echo "This will automatically use: $(echo $STATIC_WEBSITE_URL | sed 's|https://||' | sed 's|/||')"

# Step 9: Next Steps
echo ""
echo "🎯 Next Steps:"
echo "=============="
echo "1. Run: terraform apply -var-file=terraform.tfvars"
echo "2. Test CDN endpoints for your static files"
echo "3. Update your application to use CDN URLs"
echo "4. Optionally remove old static-files container when confirmed working"
echo ""
echo "🔗 CDN Endpoints (after terraform apply):"
echo "  API CDN: https://api-cdn-endpoint.azureedge.net"
echo "  Static CDN: https://static-cdn-endpoint.azureedge.net"
echo ""
echo "✨ Migration completed successfully!"
