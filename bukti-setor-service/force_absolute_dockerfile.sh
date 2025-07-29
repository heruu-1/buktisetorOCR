#!/bin/bash
# =========================================================================
# ABSOLUTE FORCE DOCKERFILE DEPLOYMENT - NO NIXPACKS
# =========================================================================

echo "🚨 FORCING DOCKERFILE DEPLOYMENT - BLOCKING NIXPACKS COMPLETELY"
echo "================================================================="

# Remove ALL nixpacks traces
echo "🧹 Removing ALL Nixpacks traces..."
rm -f nixpacks.toml
rm -f nixpacks.toml.disabled
rm -f .nixpacksrc
rm -f .nixpacks

# Create strong nixpacks ignore
echo "*" > .nixpacksignore
echo "**/*" >> .nixpacksignore

# Verify Railway config
echo "🚄 Checking Railway configuration..."
if ! grep -q "DOCKERFILE" railway.toml; then
    echo "❌ railway.toml not configured for DOCKERFILE"
    exit 1
fi

echo "✅ Builder: $(grep 'builder' railway.toml | cut -d'=' -f2 | tr -d ' "')"
echo "✅ Dockerfile path: $(grep 'dockerfilePath' railway.toml | cut -d'=' -f2 | tr -d ' "' || echo 'Dockerfile')"

# Verify Dockerfile exists and has content
if [ ! -f "Dockerfile" ] || [ ! -s "Dockerfile" ]; then
    echo "❌ Dockerfile missing or empty"
    exit 1
fi

echo "✅ Dockerfile: $(wc -l < Dockerfile) lines"

# Check Python version in Dockerfile
PYTHON_VERSION=$(grep "FROM python:" Dockerfile | head -1 | cut -d: -f2)
echo "✅ Python version: $PYTHON_VERSION"

# Clean build artifacts
echo "🧹 Cleaning build artifacts..."
rm -rf __pycache__/ .pytest_cache/ *.pyc
find . -name "*.pyc" -delete 2>/dev/null || true

# Set permissions
chmod 644 Dockerfile railway.toml requirements.txt Procfile
chmod 755 *.sh

echo ""
echo "📋 Final configuration:"
echo "   Railway builder: DOCKERFILE"
echo "   Dockerfile: exists ($(wc -l < Dockerfile) lines)"
echo "   Python: $PYTHON_VERSION"
echo "   Requirements: $(grep -c '^[a-zA-Z]' requirements.txt) packages"
echo "   Nixpacks: BLOCKED"

echo ""
echo "🚀 READY FOR DEPLOYMENT!"
echo "📌 Railway MUST use Dockerfile now!"
echo ""
echo "Deploy command: railway up"
