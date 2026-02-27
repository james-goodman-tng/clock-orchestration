# GitHub Setup Guide

All World Clock microservices are now available on GitHub!

## GitHub Repositories

### API Services
- **api-tokyo**: https://github.com/james-goodman-tng/api-tokyo
- **api-london**: https://github.com/james-goodman-tng/api-london  
- **api-newyork**: https://github.com/james-goodman-tng/api-newyork
- **api-sydney**: https://github.com/james-goodman-tng/api-sydney
- **api-mumbai**: https://github.com/james-goodman-tng/api-mumbai

### Frontend Components
- **fe-tokyo**: https://github.com/james-goodman-tng/fe-tokyo
- **fe-london**: https://github.com/james-goodman-tng/fe-london
- **fe-newyork**: https://github.com/james-goodman-tng/fe-newyork
- **fe-sydney**: https://github.com/james-goodman-tng/fe-sydney
- **fe-mumbai**: https://github.com/james-goodman-tng/fe-mumbai
- **fe-master**: https://github.com/james-goodman-tng/fe-master

### Orchestration
- **clock-orchestration**: https://github.com/james-goodman-tng/clock-orchestration (this repo)

### Meta Repository
- **world-clock-meta**: https://github.com/james-goodman-tng/world-clock-meta

## Quick Clone All Repositories

Use this script to clone all service repositories from GitHub:

```bash
#!/bin/bash

# Navigate to parent directory
cd ..

# Clone all repositories
echo "Cloning all World Clock repositories..."

# API Services
git clone https://github.com/james-goodman-tng/api-tokyo.git
git clone https://github.com/james-goodman-tng/api-london.git
git clone https://github.com/james-goodman-tng/api-newyork.git
git clone https://github.com/james-goodman-tng/api-sydney.git
git clone https://github.com/james-goodman-tng/api-mumbai.git

# Frontend Components  
git clone https://github.com/james-goodman-tng/fe-tokyo.git
git clone https://github.com/james-goodman-tng/fe-london.git
git clone https://github.com/james-goodman-tng/fe-newyork.git
git clone https://github.com/james-goodman-tng/fe-sydney.git
git clone https://github.com/james-goodman-tng/fe-mumbai.git
git clone https://github.com/james-goodman-tng/fe-master.git

# Orchestration
git clone https://github.com/james-goodman-tng/clock-orchestration.git

echo "✓ All repositories cloned!"
echo ""
echo "Directory structure:"
ls -1
echo ""
echo "To start the system:"
echo "  cd clock-orchestration"
echo "  ./start-all.sh"
```

Save this as `clone-all-repos.sh` and run it to clone all repositories from GitHub.

## Setup from GitHub

### Option 1: Clone All Repos (Recommended)

```bash
# Create a parent directory
mkdir world-clock && cd world-clock

# Clone all repositories
bash <(curl -s https://raw.githubusercontent.com/james-goodman-tng/clock-orchestration/main/clone-all-repos.sh)

# Start the system
cd clock-orchestration
./start-all.sh
```

### Option 2: Use the Meta Repository

The meta repository uses git submodules to reference all service repos:

```bash
git clone --recurse-submodules https://github.com/james-goodman-tng/world-clock-meta.git
cd world-clock-meta/clock-orchestration
./start-all.sh
```

### Option 3: Manual Clone

```bash
mkdir world-clock && cd world-clock

# Clone each repository individually
git clone https://github.com/james-goodman-tng/api-tokyo.git
git clone https://github.com/james-goodman-tng/api-london.git
# ... etc for all repos

cd clock-orchestration
./start-all.sh
```

## Docker Compose Compatibility

The current `docker-compose.yml` uses local directory references (`build: ../api-tokyo`) which works perfectly when all repositories are cloned as siblings, as shown in the setup above.

This approach:
- ✅ Works with repos cloned from GitHub
- ✅ Allows local development on any service
- ✅ Builds fresh images from source
- ✅ Supports the multi-repo architecture

## Future: Docker Images

In production, you could publish Docker images to a registry:

```yaml
services:
  api-tokyo:
    image: ghcr.io/james-goodman-tng/api-tokyo:latest
    # instead of: build: ../api-tokyo
```

This would eliminate the need to have source repositories locally.

## Repository URLs Summary

All 13 repositories are public and available at:
- Organization: https://github.com/james-goodman-tng
- Repository pattern: `https://github.com/james-goodman-tng/{repo-name}`
