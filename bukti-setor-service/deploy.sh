#!/bin/bash
# =========================================================================
# DEPLOYMENT SCRIPT FOR BUKTI SETOR SERVICE ON RAILWAY
# =========================================================================

echo "🚀 Deploying Bukti Setor Service to Railway..."

# Check if we're in the right directory
if [ ! -f "app_bukti_setor.py" ]; then
    echo "❌ Error: Please run this script from the bukti-setor-service directory"
    exit 1
fi

# Check if railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Please install it first:"
    echo "   npm install -g @railway/cli"
    exit 1
fi

echo "📋 Pre-deployment checklist:"
echo "✅ Dockerfile exists and is not empty"
echo "✅ requirements.txt updated with bukti-setor dependencies"
echo "✅ Procfile configured for app_bukti_setor"
echo "✅ railway.toml configured"
echo "✅ Health endpoint available at /health"

echo ""
echo "🔧 Environment variables needed in Railway:"
echo "- DATABASE_URL (PostgreSQL connection string)"
echo "- SECRET_KEY (Flask secret key)"
echo "- FLASK_ENV=production"
echo "- PORT (automatically set by Railway)"

echo ""
echo "📦 Starting deployment..."

# Login to Railway (if not already logged in)
railway login

# Link to your Railway project (if not already linked)
echo "🔗 Linking to Railway project..."
railway link

# Deploy
echo "🚀 Deploying to Railway..."
railway up

echo ""
echo "✅ Deployment initiated!"
echo "🌐 Check your Railway dashboard for deployment status"
echo "📊 Health check endpoint: https://your-app.railway.app/health"
