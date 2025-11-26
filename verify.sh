#!/bin/bash

echo "======================================"
echo "   DevOps Project Verification Script"
echo "======================================"

REPO="https://raw.githubusercontent.com/gagansingh3467-pixel/devops-fastapi-ci-cd/main"
SERVICE_URL="https://fastapi-devops-service.onrender.com"

echo ""
echo "🔍 Checking Render Deployment..."
echo "--------------------------------------"
curl -s -o /dev/null -w "Root /   : %{http_code}\n" "$SERVICE_URL/"
curl -s -o /dev/null -w "Health   : %{http_code}\n" "$SERVICE_URL/health"
curl -s -o /dev/null -w "swagger  : %{http_code}\n" "$SERVICE_URL/docs"

echo ""
echo "🔍 Checking Screenshots on GitHub..."
echo "--------------------------------------"

# Updated screenshot filenames
screenshots=( 
    root.png 
    health.png 
    swagger.png 
    render.png 
    promethius.png 
    grafana.png 
    alert.png 
)

for img in "${screenshots[@]}"; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$REPO/screenshots/$img")
    echo "$img : $STATUS"
done

echo ""
echo "🔍 Checking Local Monitoring Services (Requires docker-compose running)"
echo "--------------------------------------"

PROMETHEUS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090)
GRAFANA_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
CADVISOR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

echo "Promethius : $PROMETHEUS_STATUS"
echo "Grafana    : $GRAFANA_STATUS"
echo "cAdvisor   : $CADVISOR_STATUS"

echo ""
echo "🎉 Verification Completed!"
echo "--------------------------------------"
echo "HTTP 200 = OK | 404 = Missing | 500 = Server Error"

