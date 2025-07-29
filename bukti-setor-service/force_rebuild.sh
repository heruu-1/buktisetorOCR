#!/bin/bash
# =========================================================================
# RAILWAY FORCE REBUILD SCRIPT
# =========================================================================

echo "🔄 FORCING RAILWAY REBUILD..."
echo "================================"

# Remove any potential cache files
echo "🧹 Cleaning local cache files..."
rm -rf .railway/
rm -rf node_modules/
rm -rf __pycache__/
rm -rf *.pyc
rm -rf .pytest_cache/

# Ensure correct file permissions
echo "🔧 Setting file permissions..."
chmod +x deploy.sh
chmod 644 requirements.txt
chmod 644 Dockerfile
chmod 644 railway.toml
chmod 644 Procfile

# Check Railway CLI
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Install with:"
    echo "   npm install -g @railway/cli"
    exit 1
fi

echo "🚄 Railway CLI found"

# Check if logged in
echo "🔑 Checking Railway authentication..."
if railway whoami &> /dev/null; then
    echo "✅ Logged in to Railway"
else
    echo "❌ Not logged in to Railway. Please run:"
    echo "   railway login"
    exit 1
fi

# Show current deployment config
echo ""
echo "📋 Current deployment configuration:"
echo "Builder: $(grep 'builder' railway.toml | cut -d'"' -f2)"
echo "Health check: $(grep 'healthcheckPath' railway.toml | cut -d'"' -f2)"
echo "Requirements: $(wc -l < requirements.txt) lines"
echo "Dockerfile: $(wc -l < Dockerfile) lines"

echo ""
echo "🚀 Starting fresh deployment..."
echo "This will:"
echo "1. Use DOCKERFILE builder (not Nixpacks)"
echo "2. Install stable dependency versions"
echo "3. Skip cache for fresh build"

read -p "Continue? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Deploying with force rebuild..."
    railway up --detach
    echo ""
    echo "✅ Deployment started!"
    echo "📊 Monitor progress at: https://railway.app"
    echo "🌐 Health check will be available at: /health"
else
    echo "❌ Deployment cancelled"
fi
