# Railway Environment Variables yang perlu di-set

# Database (Railway akan auto-generate DATABASE_URL)
DATABASE_URL=postgresql://user:pass@host:port/db

# Flask Configuration
SECRET_KEY=your-very-secret-key-here-change-this-in-production
FLASK_ENV=production

# Upload Configuration
UPLOAD_FOLDER=uploads
MAX_CONTENT_LENGTH=16777216

# OCR Configuration
OCR_CONFIDENCE_THRESHOLD=0.5

# CORS (untuk frontend)
CORS_ORIGINS=*

# Railway Port (auto-set)
PORT=8080
