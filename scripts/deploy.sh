#!/bin/bash
# ============================================
# Deployment Script
# Pulls latest images and restarts containers
# ============================================

set -e

echo "============================================"
echo "  MEAN Stack - Deployment Script"
echo "============================================"

# Set project directory
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR"

# Pull latest code
echo "📂 Pulling latest code..."
git pull origin main

# Pull latest Docker images
echo "🐳 Pulling latest Docker images..."
docker compose pull

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker compose down

# Start containers in detached mode
echo "🚀 Starting containers..."
docker compose up -d

# Cleanup unused images
echo "🧹 Cleaning up unused images..."
docker image prune -f

# Show container status
echo ""
echo "============================================"
echo "  ✅ Deployment Complete!"
echo "============================================"
docker compose ps
echo ""
echo "Application is running at: http://$(hostname -I | awk '{print $1}')"
echo "============================================"
