# Networking Guide

This guide provides comprehensive networking architecture details for the Kainos Studio infrastructure, covering VPC/VNet design, subnetting, routing, firewalls, and private endpoints.

## 🌐 Network Architecture Overview

The Kainos Studio infrastructure implements a multi-tier network architecture with strict security boundaries and optimized routing for serverless workloads.

## 🟠 AWS Network Architecture

### VPC Design

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **VPC CIDR** | 10.0.0.0/16 | Main network space |
| **Availability Zones** | 3 AZs minimum | High availability |
| **DNS Resolution** | Enabled | Service discovery |
| **DNS Hostnames** | Enabled | Resource naming |

#### VPC Configuration
```hcl
resource "aws_vpc" "kainos_core" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "kainos-core-vpc-${var.environment}"
    Environment = var.environment
  }
}
```

### Subnet Architecture

| Subnet Type | CIDR Blocks | Purpose | Internet Access |
|-------------|-------------|---------|-----------------|
| **Public Subnets** | 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 | NAT Gateways, Load Balancers | Direct |
| **Private Subnets** | 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24 | Lambda functions, RDS | Via NAT |
| **Database Subnets** | 10.0.21.0/24, 10.0.22.0/24, 10.0.23.0/24 | Database instances | None |

#### Subnet Configuration
```hcl
# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.kainos_core.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = var.availability_zones[count.index]
  
  map_public_ip_on_launch = true
  
  tags = {
    Name = "kainos-core-public-${count.index + 1}-${var.environment}"
    Type = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.kainos_core.id
  cidr_block        = "10.0.${count.index + 11}.0/24"
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "kainos-core-private-${count.index + 1}-${var.environment}"
    Type = "Private"
  }
}
```

### Routing Configuration

| Route Table | Associated Subnets | Default Route | Purpose |
|-------------|-------------------|---------------|---------|
| **Public RT** | Public subnets | Internet Gateway | Internet access |
| **Private RT** | Private subnets | NAT Gateway | Outbound internet |
| **Database RT** | Database subnets | None | Isolated |

#### Route Table Configuration
```hcl
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.kainos_core.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "kainos-core-public-rt-${var.environment}"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.kainos_core.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  
  tags = {
    Name = "kainos-core-private-rt-${count.index + 1}-${var.environment}"
  }
}
```

### Security Groups

| Security Group | Purpose | Inbound Rules | Outbound Rules |
|----------------|---------|---------------|----------------|
| **Lambda SG** | Lambda functions | None | HTTPS (443), HTTP (80) |
| **RDS SG** | Database access | MySQL/PostgreSQL from Lambda SG | None |
| **VPC Endpoint SG** | VPC endpoints | HTTPS from VPC CIDR | None |

#### Security Group Configuration
```hcl
# Lambda Security Group
resource "aws_security_group" "lambda" {
  name_prefix = "kainos-core-lambda-"
  vpc_id      = aws_vpc.kainos_core.id
  
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "kainos-core-lambda-sg-${var.environment}"
  }
}
```

### VPC Endpoints

| Endpoint Type | Service | Purpose | Interface Type |
|---------------|---------|---------|----------------|
| **Gateway** | S3 | S3 access without internet | Gateway |
| **Gateway** | DynamoDB | DynamoDB access | Gateway |
| **Interface** | Secrets Manager | Secrets access | Interface |
| **Interface** | KMS | Key management | Interface |

#### VPC Endpoint Configuration
```hcl
# S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.kainos_core.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  
  route_table_ids = aws_route_table.private[*].id
  
  tags = {
    Name = "kainos-core-s3-endpoint-${var.environment}"
  }
}

# Secrets Manager VPC Endpoint
resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id              = aws_vpc.kainos_core.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  
  tags = {
    Name = "kainos-core-secrets-endpoint-${var.environment}"
  }
}
```

## 🔵 Azure Network Architecture

### Virtual Network Design

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **VNet CIDR** | 10.1.0.0/16 | Main network space |
| **Regions** | Primary + Secondary | Disaster recovery |
| **DNS** | Azure-provided | Service resolution |

#### VNet Configuration
```hcl
resource "azurerm_virtual_network" "kainos_core" {
  name                = "kainos-core-vnet-${var.environment}"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  
  tags = {
    Environment = var.environment
    Project     = "kainos-studio"
  }
}
```

### Subnet Architecture

| Subnet Type | Address Space | Purpose | Service Delegation |
|-------------|---------------|---------|-------------------|
| **Function Subnet** | 10.1.1.0/24 | Function Apps | Microsoft.Web/serverFarms |
| **Database Subnet** | 10.1.2.0/24 | Cosmos DB, SQL | None |
| **Private Endpoint Subnet** | 10.1.3.0/24 | Private endpoints | None |
| **Gateway Subnet** | 10.1.255.0/27 | VPN/ExpressRoute | None |

#### Subnet Configuration
```hcl
# Function App Subnet
resource "azurerm_subnet" "function_app" {
  name                 = "kainos-core-function-subnet-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.kainos_core.name
  address_prefixes     = ["10.1.1.0/24"]
  
  delegation {
    name = "function-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

# Private Endpoint Subnet
resource "azurerm_subnet" "private_endpoint" {
  name                 = "kainos-core-pe-subnet-${var.environment}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.kainos_core.name
  address_prefixes     = ["10.1.3.0/24"]
  
  private_endpoint_network_policies_enabled = false
}
```

### Network Security Groups

| NSG | Purpose | Inbound Rules | Outbound Rules |
|-----|---------|---------------|----------------|
| **Function NSG** | Function Apps | HTTPS (443) | All outbound |
| **Database NSG** | Database access | From Function subnet | None |
| **PE NSG** | Private endpoints | From VNet | None |

