#!/bin/bash

# Script to view logs from services

if [ -z "$1" ]; then
    echo "Viewing logs from all services..."
    echo "Press Ctrl+C to exit"
    echo ""
    docker-compose logs -f
else
    echo "Viewing logs from $1..."
    echo "Press Ctrl+C to exit"
    echo ""
    docker-compose logs -f "$1"
fi