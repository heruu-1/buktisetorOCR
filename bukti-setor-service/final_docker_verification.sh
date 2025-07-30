#!/bin/bash
# =========================================================================
# FINAL VERIFICATION - NO NIXPACKS INTERFERENCE
# =========================================================================

echo "🎯 FINAL DOCKER-ONLY DEPLOYMENT"
echo "==============================="

echo ""
echo "🔍 Critical Check:"

# Check nixpacks.toml is GONE
if [ -f "nixpacks.toml" ]; then
    echo "❌ nixpacks.toml still exists - Railway will use Nixpacks!"
    exit 1
else
    echo "✅ nixpacks.toml REMOVED - Railway cannot use Nixpacks"
fi

# Check railway.toml configuration
if grep -q "DOCKERFILE" railway.toml && grep -q "Dockerfile.railway" railway.toml; then
    echo "✅ railway.toml: DOCKERFILE + Dockerfile.railway"
else
    echo "❌ railway.toml misconfigured"
    exit 1
fi

# Check file structure
if [ -f "Dockerfile.railway" ] && [ -f "deps.txt" ] && [ -d "src" ]; then
    echo "✅ File structure: Dockerfile.railway + deps.txt + src/"
else
    echo "❌ File structure incomplete"
    exit 1
fi

# Check Python files hidden from root
python_in_root=$(find . -maxdepth 1 -name "*.py" | wc -l)
if [ "$python_in_root" -eq 0 ]; then
    echo "✅ No Python files in root (hidden in src/)"
else
    echo "❌ Python files still in root: $python_in_root files"
    exit 1
fi

# Check requirements renamed
if [ ! -f "requirements.txt" ] && [ -f "deps.txt" ]; then
    echo "✅ requirements.txt renamed to deps.txt"
else
    echo "❌ requirements.txt still exists or deps.txt missing"
    exit 1
fi

echo ""
echo "🚀 READY FOR DEPLOYMENT!"
echo ""
echo "What Railway will do:"
echo "   1. ✅ Cannot find nixpacks.toml → No Nixpacks"
echo "   2. ✅ railway.toml says DOCKERFILE → Use Docker"
echo "   3. ✅ Uses Dockerfile.railway → Our Dockerfile with distutils fix"
echo "   4. ✅ Python 3.12 + distutils installed"
echo "   5. ✅ All packages from deps.txt install successfully"
echo "   6. ✅ App starts: src/app_bukti_setor.py"
echo ""
echo "Deploy command:"
echo "   railway up"
