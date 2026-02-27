# Clock Orchestration

This repository orchestrates the deployment of all 11 World Clock microservices.

## Purpose

This orchestration layer coordinates:
- 5 API services (Tokyo, London, New York, Sydney, Mumbai)
- 5 Frontend components (one for each city)
- 1 Master dashboard (aggregating all components)

## Quick Start

### Start All Services

```bash
./start-all.sh
```

This will:
1. Check that all required repositories exist
2. Build Docker images for all 11 services
3. Start all containers
4. Display service URLs

### Check Service Status

```bash
./check-services.sh
```

Shows which services are online/offline with color-coded status.

### View Logs

```bash
# All services
./logs.sh

# Specific service
./logs.sh api-tokyo
./logs.sh fe-master
```

### Restart a Service

```bash
./restart-service.sh <service-name>

# Examples:
./restart-service.sh api-tokyo
./restart-service.sh fe-master
```

### Stop All Services

```bash
./stop-all.sh
```

## Prerequisites

### Required Repositories

This orchestration repo expects the following sibling directories:

```
parent-directory/
├── clock-orchestration/    (this repo)
├── api-tokyo/
├── api-london/
├── api-newyork/
├── api-sydney/
├── api-mumbai/
├── fe-tokyo/
├── fe-london/
├── fe-newyork/
├── fe-sydney/
├── fe-mumbai/
└── fe-master/
```

### Required Software

- Docker
- Docker Compose
- Bash shell

## Architecture

### Local Development Mode (Current)

This orchestration repo references local directories:

```yaml
services:
  api-tokyo:
    build: ../api-tokyo  # References local directory
```

This allows you to:
- Develop services locally
- Test integration immediately
- Use existing git repositories without changes

### Future: Remote Repository Mode

In production, you could modify the orchestration to:

1. **Clone from Git**:
   ```bash
   git clone https://github.com/org/api-tokyo
   git clone https://github.com/org/api-london
   # etc.
   ```

2. **Reference remote images**:
   ```yaml
   services:
     api-tokyo:
       image: ghcr.io/org/api-tokyo:latest
   ```

3. **Trigger remote deployments**:
   - GitHub Actions
   - Kubernetes deployments
   - Cloud provider services

## Service Ports

| Service | Port | Type |
|---------|------|------|
| api-tokyo | 3001 | API |
| api-london | 3002 | API |
| api-newyork | 3003 | API |
| api-sydney | 3004 | API |
| api-mumbai | 3005 | API |
| fe-tokyo | 8081 | Web |
| fe-london | 8082 | Web |
| fe-newyork | 8083 | Web |
| fe-sydney | 8084 | Web |
| fe-mumbai | 8085 | Web |
| fe-master | 8080 | Web |

## Scripts Reference

### start-all.sh
Starts all services with Docker Compose.
- Validates required repositories exist
- Builds images
- Starts containers in background
- Shows service URLs

### stop-all.sh
Stops all running services.
- Gracefully shuts down containers
- Preserves images and volumes

### check-services.sh
Health check for all services.
- Tests HTTP connectivity
- Color-coded status output
- Shows service counts

### logs.sh
View service logs.
- All services: `./logs.sh`
- Specific service: `./logs.sh <name>`

### restart-service.sh
Restart individual service.
- Useful for testing changes
- No downtime for other services

## Docker Compose Configuration

### Networks
All services connect to `world-clock-network` bridge network.

### Dependencies
- Frontend components depend on their APIs
- Master frontend depends on all frontend components

### Restart Policy
All services use `unless-stopped` restart policy.

## Development Workflow

### Making Changes to a Service

1. **Edit service code** in its repository:
   ```bash
   cd ../api-tokyo
   # Make changes to index.js
   ```

2. **Rebuild and restart** that service:
   ```bash
   cd ../clock-orchestration
   docker-compose up --build -d api-tokyo
   ```

3. **Test** the change:
   ```bash
   curl http://localhost:3001/time
   ```

### Testing Integration

After making changes to multiple services:

```bash
./stop-all.sh
./start-all.sh
./check-services.sh
```

### Debugging Issues

```bash
# Check container status
docker-compose ps

# View logs for specific service
./logs.sh api-tokyo

# View all logs
./logs.sh

# Restart problematic service
./restart-service.sh api-tokyo

# Complete rebuild
./stop-all.sh
docker-compose down --rmi all
./start-all.sh
```

## Deployment Scenarios

### Current: Local Development
All services run on localhost via Docker Compose.

### Scenario 1: Single Server
Deploy all containers to one production server:
```bash
# On production server
git clone <orchestration-repo>
cd clock-orchestration
# Clone all service repos
./start-all.sh
```

### Scenario 2: Kubernetes
Convert docker-compose to Kubernetes manifests:
- Each service becomes a Deployment
- Each gets a Service for networking
- Ingress for external access

### Scenario 3: Multi-Region
Deploy each service to appropriate region:
- Tokyo services → Tokyo datacenter
- London services → London datacenter
- Master frontend → Global CDN

### Scenario 4: CI/CD Pipeline
Orchestration triggers remote deployments:
```yaml
# GitHub Actions example
- name: Deploy Tokyo API
  uses: trigger-deployment
  with:
    service: api-tokyo
    region: asia-northeast1
```

## Troubleshooting

### Port Already in Use
```bash
# Find what's using the port
lsof -i :8080

# Stop the process or change port in docker-compose.yml
```

### Container Won't Start
```bash
# View error logs
docker-compose logs <service-name>

# Try rebuilding
docker-compose up --build <service-name>
```

### Service Unreachable
```bash
# Check if container is running
docker-compose ps

# Check network
docker network ls
docker network inspect clock-orchestration_world-clock-network
```

### Changes Not Reflected
```bash
# Force rebuild
docker-compose build --no-cache <service-name>
docker-compose up -d <service-name>
```

## Adding a New Service

To add a new city (e.g., Paris):

1. **Create service repositories**:
   ```bash
   cd ..
   mkdir api-paris fe-paris
   # Set up service code
   ```

2. **Update docker-compose.yml**:
   ```yaml
   api-paris:
     build: ../api-paris
     ports: ["3006:3006"]
   
   fe-paris:
     build: ../fe-paris
     ports: ["8086:80"]
     depends_on: [api-paris]
   ```

3. **Update fe-master** to include Paris iframe

4. **Restart orchestration**:
   ```bash
   ./stop-all.sh
   ./start-all.sh
   ```

## Repository Structure

```
clock-orchestration/
├── .git/                    # Git repository
├── docker-compose.yml       # Service definitions
├── start-all.sh            # Start all services
├── stop-all.sh             # Stop all services
├── check-services.sh       # Health checks
├── logs.sh                 # View logs
├── restart-service.sh      # Restart single service
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## Philosophy

This orchestration layer:

✅ **Doesn't own the services** - just coordinates them
✅ **Respects independence** - each service is separate
✅ **Provides convenience** - single command to start all
✅ **Enables testing** - easy local integration testing
✅ **Supports evolution** - can migrate to K8s, cloud, etc.

The orchestration is itself a service - a coordination service that knows how to deploy the full system.

## License

This orchestration layer can be managed separately from the services it deploys.