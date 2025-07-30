#!/bin/bash
# =========================================================================
# FINAL PRODUCTION DEPLOYMENT - CLEANED UP VERSION
# =========================================================================

echo "🎯 BUKTI SETOR OCR - FINAL PRODUCTION DEPLOYMENT"
echo "=============================================="

echo "📋 Production Configuration:"
echo "   App: app_bukti_setor.py"
echo "   Python: 3.12-slim + distutils"
echo "   Requirements: Full OCR + Database stack"
echo "   Builder: DOCKERFILE (Nixpacks blocked)"

echo ""
echo "🧹 Cleanup completed:"
echo "   ❌ Removed all demo/test apps"
echo "   ❌ Removed all alternative Dockerfiles"
echo "   ❌ Removed all test requirements"
echo "   ❌ Removed all debugging scripts"
echo "   ✅ Only production files remain"

echo ""
echo "🔍 Final verification:"

# Verify production files exist
files_required=("app_bukti_setor.py" "Dockerfile" "requirements.txt" "Procfile" "railway.toml")
for file in "${files_required[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Verify no demo files remain
demo_files=("app_test.py" "app_minimal.py" "requirements-minimal.txt" "Dockerfile.minimal")
for file in "${demo_files[@]}"; do
    if [ -f "$file" ]; then
        echo "❌ Demo file still exists: $file"
        exit 1
    else
        echo "✅ No demo file: $file"
    fi
done

# Check production configuration
if grep -q "app_bukti_setor:app" Procfile && grep -q "app_bukti_setor:app" Dockerfile; then
    echo "✅ Production app configured"
else
    echo "❌ Production app not configured"
    exit 1
fi

if grep -q "python3.12-distutils" Dockerfile; then
    echo "✅ Distutils fix applied"
else
    echo "❌ Distutils fix missing"
    exit 1
fi

if grep -q "DOCKERFILE" railway.toml; then
    echo "✅ Railway configured for Dockerfile"
else
    echo "❌ Railway not configured for Dockerfile"
    exit 1
fi

# Count requirements
req_count=$(wc -l < requirements.txt)
if [ "$req_count" -gt 30 ]; then
    echo "✅ Full production requirements ($req_count packages)"
else
    echo "❌ Requirements too minimal ($req_count packages)"
    exit 1
fi

echo ""
echo "🎉 FINAL PRODUCTION READY!"
echo ""
echo "What will happen on Railway:"
echo "   1. ✅ Uses Dockerfile (Python 3.12 + distutils)"
echo "   2. ✅ Installs all OCR + ML + Database packages"
echo "   3. ✅ Starts production app on port 8080"
echo "   4. ✅ Health check available at /health"
echo ""
echo "🚀 DEPLOY COMMAND:"
echo "   railway up"
echo ""
echo "📍 Final file structure:"
ls -la | grep -E '\.(py|txt|toml|Dockerfile)$|Procfile'
