#!/bin/bash
# =========================================================================
# FINAL PRODUCTION DEPLOYMENT VERIFICATION
# =========================================================================

echo "🚀 FULL PRODUCTION DEPLOYMENT CHECK"
echo "==================================="

echo "📋 Configuration Summary:"
echo "   App: app_bukti_setor.py (FULL PRODUCTION)"
echo "   Requirements: $(wc -l < requirements.txt) packages (OCR + Database + PyTorch)"
echo "   Python: 3.12-slim + distutils fix"
echo "   Builder: DOCKERFILE (forced in railway.toml)"
echo "   Nixpacks: COMPLETELY BLOCKED"

echo ""
echo "🔍 Critical checks:"

# Check production app exists
if [ -f "app_bukti_setor.py" ]; then
    echo "✅ app_bukti_setor.py exists"
    if grep -q "/health" app_bukti_setor.py; then
        echo "✅ Health endpoint found"
    else
        echo "❌ Health endpoint missing"
        exit 1
    fi
else
    echo "❌ app_bukti_setor.py missing"
    exit 1
fi

# Check Dockerfile has distutils fix
if [ -f "Dockerfile" ] && [ -s "Dockerfile" ]; then
    echo "✅ Dockerfile exists ($(wc -l < Dockerfile) lines)"
    if grep -q "python3.12-distutils" Dockerfile; then
        echo "✅ Dockerfile has distutils fix"
    else
        echo "❌ Dockerfile missing distutils fix"
        exit 1
    fi
    if grep -q "app_bukti_setor:app" Dockerfile; then
        echo "✅ Dockerfile CMD points to production app"
    else
        echo "❌ Dockerfile CMD not configured for production"
        exit 1
    fi
else
    echo "❌ Dockerfile missing or empty"
    exit 1
fi

# Check railway.toml
if grep -q "DOCKERFILE" railway.toml; then
    echo "✅ railway.toml configured for DOCKERFILE"
else
    echo "❌ railway.toml not configured properly"
    exit 1
fi

# Check Procfile
if grep -q "app_bukti_setor:app" Procfile; then
    echo "✅ Procfile points to production app"
else
    echo "❌ Procfile misconfigured"
    exit 1
fi

# Check production requirements
if grep -q "easyocr" requirements.txt && grep -q "torch" requirements.txt && grep -q "psycopg2" requirements.txt; then
    echo "✅ Production requirements (OCR + PyTorch + DB)"
else
    echo "❌ Requirements not production-ready"
    exit 1
fi

# Check nixpacks blocking
if [ -f ".nixpacksignore" ] && [ -f ".railwayignore" ]; then
    echo "✅ Nixpacks blocked (.nixpacksignore + .railwayignore)"
else
    echo "❌ Nixpacks not fully blocked"
    exit 1
fi

echo ""
echo "🎯 PRODUCTION DEPLOYMENT READY!"
echo ""
echo "Key fixes applied:"
echo "   ✅ python3.12-distutils installed in Dockerfile"
echo "   ✅ Full production requirements.txt active"
echo "   ✅ app_bukti_setor:app configured everywhere"
echo "   ✅ Nixpacks completely blocked"
echo "   ✅ Health check endpoint available"
echo ""
echo "Expected build results:"
echo "   1. Uses Dockerfile with Python 3.12"
echo "   2. No distutils errors during pip install"
echo "   3. All OCR + PyTorch + Database packages install"
echo "   4. Production app starts on port 8080"
echo ""
echo "🚀 Deploy command:"
echo "   railway up"
echo ""
echo "🔗 Post-deployment test:"
echo "   curl https://your-app.railway.app/health"
