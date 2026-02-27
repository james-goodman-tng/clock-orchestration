#!/bin/bash

# Script to start all World Clock services

set -e

echo "========================================"
echo "  World Clock Orchestration"
echo "  Starting all services..."
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found"
    echo "Please run this script from the clock-orchestration directory"
    exit 1
fi

# Check if component repos exist
echo "Checking for required repositories..."
REPOS=(
    "../api-tokyo"
    "../api-london"
    "../api-newyork"
    "../api-sydney"
    "../api-mumbai"
    "../fe-tokyo"
    "../fe-london"
    "../fe-newyork"
    "../fe-sydney"
    "../fe-mumbai"
    "../fe-master"
)

MISSING_REPOS=()
for repo in "${REPOS[@]}"; do
    if [ ! -d "$repo" ]; then
        MISSING_REPOS+=("$repo")
    fi
done

if [ ${#MISSING_REPOS[@]} -gt 0 ]; then
    echo "Error: Missing required repositories:"
    for repo in "${MISSING_REPOS[@]}"; do
        echo "  - $repo"
    done
    exit 1
fi

echo "✓ All required repositories found"
echo ""

# Start services
echo "Building and starting containers..."
echo "This may take a few minutes on first run..."
echo ""

docker-compose up --build -d

echo ""
echo "========================================"
echo "  Services Starting..."
echo "========================================"
echo ""
echo "Waiting for services to be ready..."
sleep 5

echo ""
echo "Service URLs:"
echo "-------------"
echo "  Master Dashboard:  http://localhost:8080"
echo ""
echo "Individual Clocks:"
echo "  Tokyo:             http://localhost:8081"
echo "  London:            http://localhost:8082"
echo "  New York:          http://localhost:8083"
echo "  Sydney:            http://localhost:8084"
echo "  Mumbai:            http://localhost:8085"
echo ""
echo "APIs:"
echo "  Tokyo API:         http://localhost:3001/time"
echo "  London API:        http://localhost:3002/time"
echo "  New York API:      http://localhost:3003/time"
echo "  Sydney API:        http://localhost:3004/time"
echo "  Mumbai API:        http://localhost:3005/time"
echo ""
echo "========================================"
echo ""
echo "To view logs: docker-compose logs -f"
echo "To stop:      ./stop-all.sh"
echo "To check:     ./check-services.sh"
echo ""