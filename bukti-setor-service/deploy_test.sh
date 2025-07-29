#!/bin/bash
# =========================================================================
# FINAL DEPLOYMENT TEST - MINIMAL FLASK APP WITH DOCKERFILE
# =========================================================================

echo "🎯 FINAL RAILWAY DEPLOYMENT TEST"
echo "================================="

echo "📋 Configuration Summary:"
echo "   App: app_test.py (minimal Flask)"
echo "   Requirements: 3 packages only (Flask, gunicorn, python-dotenv)"
echo "   Python: 3.11-slim (forced in Dockerfile)"
echo "   Builder: DOCKERFILE (forced in railway.toml)"
echo "   Nixpacks: COMPLETELY BLOCKED"

echo ""
echo "🔍 Pre-deployment verification:"

# Check critical files
if [ -f "app_test.py" ]; then
    echo "✅ app_test.py exists"
else
    echo "❌ app_test.py missing"
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

if grep -q "app_test:app" Procfile; then
    echo "✅ Procfile points to app_test"
else
    echo "❌ Procfile misconfigured"
    exit 1
fi

echo "✅ Requirements: $(wc -l < requirements.txt) lines"

echo ""
echo "🚀 DEPLOYMENT READY!"
echo ""
echo "Expected results after deployment:"
echo "   1. Build will use Dockerfile (Python 3.11)"
echo "   2. No Nixpacks interference"
echo "   3. No distutils errors"
echo "   4. Health check: GET /health"
echo "   5. Basic test: GET /"
echo ""
echo "Deploy command:"
echo "   railway up"
echo ""
echo "After successful deployment, upgrade to full app:"
echo "   1. Switch back to requirements-current.txt"
echo "   2. Change Procfile to app_bukti_setor:app"
echo "   3. Redeploy"
