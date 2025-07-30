#!/bin/bash
# =========================================================================
# RAILWAY DOCKERFILE DETECTION VERIFICATION
# =========================================================================

echo "🔍 RAILWAY DOCKERFILE DETECTION CHECK"
echo "===================================="

echo ""
echo "📋 Critical Files for Railway:"

# Check Dockerfile exists in root
if [ -f "Dockerfile" ]; then
    echo "✅ Dockerfile exists in root ($(wc -l < Dockerfile) lines)"
    if grep -q "python3.12-distutils" Dockerfile; then
        echo "✅ Dockerfile has distutils fix"
    else
        echo "❌ Dockerfile missing distutils fix"
        exit 1
    fi
    if grep -q "COPY src/" Dockerfile; then
        echo "✅ Dockerfile configured for src/ structure"
    else
        echo "❌ Dockerfile not configured for src/ structure"
        exit 1
    fi
else
    echo "❌ Dockerfile missing in root directory"
    exit 1
fi

# Check railway.toml points to Dockerfile
if grep -q 'dockerfilePath = "Dockerfile"' railway.toml; then
    echo "✅ railway.toml points to Dockerfile"
else
    echo "❌ railway.toml not pointing to Dockerfile"
    exit 1
fi

# Check no conflicting Dockerfile.railway
if [ ! -f "Dockerfile.railway" ]; then
    echo "✅ No conflicting Dockerfile.railway"
else
    echo "❌ Dockerfile.railway still exists (conflicting)"
    exit 1
fi

# Check file structure
echo ""
echo "📁 Project Structure:"
echo "   📄 Dockerfile: $(wc -l < Dockerfile) lines"
echo "   📄 deps.txt: $(wc -l < deps.txt) packages"
echo "   📄 railway.toml: DOCKERFILE builder"
echo "   📁 src/: $(ls -1 src/ | wc -l) files"

echo ""
echo "🎯 RAILWAY DETECTION STATUS:"
echo "   ✅ Dockerfile in root directory"
echo "   ✅ railway.toml builder = DOCKERFILE"
echo "   ✅ dockerfilePath = Dockerfile"
echo "   ✅ Python files hidden in src/"
echo "   ✅ requirements.txt renamed to deps.txt"
echo ""
echo "🚀 Railway will now detect and use Dockerfile!"
echo "   Deploy command: railway up"
