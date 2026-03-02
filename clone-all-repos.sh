#!/bin/bash

# Script to clone all World Clock repositories from GitHub

echo "========================================"
echo "  Clone All World Clock Repositories"
echo "========================================"
echo ""

# Check if we're in the right place
if [ -d "api-tokyo" ] || [ -d "clock-orchestration" ]; then
    echo "⚠️  Warning: Some repositories already exist in this directory"
    echo "Please run this script from an empty directory"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "Cloning all repositories from GitHub..."
echo ""

# API Services
echo "📦 Cloning API Services..."
git clone https://github.com/james-goodman-tng/api-tokyo.git
git clone https://github.com/james-goodman-tng/api-london.git
git clone https://github.com/james-goodman-tng/api-newyork.git
git clone https://github.com/james-goodman-tng/api-sydney.git
git clone https://github.com/james-goodman-tng/api-mumbai.git
echo ""

# Frontend Components
echo "🎨 Cloning Frontend Components..."
git clone https://github.com/james-goodman-tng/fe-tokyo.git
git clone https://github.com/james-goodman-tng/fe-london.git
git clone https://github.com/james-goodman-tng/fe-newyork.git
git clone https://github.com/james-goodman-tng/fe-sydney.git
git clone https://github.com/james-goodman-tng/fe-mumbai.git
git clone https://github.com/james-goodman-tng/fe-master.git
echo ""

# Orchestration
echo "🎭 Cloning Orchestration..."
git clone https://github.com/james-goodman-tng/clock-orchestration.git
echo ""

echo "========================================"
echo "  ✓ All Repositories Cloned!"
echo "========================================"
echo ""
echo "Directory structure:"
echo "-------------------"
ls -1 | grep -E "api-|fe-|clock-"
echo ""
echo "Repository summary:"
echo "  - 5 API services"
echo "  - 6 Frontend components (5 cities + 1 master)"
echo "  - 1 Orchestration service"
echo "  Total: 12 repositories"
echo ""
echo "To start the system:"
echo "  cd clock-orchestration"
echo "  ./start-all.sh"
echo ""
echo "To check status:"
echo "  cd clock-orchestration"
echo "  ./check-services.sh"
echo ""
