#!/bin/bash

# Script to check status of all services

echo "========================================"
echo "  World Clock Services Status Check"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_service() {
  local name=$1
  local url=$2
  
  if curl -s -o /dev/null -w "%{http_code}" "$url" --max-time 2 | grep -q "200"; then
    echo -e "${GREEN}✓${NC} $name - ${GREEN}ONLINE${NC} ($url)"
    return 0
  else
    echo -e "${RED}✗${NC} $name - ${RED}OFFLINE${NC} ($url)"
    return 1
  fi
}

TOTAL=0
ONLINE=0

echo "API Services:"
echo "-------------"
check_service "Tokyo API     " "http://localhost:3001/health" && ((ONLINE++)); ((TOTAL++))
check_service "London API    " "http://localhost:3002/health" && ((ONLINE++)); ((TOTAL++))
check_service "New York API  " "http://localhost:3003/health" && ((ONLINE++)); ((TOTAL++))
check_service "Sydney API    " "http://localhost:3004/health" && ((ONLINE++)); ((TOTAL++))
check_service "Mumbai API    " "http://localhost:3005/health" && ((ONLINE++)); ((TOTAL++))

echo ""
echo "Frontend Components:"
echo "--------------------"
check_service "Tokyo Frontend    " "http://localhost:8081" && ((ONLINE++)); ((TOTAL++))
check_service "London Frontend   " "http://localhost:8082" && ((ONLINE++)); ((TOTAL++))
check_service "New York Frontend " "http://localhost:8083" && ((ONLINE++)); ((TOTAL++))
check_service "Sydney Frontend   " "http://localhost:8084" && ((ONLINE++)); ((TOTAL++))
check_service "Mumbai Frontend   " "http://localhost:8085" && ((ONLINE++)); ((TOTAL++))

echo ""
echo "Master Dashboard:"
echo "-----------------"
check_service "Master Dashboard  " "http://localhost:8080" && ((ONLINE++)); ((TOTAL++))

echo ""
echo "========================================"
echo -e "Status: ${ONLINE}/${TOTAL} services online"
echo "========================================"
echo ""

if [ $ONLINE -eq $TOTAL ]; then
    echo -e "${GREEN}✓ All services are running!${NC}"
    echo ""
    echo "Open the dashboard: http://localhost:8080"
else
    echo -e "${YELLOW}⚠ Some services are offline${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check if services are starting: docker-compose ps"
    echo "  2. View logs: docker-compose logs"
    echo "  3. Restart services: ./stop-all.sh && ./start-all.sh"
fi

echo ""