# Infrastructure Diagrams

This folder contains high-level architecture diagrams for the Kainos Studio infrastructure using Mermaid syntax for better visibility and version control.

## 📊 Available Diagrams

### High-Level Architecture
- **[kainos-studio-architecture.md](./kainos-studio-architecture.md)** - Complete system architecture overview

### Deployment Flow Diagrams
- **[dev-deployment-flow.md](./dev-deployment-flow.md)** - Development environment deployment flow
- **[staging-deployment-flow.md](./staging-deployment-flow.md)** - Staging environment deployment flow
- **[prod-deployment-flow.md](./prod-deployment-flow.md)** - Production environment deployment flow

## 🎨 Viewing Diagrams

All Mermaid diagrams render directly in GitHub for easy viewing and collaboration.

## 📋 Diagram Standards

- Use consistent color coding:
  - Orange (#FF9900): AWS services
  - Blue (#0078D4): Azure services
  - Green (#28A745): Application components
  - Red (#DC3545): Security boundaries
  - Gray (#6C757D): External services

- Include environment labels (dev/staging/prod)
- Show data flow directions with arrows
- Keep diagrams high-level and focused
- Use meaningful component names

## 🔄 Updating Diagrams

When infrastructure changes:
1. Update the relevant `.md` file with Mermaid syntax
2. Test rendering in GitHub
3. Commit changes to version control
4. Update this README if new diagrams are added
