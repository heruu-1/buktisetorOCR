#!/bin/bash
# =========================================================================
# FINAL DOCKERFILE FORCE - PYTHON 3.12 COMPATIBILITY
# =========================================================================

echo "🔥 FORCING DOCKERFILE WITH PYTHON 3.12 DISTUTILS FIX"
echo "===================================================="

# Remove ALL Nixpacks traces
echo "🧹 Removing ALL Nixpacks files..."
rm -f nixpacks.toml
rm -f nixpacks.toml.disabled
rm -f .nixpacksrc
rm -f package.json
rm -f yarn.lock
rm -f package-lock.json

# Create absolute nixpacks block
echo "**" > .nixpacksignore
echo "*" >> .nixpacksignore
echo "/*" >> .nixpacksignore

# Verify configuration
echo "🔍 Verification:"

# Check Railway config
if grep -q "DOCKERFILE" railway.toml; then
    echo "✅ Railway builder: DOCKERFILE"
else
    echo "❌ Railway config error"
    exit 1
fi

# Check Dockerfile
if grep -q "python:3.12-slim" Dockerfile; then
    echo "✅ Dockerfile: Python 3.12-slim"
else
    echo "❌ Dockerfile Python version error"
    exit 1
fi

# Check if distutils fix is present
if grep -q "setuptools" Dockerfile; then
    echo "✅ Dockerfile: setuptools/distutils fix included"
else
    echo "❌ Missing distutils fix"
    exit 1
fi

# Check minimal requirements
if [ $(wc -l < requirements.txt) -lt 10 ]; then
    echo "✅ Requirements: minimal ($(wc -l < requirements.txt) lines)"
else
    echo "❌ Requirements too complex"
    exit 1
fi

# Check Procfile
if grep -q "app_test:app" Procfile; then
    echo "✅ Procfile: test app"
else
    echo "❌ Procfile error"
    exit 1
fi

echo ""
echo "📋 Final Configuration:"
echo "   Python: 3.12-slim"
echo "   Distutils: Fixed with setuptools upgrade"
echo "   Requirements: $(grep -c '^[a-zA-Z]' requirements.txt) packages"
echo "   App: app_test.py (minimal)"
echo "   Nixpacks: COMPLETELY BLOCKED"

echo ""
echo "🚀 READY FOR FINAL DEPLOYMENT!"
echo "This should work with Python 3.12 + distutils fix"
echo ""
echo "Deploy: railway up"
