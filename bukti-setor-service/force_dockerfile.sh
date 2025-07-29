#!/bin/bash
# =========================================================================
# FORCE DOCKERFILE DEPLOYMENT ON RAILWAY
# =========================================================================

echo "🔄 FORCING DOCKERFILE DEPLOYMENT..."
echo "=================================="

# Clean up Nixpacks files
echo "🧹 Disabling Nixpacks..."
if [ -f "nixpacks.toml" ]; then
    mv nixpacks.toml nixpacks.toml.disabled
    echo "   ✅ nixpacks.toml disabled"
fi

# Create .nixpacksignore
echo "*" > .nixpacksignore
echo "   ✅ .nixpacksignore created"

# Verify Dockerfile exists
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile not found!"
    exit 1
fi

echo "   ✅ Dockerfile found ($(wc -l < Dockerfile) lines)"

# Check railway.toml
if grep -q "dockerfile" railway.toml; then
    echo "   ✅ railway.toml configured for dockerfile"
else
    echo "❌ railway.toml not configured properly"
    exit 1
fi

# Clean any Python cache
echo "🧹 Cleaning Python cache..."
find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "*.pyc" -delete 2>/dev/null || true

# Set correct permissions
echo "🔧 Setting permissions..."
chmod 644 Dockerfile railway.toml requirements.txt Procfile

echo ""
echo "📋 Current configuration:"
echo "   Builder: $(grep 'builder' railway.toml | cut -d'=' -f2 | tr -d ' "')"
echo "   Dockerfile: $(wc -l < Dockerfile) lines"
echo "   Requirements: $(grep -c '^[a-zA-Z]' requirements.txt) packages"
echo "   Procfile: $(cat Procfile)"

echo ""
echo "🚀 Ready for deployment!"
echo "Run: railway up"
