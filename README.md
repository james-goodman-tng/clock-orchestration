# Clock Orchestration

This repository orchestrates the deployment of all 11 World Clock microservices.

## 🌐 All Repositories Now on GitHub!

All World Clock microservices are publicly available on GitHub! See **[GITHUB-SETUP.md](./GITHUB-SETUP.md)** for:
- Complete list of GitHub repository URLs
- Quick clone script (`./clone-all-repos.sh`)
- Multiple setup options

**Quick Setup from GitHub:**
```bash
# Clone all repos with one command
bash <(curl -s https://raw.githubusercontent.com/james-goodman-tng/clock-orchestration/main/clone-all-repos.sh)

# Start the system
cd clock-orchestration
./start-all.sh
```

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

**💡 Tip:** Use `./clone-all-repos.sh` to clone all repositories from GitHub automatically!

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
- Clone from GitHub and start immediately

### GitHub Repositories

All services are now available on GitHub at:
- **Organization**: https://github.com/james-goodman-tng
- **Pattern**: `https://github.com/james-goodman-tng/{repo-name}`

See [GITHUB-SETUP.md](./GITHUB-SETUP.md) for complete URLs and setup instructions.

### Future: Remote Images Mode

In production, you could use published Docker images:

```yaml
services:
  api-tokyo:
    image: ghcr.io/james-goodman-tng/api-tokyo:latest
```

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

### stop-all.sh
Stops all running services.

### check-services.sh
Health check for all services.

### logs.sh
View service logs.

### restart-service.sh
Restart individual service.

### clone-all-repos.sh
Clone all service repositories from GitHub (NEW!)

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

### Scenario 1: Clone from GitHub
```bash
mkdir world-clock && cd world-clock
bash <(curl -s https://raw.githubusercontent.com/james-goodman-tng/clock-orchestration/main/clone-all-repos.sh)
cd clock-orchestration
./start-all.sh
```

### Scenario 2: Kubernetes
Convert docker-compose to Kubernetes manifests

### Scenario 3: Multi-Region
Deploy services to appropriate regions

## Troubleshooting

### Port Already in Use
```bash
lsof -i :8080
```

### Container Won't Start
```bash
docker-compose logs <service-name>
docker-compose up --build <service-name>
```

### Missing Repositories
```bash
bash <(curl -s https://raw.githubusercontent.com/james-goodman-tng/clock-orchestration/main/clone-all-repos.sh)
```

## Resources

- **GitHub Setup Guide**: [GITHUB-SETUP.md](./GITHUB-SETUP.md)
- **Clone Script**: [clone-all-repos.sh](./clone-all-repos.sh)
- **Meta Repository**: https://github.com/james-goodman-tng/world-clock-meta
- **Organization**: https://github.com/james-goodman-tng

## Philosophy

This orchestration layer:

✅ **Doesn't own the services** - just coordinates them
✅ **Respects independence** - each service is separate
✅ **Provides convenience** - single command to start all
✅ **Enables testing** - easy local integration testing
✅ **Supports evolution** - can migrate to K8s, cloud, etc.
✅ **GitHub-ready** - all services available on GitHub

The orchestration is itself a service - a coordination service that knows how to deploy the full system.

## License

This orchestration layer can be managed separately from the services it deploys.
