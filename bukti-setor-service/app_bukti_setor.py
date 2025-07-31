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

    # Import and register blueprints (temporarily disabled for basic deployment)
    # from bukti_setor.routes import bukti_setor_bp, laporan_bp
    # app.register_blueprint(bukti_setor_bp)
    # app.register_blueprint(laporan_bp)

    # Health check endpoint
    @app.route('/health', methods=['GET'])
    def health_check():
        """Health check endpoint for Railway"""
        return jsonify({
            'status': 'healthy',
            'service': 'bukti-setor-ocr',
            'version': '2.0.0',
            'ocr_ready': False,  # Will be True after OCR dependencies added
            'database_ready': True
        }), 200

    @app.route('/', methods=['GET'])
    def home():
        """Root endpoint"""
        return jsonify({
            'message': 'Bukti Setor OCR Service - Progressive Deployment',
            'status': 'running',
            'phase': 'Stage 1: Basic Flask + Database',
            'next_phase': 'Stage 2: Add OCR Dependencies',
            'endpoints': {
                'health': '/health'
                # OCR endpoints will be added in Stage 2
            }
        })

    return app

# Create app instance
app = create_app()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)
