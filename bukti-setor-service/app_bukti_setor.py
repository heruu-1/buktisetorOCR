import os
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from config import Config

# Initialize extensions
db = SQLAlchemy()
migrate = Migrate()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Initialize extensions with app
    db.init_app(app)
    migrate.init_app(app, db)
    CORS(app)

    # Import and register blueprints
    from bukti_setor.routes import bukti_setor_bp, laporan_bp
    app.register_blueprint(bukti_setor_bp)
    app.register_blueprint(laporan_bp)

    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health_check():
        """Health check endpoint for Railway"""
        return jsonify({
            'status': 'healthy',
            'service': 'bukti-setor-ocr',
            'version': '2.0.0',
            'ocr_ready': True,  # OCR dependencies now added
            'database_ready': True
        }), 200

    @app.route('/', methods=['GET'])
    def home():
        """Root endpoint"""
        return jsonify({
            'message': 'Bukti Setor OCR Service - Production Version',
            'status': 'running',
            'phase': 'Stage 3: Full OCR Functionality',
            'ocr_enabled': True,
            'endpoints': {
                'health': '/health',
                'upload': '/api/bukti_setor/upload',
                'process': '/api/bukti_setor/process',
                'list': '/api/bukti_setor/list',
                'delete': '/api/bukti_setor/delete/<int:id>',
                'export': '/laporan/export-excel'
            }
        })

    return app

# Create app instance
app = create_app()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)
