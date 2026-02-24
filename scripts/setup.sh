#!/bin/bash
# ============================================
# Server Setup Script
# Installs Docker, Docker Compose, Nginx, Git
# Run on a fresh Ubuntu VM
# ============================================

set -e

echo "============================================"
echo "  MEAN Stack - Server Setup Script"
echo "============================================"

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install prerequisites
echo "📦 Installing prerequisites..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# -------------------------------------------
# Install Docker
# -------------------------------------------
echo "🐳 Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add current user to docker group
sudo usermod -aG docker $USER

# -------------------------------------------
# Install Docker Compose Plugin
# -------------------------------------------
echo "🐳 Installing Docker Compose plugin..."
sudo apt-get install -y docker-compose-plugin

# -------------------------------------------
# Install Nginx
# -------------------------------------------
echo "🌐 Installing Nginx..."
sudo apt-get install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# -------------------------------------------
# Install Git
# -------------------------------------------
echo "📂 Installing Git..."
sudo apt-get install -y git

# -------------------------------------------
# Verify installations
# -------------------------------------------
echo ""
echo "============================================"
echo "  ✅ Installation Complete!"
echo "============================================"
echo "Docker version:         $(docker --version)"
echo "Docker Compose version: $(docker compose version)"
echo "Nginx version:          $(nginx -v 2>&1)"
echo "Git version:            $(git --version)"
echo ""
echo "⚠️  Please log out and log back in for Docker"
echo "   group changes to take effect."
echo "============================================"
