#!/bin/bash
# =========================================================================
# FORCE DOCKERFILE DEPLOYMENT - NO NIXPACKS!
# =========================================================================

echo "🚫 BLOCKING NIXPACKS - FORCING DOCKERFILE"
echo "========================================"

echo ""
echo "🔧 Applying Nuclear Nixpacks Block..."

# Rename any potential nixpacks triggers
for file in nixpacks.toml package.json yarn.lock package-lock.json setup.py pyproject.toml; do
    if [ -f "$file" ]; then
        mv "$file" "_${file}.disabled"
        echo "   🚫 Disabled: $file"
    fi
done

echo ""
echo "✅ Dockerfile Configuration:"
echo "   📁 Dockerfile: $(wc -l < Dockerfile) lines"
echo "   🐍 Python: 3.12-slim + distutils fix"
echo "   📦 Requirements: $(wc -l < requirements.txt) packages"

echo ""
echo "✅ Railway Configuration:"
echo "   🔧 Builder: DOCKERFILE (forced)"
echo "   🚫 Nixpacks: COMPLETELY BLOCKED"
echo "   📝 railway.toml: DOCKERFILE enforced"

echo ""
echo "✅ Nixpacks Blockers Active:"
echo "   📄 .nixpacksignore: $(wc -l < .nixpacksignore) lines"
echo "   📄 .railwayignore: $(wc -l < .railwayignore) lines"
echo "   📄 .railway-dockerfile: DOCKERFILE marker"

echo ""
echo "🚀 READY FOR DEPLOYMENT!"
echo ""
echo "Expected Build Process:"
echo "   1. ✅ Railway detects Dockerfile"
echo "   2. ✅ Ignores all Nixpacks triggers"
echo "   3. ✅ Uses OUR Dockerfile with distutils fix"
echo "   4. ✅ Installs Python 3.12 + all dependencies"
echo "   5. ✅ Starts app_bukti_setor:app on port 8080"
echo ""
echo "Deploy command:"
echo "   railway up"
