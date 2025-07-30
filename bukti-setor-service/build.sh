#!/bin/bash
# RAILWAY BUILD SCRIPT - FORCE DOCKERFILE
echo "Building with Dockerfile.railway..."
docker build -f Dockerfile.railway -t app .