#### NSG Configuration
```hcl
resource "azurerm_network_security_group" "function_app" {
  name                = "kainos-core-function-nsg-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = {
    Environment = var.environment
  }
}
```

### Private Endpoints

| Service | Private Endpoint | Purpose | DNS Zone |
|---------|------------------|---------|----------|
| **Storage Account** | PE for blobs | Secure storage access | privatelink.blob.core.windows.net |
| **Key Vault** | PE for secrets | Secure key access | privatelink.vaultcore.azure.net |
| **Cosmos DB** | PE for database | Secure DB access | privatelink.documents.azure.com |

#### Private Endpoint Configuration
```hcl
resource "azurerm_private_endpoint" "storage" {
  name                = "kainos-core-storage-pe-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id
  
  private_service_connection {
    name                           = "storage-connection"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  
  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }
}
```

## 🔥 Firewall and Security

### AWS Network ACLs

| NACL | Subnet Association | Inbound Rules | Outbound Rules |
|------|-------------------|---------------|----------------|
| **Public NACL** | Public subnets | HTTP/HTTPS, SSH (restricted) | All traffic |
| **Private NACL** | Private subnets | From VPC CIDR | HTTPS, DNS |
| **Database NACL** | Database subnets | From private subnets | Response traffic |

#### NACL Configuration
```hcl
resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.kainos_core.id
  subnet_ids = aws_subnet.private[*].id
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 443
    to_port    = 443
  }
  
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  
  tags = {
    Name = "kainos-core-private-nacl-${var.environment}"
  }
}
```

### Azure Firewall (Optional)

| Component | Configuration | Purpose |
|-----------|---------------|---------|
| **Azure Firewall** | Standard tier | Centralized network security |
| **Firewall Policy** | Application/Network rules | Traffic filtering |
| **Public IP** | Standard SKU | Firewall frontend |

## 🔗 Connectivity Options

### AWS Connectivity

| Connection Type | Use Case | Bandwidth | Latency |
|----------------|----------|-----------|---------|
| **Internet Gateway** | Public internet access | Variable | Variable |
| **NAT Gateway** | Outbound internet from private | Up to 45 Gbps | Low |
| **VPC Peering** | VPC-to-VPC communication | Up to 10 Gbps | Minimal |
| **Transit Gateway** | Multi-VPC connectivity | Up to 50 Gbps | Low |

### Azure Connectivity

| Connection Type | Use Case | Bandwidth | Latency |
|----------------|----------|-----------|---------|
| **Internet** | Public internet access | Variable | Variable |
| **NAT Gateway** | Outbound internet | Up to 64 Gbps | Low |
| **VNet Peering** | VNet-to-VNet communication | Up to 25 Gbps | Minimal |
| **Virtual WAN** | Multi-region connectivity | Up to 20 Gbps | Optimized |

## 📊 Network Monitoring

### AWS Network Monitoring

| Service | Purpose | Metrics | Alerts |
|---------|---------|---------|--------|
| **VPC Flow Logs** | Network traffic analysis | Accepted/rejected flows | Unusual patterns |
| **CloudWatch** | Network metrics | Bandwidth, packet loss | Threshold breaches |
| **Network Insights** | Path analysis | Connectivity issues | Path failures |

#### VPC Flow Logs Configuration
```hcl
resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.kainos_core.id
  
  tags = {
    Name = "kainos-core-vpc-flow-log-${var.environment}"
  }
}
```

### Azure Network Monitoring

| Service | Purpose | Metrics | Alerts |
|---------|---------|---------|--------|
| **Network Watcher** | Network monitoring | Flow logs, topology | Connection issues |
| **Azure Monitor** | Network metrics | Bandwidth, latency | Performance issues |
| **Connection Monitor** | Connectivity testing | Reachability | Connectivity failures |

## 🚀 Performance Optimization

### Network Performance Best Practices

| Optimization | AWS Implementation | Azure Implementation |
|--------------|-------------------|---------------------|
| **Placement Groups** | Cluster placement groups | Proximity placement groups |
| **Enhanced Networking** | SR-IOV, DPDK | Accelerated networking |
| **Load Balancing** | Application Load Balancer | Application Gateway |
| **CDN** | CloudFront | Azure CDN |

### Latency Optimization

| Strategy | Implementation | Expected Improvement |
|----------|----------------|---------------------|
| **Regional Deployment** | Multi-region architecture | 50-80% latency reduction |
| **Edge Locations** | CDN deployment | 60-90% latency reduction |
| **Private Connectivity** | VPC endpoints/Private endpoints | 20-40% latency reduction |
| **Connection Pooling** | Application-level optimization | 10-30% improvement |

## 📋 Network Security Checklist

### Pre-deployment Security

- [ ] VPC/VNet CIDR doesn't overlap with existing networks
- [ ] Security groups/NSGs follow least privilege principle
- [ ] NACLs configured for defense in depth
- [ ] VPC endpoints/Private endpoints configured for AWS/Azure services
- [ ] Flow logs enabled for network monitoring
- [ ] DNS resolution properly configured

### Post-deployment Security

- [ ] Network connectivity tested from all subnets
- [ ] Security group rules validated
- [ ] VPC endpoint connectivity verified
- [ ] Flow logs generating data
- [ ] Network monitoring alerts configured
- [ ] Performance baselines established

## 📚 References

- **[AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)**
- **[Azure Virtual Network Documentation](https://docs.microsoft.com/en-us/azure/virtual-network/)**
- **[AWS Lambda VPC Configuration](https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html)**
- **[Azure Functions VNet Integration](https://docs.microsoft.com/en-us/azure/azure-functions/functions-networking-options)**
- **[Network Security Best Practices](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/network-security.html)**
