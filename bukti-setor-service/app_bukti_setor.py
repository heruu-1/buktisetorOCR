import os
from flask import Flask, jsonify, request, send_file
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.utils import secure_filename
import tempfile
import subprocess
from pathlib import Path

app = Flask(__name__)
CORS(app)

# Database configuration
DATABASE_URL = os.getenv('DATABASE_URL', 'sqlite:///bukti_setor.db')
if DATABASE_URL.startswith('postgres://'):
    DATABASE_URL = DATABASE_URL.replace('postgres://', 'postgresql://', 1)

app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

db = SQLAlchemy(app)

# Simple model for demonstration
class BuktiSetor(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)
    upload_date = db.Column(db.DateTime, default=db.func.current_timestamp())
    status = db.Column(db.String(50), default='pending')

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for Railway"""
    return jsonify({
        'status': 'healthy',
        'service': 'bukti-setor-ocr',
        'version': '1.0.0'
    }), 200

@app.route('/', methods=['GET'])
def home():
    """Root endpoint"""
    return jsonify({
        'message': 'Bukti Setor OCR Service',
        'status': 'running',
        'endpoints': {
            'health': '/health',
            'upload': '/api/bukti-setor/upload',
            'data': '/api/bukti-setor/data'
        }
    })

@app.route('/api/bukti-setor/upload', methods=['POST'])
def upload_bukti_setor():
    """Upload and process bukti setor document"""
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file provided'}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({'error': 'No file selected'}), 400
        
        if file:
            filename = secure_filename(file.filename)
            
            # Save to database
            bukti_setor = BuktiSetor(filename=filename, status='uploaded')
            db.session.add(bukti_setor)
            db.session.commit()
            
            return jsonify({
                'message': 'File uploaded successfully',
                'filename': filename,
                'id': bukti_setor.id,
                'status': 'uploaded'
            }), 200
            
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/bukti-setor/data', methods=['GET'])
def get_bukti_setor_data():
    """Get all bukti setor data"""
    try:
        data = BuktiSetor.query.all()
        return jsonify([{
            'id': item.id,
            'filename': item.filename,
            'upload_date': item.upload_date.isoformat() if item.upload_date else None,
            'status': item.status
        } for item in data])
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Create tables
    with app.app_context():
        db.create_all()
    
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)
