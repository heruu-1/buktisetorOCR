#!/bin/bash
# =========================================================================
# DEPLOYMENT VALIDATION SCRIPT FOR BUKTI SETOR SERVICE
# =========================================================================

echo "🔍 VALIDATING DEPLOYMENT READINESS..."
echo "=================================="

# Function to check file exists and not empty
check_file() {
    if [ ! -f "$1" ]; then
        echo "❌ $1 - File does not exist"
        return 1
    elif [ ! -s "$1" ]; then
        echo "❌ $1 - File is empty"
        return 1
    else
        echo "✅ $1 - OK ($(wc -l < "$1") lines)"
        return 0
    fi
}

# Function to check file contains specific content
check_content() {
    if grep -q "$2" "$1" 2>/dev/null; then
        echo "✅ $1 contains '$2'"
        return 0
    else
        echo "❌ $1 missing '$2'"
        return 1
    fi
}

# Check critical files
echo "📁 CHECKING CRITICAL FILES:"
check_file "Dockerfile"
check_file "requirements.txt"
check_file "Procfile"
check_file "railway.toml"
check_file "app_bukti_setor.py"
echo ""

# Check Dockerfile content
echo "🐳 CHECKING DOCKERFILE CONTENT:"
check_content "Dockerfile" "FROM python"
check_content "Dockerfile" "app_bukti_setor:app"
check_content "Dockerfile" "EXPOSE 5002"
echo ""

# Check Procfile content
echo "⚙️ CHECKING PROCFILE:"
check_content "Procfile" "app_bukti_setor:app"
check_content "Procfile" "gunicorn"
echo ""

# Check requirements.txt
echo "📦 CHECKING REQUIREMENTS:"
check_content "requirements.txt" "Flask"
check_content "requirements.txt" "easyocr"
check_content "requirements.txt" "gunicorn"
echo ""

# Check Railway config
echo "🚄 CHECKING RAILWAY CONFIG:"
check_content "railway.toml" "DOCKERFILE"
check_content "railway.toml" "healthcheckPath"
echo ""

# Check app health endpoint
echo "💗 CHECKING HEALTH ENDPOINT:"
check_content "app_bukti_setor.py" "/health"
check_content "app_bukti_setor.py" "health_check"
echo ""

# Check line endings
echo "📝 CHECKING LINE ENDINGS:"
if file Dockerfile | grep -q "CRLF"; then
    echo "❌ Dockerfile has Windows line endings (CRLF)"
else
    echo "✅ Dockerfile has Unix line endings (LF)"
fi

if file requirements.txt | grep -q "CRLF"; then
    echo "❌ requirements.txt has Windows line endings (CRLF)"
else
    echo "✅ requirements.txt has Unix line endings (LF)"
fi

echo ""
echo "🎯 DEPLOYMENT RECOMMENDATIONS:"
echo "1. Set environment variables in Railway:"
echo "   - DATABASE_URL (PostgreSQL connection)"
echo "   - SECRET_KEY (secure random string)"
echo "   - FLASK_ENV=production"
echo ""
echo "2. Expected build time: 5-10 minutes (EasyOCR model download)"
echo "3. Memory usage: ~1GB (optimized for Railway)"
echo "4. Health check: GET /health"
echo ""
echo "✅ VALIDATION COMPLETE!"
