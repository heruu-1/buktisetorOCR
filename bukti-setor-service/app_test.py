#!/usr/bin/env python3
# Ultra minimal Flask app for Railway testing

import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "service": "bukti-setor-test",
        "python_version": "3.11",
        "message": "Dockerfile deployment successful!"
    })

@app.route('/')
def home():
    return jsonify({
        "message": "Bukti Setor Service - Railway Deployment Test",
        "status": "running"
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5002))
    app.run(host='0.0.0.0', port=port, debug=False)
