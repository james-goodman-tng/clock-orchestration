#!/bin/bash

# Script to stop all World Clock services

echo "========================================"
echo "  Stopping all World Clock services..."
echo "========================================"
echo ""

if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found"
    echo "Please run this script from the clock-orchestration directory"
    exit 1
fi

docker-compose down

echo ""
echo "✓ All services stopped"
echo ""
echo "To remove images: docker-compose down --rmi all"
echo "To remove volumes: docker-compose down --volumes"
echo ""