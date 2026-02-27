#!/bin/bash

# Script to restart a specific service

if [ -z "$1" ]; then
    echo "Usage: ./restart-service.sh <service-name>"
    echo ""
    echo "Available services:"
    echo "  APIs: api-tokyo, api-london, api-newyork, api-sydney, api-mumbai"
    echo "  Frontends: fe-tokyo, fe-london, fe-newyork, fe-sydney, fe-mumbai"
    echo "  Master: fe-master"
    exit 1
fi

SERVICE=$1

echo "Restarting $SERVICE..."
docker-compose restart "$SERVICE"

echo ""
echo "✓ $SERVICE restarted"
echo ""
echo "Check status: ./check-services.sh"
echo "View logs: ./logs.sh $SERVICE"
echo ""