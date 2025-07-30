#!/bin/bash
# =========================================================================
# PRODUCTION DEPLOYMENT - FULL BUKTI SETOR SERVICE
# =========================================================================

echo "🚀 DEPLOYING FULL BUKTI SETOR SERVICE TO RAILWAY"
echo "================================================="

echo "📋 Production Configuration:"
echo "   App: app_bukti_setor.py (full OCR service)"
echo "   Requirements: $(grep -c '^[a-zA-Z]' requirements.txt) packages"
echo "   Python: 3.11-slim (Dockerfile forced)"
echo "   Builder: DOCKERFILE (Nixpacks blocked)"
echo "   Features: EasyOCR, PDF processing, Excel export"

echo ""
echo "🔍 Pre-deployment verification:"

# Check critical files
if [ -f "app_bukti_setor.py" ]; then
    echo "✅ app_bukti_setor.py exists"
else
    echo "❌ app_bukti_setor.py missing"
    exit 1
fi

if [ -f "Dockerfile" ] && [ -s "Dockerfile" ]; then
    echo "✅ Dockerfile exists ($(wc -l < Dockerfile) lines)"
else
    echo "❌ Dockerfile missing or empty"
    exit 1
fi

if grep -q "DOCKERFILE" railway.toml; then
    echo "✅ railway.toml configured for DOCKERFILE"
else
    echo "❌ railway.toml not configured properly"
    exit 1
fi

if grep -q "app_bukti_setor:app" Procfile; then
    echo "✅ Procfile points to app_bukti_setor"
else
    echo "❌ Procfile misconfigured"
    exit 1
fi

# Check dependencies
if grep -q "easyocr" requirements.txt; then
    echo "✅ EasyOCR dependency included"
else
    echo "❌ EasyOCR missing from requirements"
    exit 1
fi

if grep -q "opencv-python-headless" requirements.txt; then
    echo "✅ OpenCV dependency included"
else
    echo "❌ OpenCV missing from requirements"
    exit 1
fi

if grep -q "torch" requirements.txt; then
    echo "✅ PyTorch dependency included"
else
    echo "❌ PyTorch missing from requirements"
    exit 1
fi

echo "✅ Total dependencies: $(grep -c '^[a-zA-Z]' requirements.txt) packages"

echo ""
echo "🚀 PRODUCTION DEPLOYMENT READY!"
echo ""
echo "Expected build time: 8-12 minutes (EasyOCR models download)"
echo "Expected memory usage: ~1.5GB"
echo ""
echo "Endpoints after deployment:"
echo "   GET  /health                    - Health check"
echo "   GET  /api/info                  - Service information"
echo "   POST /api/bukti-setor/process   - Process OCR document"
echo "   GET  /api/laporan/excel         - Export to Excel"
echo ""
echo "Environment variables needed:"
echo "   DATABASE_URL    - PostgreSQL connection string"
echo "   SECRET_KEY      - Flask secret key"
echo "   FLASK_ENV       - production (already set)"
echo ""
echo "Deploy command:"
echo "   railway up"
