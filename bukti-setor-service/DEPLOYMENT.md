# Bukti Setor Service Deployment Guide

## 🚀 Railway Deployment

### Prerequisites

1. Railway CLI installed: `npm install -g @railway/cli`
2. Railway account and project created
3. PostgreSQL database configured (Supabase recommended)

### Quick Deploy

```bash
./deploy.sh
```

### Manual Deployment Steps

1. **Login to Railway**

   ```bash
   railway login
   ```

2. **Link to your project**

   ```bash
   railway link
   ```

3. **Set environment variables**

   ```bash
   railway variables set DATABASE_URL="your_postgresql_url"
   railway variables set SECRET_KEY="your_secret_key"
   railway variables set FLASK_ENV="production"
   ```

4. **Deploy**
   ```bash
   railway up
   ```

### Required Environment Variables

| Variable       | Description                            | Example                               |
| -------------- | -------------------------------------- | ------------------------------------- |
| `DATABASE_URL` | PostgreSQL connection string           | `postgresql://user:pass@host:5432/db` |
| `SECRET_KEY`   | Flask secret key                       | `your-very-secure-secret-key`         |
| `FLASK_ENV`    | Flask environment                      | `production`                          |
| `PORT`         | Application port (auto-set by Railway) | `5002`                                |

### Health Check

After deployment, verify the service is running:

```
GET https://your-app.railway.app/health
```

Expected response:

```json
{
  "status": "healthy",
  "service": "bukti-setor-ocr",
  "ocr_engine": "easyocr",
  "version": "1.0.0"
}
```

### Features

- 📄 PDF and image OCR processing with EasyOCR
- 🇮🇩 Indonesian language support
- 📊 Excel export functionality
- 🔍 Text parsing and validation
- 💾 PostgreSQL database integration
- 🌐 CORS enabled for web integration

### API Endpoints

- `GET /health` - Health check
- `GET /api/info` - Service information
- `POST /api/bukti-setor/process` - Process bukti setor document
- `GET /api/laporan/excel` - Export to Excel

### Troubleshooting

1. **"Dockerfile cannot be empty" error**

   - Fixed: Dockerfile now contains complete EasyOCR configuration

2. **Build timeout**

   - EasyOCR models are pre-downloaded during build
   - Build may take 5-10 minutes for first deployment

3. **Memory issues**

   - Configured with 1 worker and optimized memory settings
   - Uses CPU-only PyTorch for Railway compatibility

4. **Database connection**
   - Ensure DATABASE_URL uses `postgresql://` (not `postgres://`)
   - SSL mode is required for production databases
