# Infrastructure Diagrams

This folder contains Draw.io diagrams for the Kainos Studio infrastructure architecture.

## 📊 Available Diagrams

### End-to-End Architecture
- **[kainos-studio-architecture.drawio](./kainos-studio-architecture.drawio)** - Complete system architecture
- **[kainos-studio-architecture.png](./kainos-studio-architecture.png)** - PNG export of architecture

### Environment Flow Diagrams
- **[dev-deployment-flow.drawio](./dev-deployment-flow.drawio)** - Development environment deployment flow
- **[staging-deployment-flow.drawio](./staging-deployment-flow.drawio)** - Staging environment deployment flow
- **[prod-deployment-flow.drawio](./prod-deployment-flow.drawio)** - Production environment deployment flow

## 🎨 How to Edit Diagrams

1. **Online**: Visit [draw.io](https://app.diagrams.net/) and open the `.drawio` files
2. **VS Code**: Install the Draw.io Integration extension
3. **Desktop**: Download Draw.io desktop application

## 📋 Diagram Standards

- Use AWS/Azure official icons from the shape libraries
- Include environment labels (dev/staging/prod)
- Show data flow directions with arrows
- Include security boundaries and zones
- Use consistent color coding:
  - Orange: AWS services
  - Blue: Azure services
  - Green: Application components
  - Red: Security boundaries
  - Gray: External services

## 🔄 Updating Diagrams

When infrastructure changes:
1. Update the relevant `.drawio` file
2. Export as PNG for easy viewing
3. Commit both files to version control
4. Update this README if new diagrams are added
